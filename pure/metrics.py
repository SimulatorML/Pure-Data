"""Valid metrics."""

import datetime
from dataclasses import dataclass
from typing import Any, Dict, List, Union

import numpy as np
import pandas as pd
import pyspark.sql as ps
from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import cross_val_score

from pure.sql_connector import ClickHouseConnector, PostgreSQLConnector, MSSQLConnector


@dataclass
class Metric:
    """Base class for Metric"""

    def __call__(
            self,
            engine: str,
            df: Union[pd.DataFrame, ps.DataFrame, str],
            sql_connector: Union[ClickHouseConnector, PostgreSQLConnector, MSSQLConnector] = None
    ) -> Dict[str, Any]:

        if engine == "pandas":
            return self._call_pandas(df)
        elif engine == "pyspark":
            return self._call_pyspark(df)
        elif engine == "clickhouse":
            return self._call_clickhouse(df, sql_connector)
        elif engine == "postgresql":
            return self._call_postgresql(df, sql_connector)
        elif engine == "mssql":
            return self._call_mssql(df, sql_connector)

        msg = (
            f"Not supported type of 'engine': {engine}. "
            "Supported engines: pandas, pyspark, clickhouse, mssql, postgresql"
        )
        raise NotImplementedError(msg)

    def _call_pandas(self, df: pd.DataFrame) -> Dict[str, Any]:
        return {}

    def _call_pyspark(self, df: ps.DataFrame) -> Dict[str, Any]:
        return {}

    def _call_clickhouse(
            self,
            table_name: str,
            sql_connector: ClickHouseConnector
    ) -> Dict[str, Any]:
        return {}

    def _call_postgresql(
            self,
            table_name: str,
            sql_connector: PostgreSQLConnector
    ) -> Dict[str, Any]:
        return {}

    def _call_mssql(self, table_name: str, sql_connector: MSSQLConnector) -> Dict[str, Any]:
        return {}


@dataclass
class CountTotal(Metric):
    """Total number of rows in DataFrame."""

    def _call_pandas(self, df: pd.DataFrame) -> Dict[str, Any]:
        return {"total": len(df)}

    def _call_pyspark(self, df: ps.DataFrame) -> Dict[str, Any]:
        return {"total": df.count()}

    def _call_clickhouse(
            self,
            table_name: str,
            sql_connector: ClickHouseConnector
    ) -> Dict[str, Any]:
        n = sql_connector.execute(f"select count(*) from {table_name}")[0][0]
        return {"total": n}

    def _call_postgresql(
            self,
            table_name: str,
            sql_connector: PostgreSQLConnector
    ) -> Dict[str, Any]:
        query = f'SELECT COUNT(*) FROM {table_name};'
        n = sql_connector.execute(query).fetchone()[0]

        return {"total": n}

    def _call_mssql(self, table_name: str, sql_connector: MSSQLConnector) -> Dict[str, Any]:
        total = sql_connector.execute(f"SELECT COUNT(*) FROM {table_name}").fetchone()[0]
        return {"total": total}


@dataclass
class CountZeros(Metric):
    """Number of zeros in chosen column.

    Count rows where value in chosen column is equal to zero.
    """

    column: str

    def _call_pandas(self, df: pd.DataFrame) -> Dict[str, Any]:
        n = len(df)
        k = sum(df[self.column] == 0)
        return {"total": n, "count": k, "delta": k / n}

    def _call_pyspark(self, df: ps.DataFrame) -> Dict[str, Any]:
        from pyspark.sql.functions import col

        n = df.count()
        k = df.filter(col(self.column) == 0).count()
        return {"total": n, "count": k, "delta": k / n}

    def _call_clickhouse(
            self,
            table_name: str,
            sql_connector: ClickHouseConnector
    ) -> Dict[str, Any]:
        n = sql_connector.execute(f"select count(*) from {table_name}")[0][0]
        k = sql_connector.execute(f"select countIf({self.column} = 0) from {table_name}")[0][0]
        return {"total": n, "count": k, "delta": k / n}

    def _call_postgresql(
            self,
            table_name: str,
            sql_connector: PostgreSQLConnector
    ) -> Dict[str, Any]:
        query_k = f'SELECT COUNT(*) FROM {table_name} WHERE {self.column} = 0;'
        query_n = f'SELECT COUNT(*) FROM {table_name};'

        k = sql_connector.execute(query_k).fetchone()[0]
        n = sql_connector.execute(query_n).fetchone()[0]

        return {"total": n, "count": k, "delta": k / n}

    def _call_mssql(self, table_name: str, sql_connector: MSSQLConnector) -> Dict[str, Any]:
        zeroes = sql_connector.execute(
            f"SELECT COUNT(*) FROM {table_name} WHERE {self.column} = 0"
        ).fetchone()[0]

        total = sql_connector.execute(f"SELECT COUNT(*) FROM {table_name}").fetchone()[0]

        return {"total": total, "count": zeroes, "delta": zeroes / total}


@dataclass
class CountNull(Metric):
    """Number of empty values in chosen columns.

    If 'aggregation' == 'any', then count rows where
    at least one value from defined 'columns' set is Null.
    If 'aggregation' == 'all', then count rows where
    all values from defined 'columns' set are Null.
    """

    columns: List[str]
    aggregation: str = "any"  # either "all", or "any"

    def __post_init__(self):
        if self.aggregation not in ["all", "any"]:
            raise ValueError("Aggregation must be either 'all' or 'any'.")

    def _call_pandas(self, df: pd.DataFrame) -> Dict[str, Any]:
        n = len(df)
        mask = df[self.columns[0]].isna()
        for column in self.columns[1:]:
            if self.aggregation == "any":
                mask |= df[column].isna()
            elif self.aggregation == "all":
                mask &= df[column].isna()
            else:
                raise ValueError("Unknown value for aggregation")
        k = sum(mask)
        return {"total": n, "count": k, "delta": k / n}

    def _call_pyspark(self, df: ps.DataFrame) -> Dict[str, Any]:
        from pyspark.sql.functions import col, count, isnan, when

        n = df.count()
        column = self.columns[0]
        mask = col(column).isNull() | isnan(col(column))
        for column in self.columns[1:]:
            if self.aggregation == "any":
                mask |= col(column).isNull() | isnan(col(column))
            elif self.aggregation == "all":
                mask &= col(column).isNull() | isnan(col(column))
            else:
                raise ValueError("Unknown value for aggregation")

        k = df.select(count(when(mask, column))).collect()[0][0]

        return {"total": n, "count": k, "delta": k / n}

    def _call_clickhouse(
            self,
            table_name: str,
            sql_connector: ClickHouseConnector
    ) -> Dict[str, Any]:
        n = sql_connector.execute(f"select count(*) from {table_name}")[0][0]
        if self.aggregation == "all":
            sep = "and"
        elif self.aggregation == "any":
            sep = "or"
        else:
            raise ValueError("Unknown value for aggregation")
        try:
            columns_null = f") {sep} (".join(f'isNaN({col})' for col in self.columns)
            query = f"select count(*) from {table_name} where ({columns_null})"
            k = sql_connector.execute(query)[0][0]
            return {"total": n, "count": k, "delta": k / n}
        except Exception as e:
            # check values to be NULL or zero length
            columns_null = f") {sep} (".join(f'isNull({col})' for col in self.columns)
            zero_length = f") {sep} (".join(f"length({col}) = 0" for col in self.columns)
            query = f"select count(*) from {table_name} where ({columns_null})"
            query_zero = f"select count(*) from {table_name} where ({zero_length})"
            k = sql_connector.execute(query)[0][0] + sql_connector.execute(query_zero)[0][0]
            return {"total": n, "count": k, "delta": k / n}

    def _call_postgresql(
            self,
            table_name: str,
            sql_connector: PostgreSQLConnector
    ) -> Dict[str, Any]:
        if self.aggregation == 'any':
            statement = ' OR '.join(f'({col} IS NULL)' for col in self.columns)

        elif self.aggregation == 'all':
            statement = ' AND '.join(f'({col} IS NULL)' for col in self.columns)

        else:
            raise ValueError("Unknown value for aggregation")

        query_k = f'SELECT COUNT(*) FROM {table_name} WHERE {statement};'
        query_n = f'SELECT COUNT(*) FROM {table_name};'

        k = sql_connector.execute(query_k).fetchone()[0]
        n = sql_connector.execute(query_n).fetchone()[0]

        return {"total": n, "count": k, "delta": k / n}

    def _call_mssql(self, table_name: str, sql_connector: MSSQLConnector) -> Dict[str, Any]:
        total = sql_connector.execute(f"SELECT COUNT(*) FROM {table_name}").fetchone()[0]

        if self.aggregation == 'all':
            condition = ""
            for column in self.columns:
                condition += f"{column} IS NULL AND "
            condition = condition[:-5]

            count = sql_connector.execute(
                f"SELECT COUNT(*) FROM {table_name} WHERE {condition}"
            ).fetchone()[0]

        elif self.aggregation == 'any':
            condition = ""
            for column in self.columns:
                condition += f"{column} IS NULL OR "
            condition = condition[:-4]

            count = sql_connector.execute(
                f"SELECT COUNT(*) FROM {table_name} WHERE {condition}"
            ).fetchone()[0]

        else:
            raise ValueError("Unknown value for aggregation")

        return {"total": total, "count": count, "delta": count / total}


@dataclass
class CountDuplicates(Metric):
    """Number of duplicates in chosen columns."""

    columns: List[str]

    def _call_pandas(self, df: pd.DataFrame) -> Dict[str, Any]:
        n = len(df)
        m = len(df.drop_duplicates(subset=self.columns))
        k = n - m
        return {"total": n, "count": k, "delta": k / n}

    def _call_pyspark(self, df: ps.DataFrame) -> Dict[str, Any]:
        from pyspark.sql.functions import countDistinct

        n = df.count()
        m = df.select(countDistinct(*self.columns)).collect()[0][0]
        k = n - m
        return {"total": n, "count": k, "delta": k / n}

    def _call_clickhouse(
            self,
            table_name: str,
            sql_connector: ClickHouseConnector
    ) -> Dict[str, Any]:
        n = sql_connector.execute(f"select count(*) from {table_name}")[0][0]
        table_columns = ','.join(f"{col}" for col in self.columns)
        subquery = f"select count(*) - 1 as duplicates_count" \
                   f" from {table_name} " \
                   f"group by {table_columns}" \
                   f" having " \
                   f"duplicates_count > 0 "
        query = f"SELECT SUM(duplicates_count) AS total_duplicates_count from ({subquery}) subquery"
        k = sql_connector.execute(query)[0][0]
        return {"total": n, "count": k, "delta": k / n}

    def _call_postgresql(
            self,
            table_name: str,
            sql_connector: PostgreSQLConnector
    ) -> Dict[str, Any]:
        statement = ', '.join(f'{col}' for col in self.columns)

        query_k = f'SELECT SUM(cnt - 1)::float FROM ( \
                            SELECT {statement}, COUNT(*) as cnt \
                            FROM {table_name} \
                            GROUP BY {statement} \
                            HAVING COUNT(*) > 1 \
                            ) as duplicates;'

        query_n = f'SELECT COUNT(*) FROM {table_name};'

        sql_connector.execute(query_k)
        k = sql_connector.conn.fetchone()[0]

        sql_connector.execute(query_n)
        n = sql_connector.conn.fetchone()[0]

        return {"total": n, "count": k, "delta": k / n}

    def _call_mssql(self, table_name: str, sql_connector: MSSQLConnector) -> Dict[str, Any]:
        unique = sql_connector.execute(
            f"SELECT COUNT(*) FROM (SELECT DISTINCT {', '.join(self.columns)} FROM {table_name}) t"
        ).fetchone()[0]
        total = sql_connector.execute(f"SELECT COUNT(*) FROM {table_name}").fetchone()[0]
        duplicates = total - unique

        return {"total": total, "count": duplicates, "delta": duplicates / total}


@dataclass
class CountValue(Metric):
    """Number of values in chosen column.

    Count rows that value in chosen column is equal to 'value'.
    """

    column: str
    value: Union[str, int, float]

    def _call_pandas(self, df: pd.DataFrame) -> Dict[str, Any]:
        n = len(df)
        k = sum(df[self.column] == self.value)
        return {"total": n, "count": k, "delta": k / n}

    def _call_pyspark(self, df: ps.DataFrame) -> Dict[str, Any]:
        from pyspark.sql.functions import col

        n = df.count()
        k = df.filter(col(self.column) == self.value).count()
        return {"total": n, "count": k, "delta": k / n}

    def _call_clickhouse(
            self,
            table_name: str,
            sql_connector: ClickHouseConnector
    ) -> Dict[str, Any]:
        n = sql_connector.execute(f"select count(*) from {table_name}")[0][0]
        try:
            query = f"select count(*)" \
                    f" from {table_name}" \
                    f" where toDate({self.column}) = toDate('{self.value}')"
            k = sql_connector.execute(query)[0][0]
            return {"total": n, "count": k, "delta": k / n}
        except Exception as e:
            try:
                query = f"select count(*) from {table_name} where {self.column} = {self.value}"
                k = sql_connector.execute(query)[0][0]
                return {"total": n, "count": k, "delta": k / n}
            except Exception as e:
                print(e)

    def _call_postgresql(
            self,
            table_name: str,
            sql_connector: PostgreSQLConnector
    ) -> Dict[str, Any]:

        query_k = f'SELECT COUNT(*) FROM {table_name} ' \
                  f"WHERE {self.column} = '{self.value}';"
        query_n = f'SELECT COUNT(*) FROM {table_name};'

        sql_connector.execute(query_k)
        k = sql_connector.conn.fetchone()[0]

        sql_connector.execute(query_n)
        n = sql_connector.conn.fetchone()[0]

        return {"total": n, "count": k, "delta": k / n}

    def _call_mssql(self, table_name: str, sql_connector: MSSQLConnector) -> Dict[str, Any]:
        total = sql_connector.execute(f"SELECT COUNT(*) FROM {table_name}").fetchone()[0]
        if isinstance(self.value, str):
            value = sql_connector.execute(
                f"SELECT COUNT({self.column}) "
                f"FROM {table_name} "
                f"WHERE {self.column} = '{self.value}'"
            ).fetchone()[0]
        else:
            value = sql_connector.execute(
                f"SELECT COUNT({self.column}) FROM {table_name} WHERE {self.column} = {self.value}"
            ).fetchone()[0]
        return {"total": total, "count": value, "delta": value / total}


@dataclass
class CountBelowValue(Metric):
    """Number of values below threshold.

    Count values in chosen column
    that are lower than defined threshold ('value').
    If 'strict' == False, then inequality is non-strict.
    """

    column: str
    value: float
    strict: bool = True

    def _call_pandas(self, df: pd.DataFrame) -> Dict[str, Any]:
        n = len(df)
        if self.strict:
            k = sum(df[self.column] < self.value)
        else:
            k = sum(df[self.column] <= self.value)
        return {"total": n, "count": k, "delta": k / n}

    def _call_pyspark(self, df: ps.DataFrame) -> Dict[str, Any]:
        from pyspark.sql.functions import col

        n = df.count()
        if self.strict:
            k = df.filter(col(self.column) < self.value).count()
        else:
            k = df.filter(col(self.column) <= self.value).count()
        return {"total": n, "count": k, "delta": k / n}

    def _call_clickhouse(
            self,
            table_name: str,
            sql_connector: ClickHouseConnector
    ) -> Dict[str, Any]:
        n = sql_connector.execute(f"select count(*) from {table_name}")[0][0]
        if not self.strict:
            ineq = "<="
        else:
            ineq = "<"
        query = f"select count(*) from {table_name} where {self.column} {ineq} {self.value}"
        k = sql_connector.execute(query)[0][0]
        return {"total": n, "count": k, "delta": k / n}

    def _call_postgresql(
            self,
            table_name: str,
            sql_connector: PostgreSQLConnector
    ) -> Dict[str, Any]:
        if self.strict:
            query_k = f'SELECT COUNT(*) FROM {table_name} ' \
                      f'WHERE {self.column} < {self.value};'
        else:
            query_k = f'SELECT COUNT(*) FROM {table_name} ' \
                      f'WHERE {self.column} <= {self.value};'

        query_n = f'SELECT COUNT(*) FROM {table_name};'

        sql_connector.execute(query_k)
        k = sql_connector.conn.fetchone()[0]

        sql_connector.execute(query_n)
        n = sql_connector.conn.fetchone()[0]

        return {"total": n, "count": k, "delta": k / n}

    def _call_mssql(self, df: str, sql_connector: MSSQLConnector) -> Dict[str, Any]:
        total = sql_connector.execute(f"SELECT COUNT(*) FROM {df}").fetchone()[0]

        if self.strict:
            value = sql_connector.execute(
                f"SELECT COUNT({self.column}) "
                f"FROM {df} "
                f"WHERE {self.column} < {self.value}"
            ).fetchone()[0]
        else:
            value = sql_connector.execute(
                f"SELECT COUNT({self.column}) "
                f"FROM {df} "
                f"WHERE {self.column} <= {self.value}"
            ).fetchone()[0]

        return {"total": total, "count": value, "delta": value / total}


@dataclass
class CountBelowColumn(Metric):
    """Count how often column X below Y.

    Calculate number of rows that value in 'column_x'
    is lower than value in 'column_y'.
    """

    column_x: str
    column_y: str
    strict: bool = True

    def _call_pandas(self, df: pd.DataFrame) -> Dict[str, Any]:
        n = len(df)
        if self.strict:
            k = sum(df[self.column_x] < df[self.column_y])
        else:
            k = sum(df[self.column_x] <= df[self.column_y])
        return {"total": n, "count": k, "delta": k / n}

    def _call_pyspark(self, df: ps.DataFrame) -> Dict[str, Any]:
        from pyspark.sql.functions import col, isnan

        n = df.count()

        mask = isnan(col(self.column_x)) | col(self.column_x).isNull()
        mask |= isnan(col(self.column_y)) | col(self.column_y).isNull()
        df = df.filter(~mask)

        if self.strict:
            k = df.filter(col(self.column_x) < col(self.column_y)).count()
        else:
            k = df.filter(col(self.column_x) <= col(self.column_y)).count()
        return {"total": n, "count": k, "delta": k / n}

    def _call_clickhouse(
            self,
            table_name: str,
            sql_connector: ClickHouseConnector
    ) -> Dict[str, Any]:
        n = sql_connector.execute(f"select count(*) from {table_name}")[0][0]
        if not self.strict:
            ineq = "<="
        else:
            ineq = "<"
        query = f"select count(*) from {table_name} where {self.column_x} {ineq} {self.column_y}"
        k = sql_connector.execute(query)[0][0]
        return {"total": n, "count": k, "delta": k / n}

    def _call_postgresql(
            self,
            table_name: str,
            sql_connector: PostgreSQLConnector
    ) -> Dict[str, Any]:
        if self.strict:
            query_k = f'SELECT COUNT(*) FROM {table_name} ' \
                      f'WHERE {self.column_x} < {self.column_y};'
        else:
            query_k = f'SELECT COUNT(*) FROM {table_name} ' \
                      f'WHERE {self.column_x} <= {self.column_y};'

        query_n = f'SELECT COUNT(*) FROM {table_name};'

        sql_connector.execute(query_k)
        k = sql_connector.conn.fetchone()[0]

        sql_connector.execute(query_n)
        n = sql_connector.conn.fetchone()[0]

        return {"total": n, "count": k, "delta": k / n}

    def _call_mssql(self, table_name: str, sql_connector: MSSQLConnector) -> Dict[str, Any]:
        total = sql_connector.execute(f"SELECT COUNT(*) FROM {table_name}").fetchone()[0]

        if self.strict:
            count = sql_connector.execute(
                f"SELECT COUNT(*) FROM {table_name} WHERE {self.column_x} < {self.column_y}"
            ).fetchone()[0]
        else:
            count = sql_connector.execute(
                f"SELECT COUNT(*) FROM {table_name} WHERE {self.column_x} <= {self.column_y}"
            ).fetchone()[0]

        return {"total": total, "count": count, "delta": count / total}


@dataclass
class CountRatioBelow(Metric):
    """Count how often X / Y below Z.

    Calculate number of rows that ratio of values
    in columns 'column_x' and 'column_y' is lower than value in 'column_z'.
    If 'strict' == False, then inequality is non-strict.
    """

    column_x: str
    column_y: str
    column_z: str
    strict: bool = False

    def _call_pandas(self, df: pd.DataFrame) -> Dict[str, Any]:
        n = len(df)
        ratio = df[self.column_x] / df[self.column_y]
        if self.strict:
            k = sum(ratio < df[self.column_z])
        else:
            k = sum(ratio <= df[self.column_z])
        return {"total": n, "count": k, "delta": k / n}

    def _call_pyspark(self, df: ps.DataFrame) -> Dict[str, Any]:
        from pyspark.sql.functions import col, isnan

        n = df.count()

        mask = isnan(col(self.column_x)) | col(self.column_x).isNull()
        mask |= isnan(col(self.column_y)) | col(self.column_y).isNull()
        mask |= isnan(col(self.column_z)) | col(self.column_z).isNull()
        df = df.filter(~mask)

        ratio = col(self.column_x) / col(self.column_y)
        if self.strict:
            k = df.filter(ratio < col(self.column_z)).count()
        else:
            k = df.filter(ratio <= col(self.column_z)).count()
        return {"total": n, "count": k, "delta": k / n}

    def _call_clickhouse(
            self,
            table_name: str,
            sql_connector: ClickHouseConnector
    ) -> Dict[str, Any]:
        n = sql_connector.execute(f"select count(*) from {table_name}")[0][0]
        if not self.strict:
            ineq = "<="
        else:
            ineq = "<"
        query = f"select count(*)" \
                f" from {table_name}" \
                f" where {self.column_x} / {self.column_y} {ineq} {self.column_z}"
        k = sql_connector.execute(query)[0][0]
        return {"total": n, "count": k, "delta": k / n}

    def _call_postgresql(
            self,
            table_name: str,
            sql_connector: PostgreSQLConnector
    ) -> Dict[str, Any]:
        if self.strict:
            query_k = f'SELECT COUNT(*) FROM {table_name} ' \
                      f'WHERE {self.column_x}/{self.column_y} < {self.column_z}' \
                      f' AND {self.column_y} != 0;'
        else:
            query_k = f'SELECT COUNT(*) FROM {table_name} ' \
                      f'WHERE {self.column_x}/{self.column_y} <= {self.column_z}' \
                      f' AND {self.column_y} != 0;'

        query_n = f'SELECT COUNT(*) FROM {table_name};'

        sql_connector.execute(query_k)
        k = sql_connector.conn.fetchone()[0]

        sql_connector.execute(query_n)
        n = sql_connector.conn.fetchone()[0]

        return {"total": n, "count": k, "delta": k / n}

    def _call_mssql(self, table_name: str, sql_connector: MSSQLConnector) -> Dict[str, Any]:
        total = sql_connector.execute(f"SELECT COUNT(*) FROM {table_name}").fetchone()[0]

        if self.strict:
            count = sql_connector.execute(
                f"SELECT COUNT(*) "
                f"FROM {table_name} "
                f"WHERE {self.column_y} != 0 "
                f"AND {self.column_x} / {self.column_y} < {self.column_z}"
            ).fetchone()[0]
        else:
            count = sql_connector.execute(
                f"SELECT COUNT(*) "
                f"FROM {table_name} "
                f"WHERE {self.column_y} != 0 "
                f"AND {self.column_x} / {self.column_y} <= {self.column_z}"
            ).fetchone()[0]

        return {"total": total, "count": count, "delta": count / total}


@dataclass
class CountCB(Metric):
    """Lower/upper bounds for N%-confidence interval.

    Calculate bounds for 'conf'-percent interval in chosen column.
    """

    column: str
    conf: float = 0.95

    def __post_init__(self):
        if not 0 <= self.conf <= 1:
            raise ValueError("Confident leven should be in the interval [0, 1]")

    def _call_pandas(self, df: pd.DataFrame) -> Dict[str, Any]:
        alpha = 1 - self.conf
        lcb = df[self.column].quantile(alpha / 2)
        ucb = df[self.column].quantile(alpha / 2 + self.conf)
        return {"lcb": lcb, "ucb": ucb}

    def _call_pyspark(self, df: ps.DataFrame) -> Dict[str, Any]:
        from pyspark.sql import DataFrameStatFunctions

        alpha = 1 - self.conf
        st = DataFrameStatFunctions(df)
        ci = st.approxQuantile(self.column, [alpha / 2, self.conf + alpha / 2], 0)
        return {"lcb": ci[0], "ucb": ci[1]}

    def _call_clickhouse(
            self,
            table_name: str,
            sql_connector: ClickHouseConnector
    ) -> Dict[str, Any]:
        alpha = 1 - self.conf
        lcb = sql_connector.execute(f"select quantileExact({alpha / 2})({self.column})"
                                    f" from {table_name}"
                                    )[0][0]
        ucb = sql_connector.execute(
            f"select quantileExact({alpha / 2 + self.conf})({self.column}) from {table_name}"
        )[0][0]
        return {"lcb": lcb, "ucb": ucb}

    def _call_postgresql(
            self,
            table_name: str,
            sql_connector: PostgreSQLConnector
    ) -> Dict[str, Any]:
        alpha = 1 - self.conf
        lcb_per = alpha / 2
        ucb_per = 1 - alpha / 2

        query_k = f'SELECT percentile_disc({lcb_per}) WITHIN GROUP ' \
                  f'(ORDER BY {self.column}) AS p FROM {table_name};'
        query_n = f'SELECT percentile_disc({ucb_per}) WITHIN GROUP ' \
                  f'(ORDER BY {self.column}) AS p FROM {table_name};'

        sql_connector.execute(query_k)
        lcb = sql_connector.conn.fetchone()[0]

        sql_connector.execute(query_n)
        ucb = sql_connector.conn.fetchone()[0]

        return {"lcb": lcb, "ucb": ucb}

    def _call_mssql(self, table_name: str, sql_connector: MSSQLConnector) -> Dict[str, Any]:
        alpha = 1 - self.conf
        lcb = sql_connector.execute(
            f"SELECT PERCENTILE_DISC({alpha / 2}) WITHIN GROUP (ORDER BY {table_name}) OVER()"
            f" FROM {table_name}"
        ).fetchone()[0]
        ucb = sql_connector.execute(
            f"SELECT PERCENTILE_DISC({alpha / 2 + self.conf})"
            f" WITHIN GROUP (ORDER BY {table_name}) OVER() "
            f"FROM {table_name}"
        ).fetchone()[0]

        return {"lcb": lcb, "ucb": ucb}


@dataclass
class CountLag(Metric):
    """A lag between last date and today.

    Define last date in chosen date column.
    Calculate a lag in days between last date and today.
    """

    column: str
    fmt: str = "%Y-%m-%d"

    def _call_pandas(self, df: pd.DataFrame) -> Dict[str, Any]:
        a = datetime.datetime.now()
        b = pd.to_datetime(df[self.column]).max()
        lag = (a - b).days
        a = a.strftime(self.fmt)
        b = b.strftime(self.fmt)
        return {"today": a, "last_day": b, "lag": lag}

    def _call_pyspark(self, df: ps.DataFrame) -> Dict[str, Any]:
        from pyspark.sql.functions import col, max

        a = datetime.datetime.now()
        b = df.select(max(col(self.column))).collect()[0][0]
        b = datetime.datetime.strptime(b, "%Y-%m-%d")

        lag = (a - b).days
        a = a.strftime(self.fmt)
        b = b.strftime(self.fmt)
        return {"today": a, "last_day": b, "lag": lag}

    def _call_clickhouse(
            self,
            table_name: str,
            sql_connector: ClickHouseConnector
    ) -> Dict[str, Any]:
        today = sql_connector.execute(f"select today()")[0][0]
        query = f"select toDate({self.column}) as dt from {table_name} order by dt desc limit 1"
        last_day = sql_connector.execute(query)[0][0]
        lag = sql_connector.execute(
            f"select dateDiff('day', toDate('{last_day}'), toDate('{today}'))"
        )[0][0]
        return {"today": str(today), "last_day": str(last_day), "lag": lag}

    def _call_postgresql(
            self,
            table_name: str,
            sql_connector: PostgreSQLConnector
    ) -> Dict[str, Any]:
        query_today = "SELECT TO_CHAR(CURRENT_DATE, 'YYYY-MM-DD');"
        query_last = f"SELECT TO_CHAR({self.column}, 'YYYY-MM-DD') AS dt " \
                     f'FROM {table_name} ORDER BY dt DESC LIMIT 1'

        sql_connector.execute(query_today)
        today = sql_connector.conn.fetchone()[0]

        sql_connector.execute(query_last)
        last_day = sql_connector.conn.fetchone()[0]

        query_lag = f"SELECT '{today}'::DATE - '{last_day}'::DATE AS lag"

        sql_connector.execute(query_lag)
        lag = sql_connector.conn.fetchone()[0]

        return {"today": today, "last_day": last_day, "lag": lag}

    def _call_mssql(self, table_name: str, sql_connector: MSSQLConnector) -> Dict[str, Any]:
        a = datetime.datetime.now()
        b = sql_connector.execute(f"SELECT MAX({self.column}) FROM {table_name}").fetchone()[0]
        lag = (a - b).days
        a = a.strftime(self.fmt)
        b = b.strftime(self.fmt)

        return {"today": a, "last_day": b, "lag": lag}


@dataclass
class CountGreaterValue(Metric):
    """Number of values greater than threshold.

    Count values in chosen column
    that are greater than defined threshold ('value').
    If 'strict' == False, then inequality is non-strict.
    """

    column: str
    value: float
    strict: bool = False

    def _call_pandas(self, df: pd.DataFrame) -> Dict[str, Any]:
        n = len(df)
        if self.strict:
            k = sum(df[self.column] > self.value)
        else:
            k = sum(df[self.column] >= self.value)
        return {"total": n, "count": k, "delta": k / n}

    def _call_pyspark(self, df: ps.DataFrame) -> Dict[str, Any]:
        from pyspark.sql.functions import col, isnan

        n = df.count()
        mask = isnan(col(self.column)) | col(self.column).isNull()
        df = df.filter(~mask)
        if self.strict:
            k = df.filter(col(self.column) > self.value).count()
        else:
            k = df.filter(col(self.column) >= self.value).count()
        return {"total": n, "count": k, "delta": k / n}

    def _call_clickhouse(
            self,
            table_name: str,
            sql_connector: ClickHouseConnector
    ) -> Dict[str, Any]:
        n = sql_connector.execute(f"select count(*) from {table_name}")[0][0]
        if not self.strict:
            ineq = ">="
        else:
            ineq = ">"
        query = f"select count(*) from {table_name} where {self.column} {ineq} {self.value}"
        k = sql_connector.execute(query)[0][0]
        return {"total": n, "count": k, "delta": k / n}

    def _call_postgresql(
            self,
            table_name: str,
            sql_connector: PostgreSQLConnector
    ) -> Dict[str, Any]:
        if self.strict:
            query_k = f'SELECT COUNT(*) FROM {table_name} ' \
                      f'WHERE {self.column} > {self.value};'
        else:
            query_k = f'SELECT COUNT(*) FROM {table_name} ' \
                      f'WHERE {self.column} >= {self.value};'

        query_n = f'SELECT COUNT(*) FROM {table_name};'

        sql_connector.execute(query_k)
        k = sql_connector.conn.fetchone()[0]

        sql_connector.execute(query_n)
        n = sql_connector.conn.fetchone()[0]

        return {"total": n, "count": k, "delta": k / n}

    def _call_mssql(self, table_name: str, sql_connector: MSSQLConnector) -> Dict[str, Any]:
        total = sql_connector.execute(f"SELECT COUNT(*) FROM {table_name}").fetchone()[0]

        if self.strict:
            count = sql_connector.execute(
                f"SELECT COUNT(*) FROM {table_name} WHERE {self.column}  > {self.value}"
            ).fetchone()[0]

        else:
            count = sql_connector.execute(
                f"SELECT COUNT(*) FROM {table_name} WHERE {self.column}  >= {self.value}"
            ).fetchone()[0]

        return {"total": total, "count": count, "delta": count / total}


@dataclass
class CountValueIndSet(Metric):
    """Number of values that satisfy possible values set.

    Count values in chosen column
    that are included in the given list ('required_set').
    """

    column: str
    required_set: List

    def _call_pandas(self, df: pd.DataFrame) -> Dict[str, Any]:
        n = len(df)
        k = (df[self.column].isin(self.required_set)).sum()
        return {"total": n, "count": k, "delta": k / n}

    def _call_pyspark(self, df: ps.DataFrame) -> Dict[str, Any]:
        n = df.count()
        from pyspark.sql.functions import col

        k = df.filter(col(self.column).isin(self.required_set)).count()
        return {"total": n, "count": k, "delta": k / n}

    def _call_clickhouse(
            self,
            table_name: str,
            sql_connector: ClickHouseConnector
    ) -> Dict[str, Any]:
        n = sql_connector.execute(f"select count(*) from {table_name}")[0][0]
        query = f"select countIf({self.column} in {self.required_set}) as cnt from {table_name}"
        k = sql_connector.execute(query)[0][0]
        return {"total": n, "count": k, "delta": k / n}

    def _call_postgresql(
            self,
            table_name: str,
            sql_connector: PostgreSQLConnector
    ) -> Dict[str, Any]:
        query_k = f'SELECT COUNT(*) FROM {table_name} ' \
                  f'WHERE {self.column} IN {tuple(self.required_set)};'
        query_n = f'SELECT COUNT(*) FROM {table_name};'

        sql_connector.execute(query_k)
        k = sql_connector.conn.fetchone()[0]

        sql_connector.execute(query_n)
        n = sql_connector.conn.fetchone()[0]

        return {"total": n, "count": k, "delta": k / n}

    def _call_mssql(self, table_name: str, sql_connector: MSSQLConnector) -> Dict[str, Any]:
        total = sql_connector.execute(f"SELECT COUNT(*) FROM {table_name}").fetchone()[0]

        condition = ""
        for value in self.required_set:
            condition += f"{self.column} LIKE '{value}' COLLATE SQL_Latin1_General_CP1_CS_AS OR "
        condition = condition[:-3]

        count = sql_connector.execute(
            f"SELECT COUNT(*) FROM {table_name} WHERE {condition}"
        ).fetchone()[0]

        return {"total": total, "count": count, "delta": count / total}


@dataclass
class CountValueInBounds(Metric):
    """Number of values that are inside available bounds.

    Count values in chosen column that do satisfy defined bounds:
    they are greater than 'lower_bound' or lower than 'upper_bound'.
    If 'strict' is False, then inequalities are non-strict.
    """

    column: str
    lower_bound: float
    upper_bound: float
    strict: bool = False

    def __post_init__(self):
        if self.lower_bound > self.upper_bound:
            raise ValueError("Lower bound must be lower than upper bound.")

    def _call_pandas(self, df: pd.DataFrame) -> Dict[str, Any]:
        n = len(df)
        if self.strict:
            k = (
                (df[self.column] < self.upper_bound)
                & (df[self.column] > self.lower_bound)
            ).sum()
        else:
            k = (
                (df[self.column] <= self.upper_bound)
                & (df[self.column] >= self.lower_bound)
            ).sum()
        return {"total": n, "count": k, "delta": k / n}

    def _call_pyspark(self, df: ps.DataFrame) -> Dict[str, Any]:
        from pyspark.sql.functions import col

        n = df.count()
        if self.strict:
            k = df.filter(
                (col(self.column) < self.upper_bound)
                & (col(self.column) > self.lower_bound)
            ).count()
        else:
            k = df.filter(
                (col(self.column) <= self.upper_bound)
                & (col(self.column) >= self.lower_bound)
            ).count()
        return {"total": n, "count": k, "delta": k / n}

    def _call_clickhouse(
            self,
            table_name: str,
            sql_connector: ClickHouseConnector
    ) -> Dict[str, Any]:
        n = sql_connector.execute(f"select count(*) from {table_name}")[0][0]
        if not self.strict:
            ineq_1, ineq_2 = ">=", "<="
        else:
            ineq_1, ineq_2 = ">", "<"
        query = f"select countIf({self.column} {ineq_1} {self.lower_bound} and " \
                f"{self.column} {ineq_2} {self.upper_bound}) as cnt from {table_name}"
        k = sql_connector.execute(query)[0][0]
        return {"total": n, "count": k, "delta": k / n}

    def _call_postgresql(
            self,
            table_name: str,
            sql_connector: PostgreSQLConnector
    ) -> Dict[str, Any]:
        if self.strict:
            query_k = f'SELECT COUNT(*) FROM {table_name} ' \
                      f'WHERE {self.column} > {self.lower_bound} ' \
                      f'AND {self.column} < {self.upper_bound};'

        else:
            query_k = f'SELECT COUNT(*) FROM {table_name} ' \
                      f'WHERE {self.column} >= {self.lower_bound} ' \
                      f'AND {self.column} <= {self.upper_bound};'

        query_n = f'SELECT COUNT(*) FROM {table_name};'

        sql_connector.execute(query_k)
        k = sql_connector.conn.fetchone()[0]

        sql_connector.execute(query_n)
        n = sql_connector.conn.fetchone()[0]

        return {"total": n, "count": k, "delta": k / n}

    def _call_mssql(self, table_name: str, sql_connector: MSSQLConnector) -> Dict[str, Any]:
        total = sql_connector.execute(f"SELECT COUNT(*) FROM {table_name}").fetchone()[0]

        if self.strict:
            count = sql_connector.execute(
                "SELECT COUNT(*) "
                f"FROM {table_name} "
                f"WHERE {self.column} > {self.lower_bound} AND {self.column} < {self.upper_bound}"
            ).fetchone()[0]

        else:
            count = sql_connector.execute(
                f"SELECT COUNT(*) "
                f"FROM {table_name} "
                f"WHERE {self.column} BETWEEN {self.lower_bound} AND {self.upper_bound}"
            ).fetchone()[0]

        return {"total": total, "count": count, "delta": count / total}


@dataclass
class CountExtremeValuesFormula(Metric):
    """Number of extreme values calculated by formula.

    Calculate mean and std in chosen column.
    Count values in chosen column that are
    greater than mean + std_coef * std if style == 'greater',
    lower than mean - std_coef * std if style == 'lower'.
    """

    column: str
    std_coef: int
    style: str = "greater"

    def __post_init__(self):
        if self.style not in ["greater", "lower"]:
            raise ValueError("Style must be either 'greater' or 'lower'.")

    def _call_pandas(self, df: pd.DataFrame) -> Dict[str, Any]:
        n = len(df)
        mean, std = df[self.column].mean(), df[self.column].std()
        if self.style == "greater":
            k = (df[self.column] > (mean + self.std_coef * std)).sum()
        else:
            k = (df[self.column] < (mean - self.std_coef * std)).sum()
        return {"total": n, "count": k, "delta": k / n}

    def _call_pyspark(self, df: ps.DataFrame) -> Dict[str, Any]:
        from pyspark.sql.functions import col, isnan
        from pyspark.sql.functions import mean as mean_
        from pyspark.sql.functions import stddev

        n = df.count()

        mask = isnan(col(self.column)) | col(self.column).isNull()
        df = df.filter(~mask)

        df_stats = df.select(
            mean_(col(self.column)).alias("mean"), stddev(col(self.column)).alias("std")
        ).collect()
        mean = df_stats[0]["mean"]
        std = df_stats[0]["std"]
        if self.style == "greater":
            k = df.filter(col(self.column) > (mean + self.std_coef * std)).count()
        else:
            k = df.filter(col(self.column) < (mean - self.std_coef * std)).count()
        return {"total": n, "count": k, "delta": k / n}

    def _call_clickhouse(
            self,
            table_name: str,
            sql_connector: ClickHouseConnector
    ) -> Dict[str, Any]:
        n = sql_connector.execute(f"select count(*) from {table_name}")[0][0]
        sub_query = f"select {self.column} from {table_name} where isFinite({self.column})"
        mean = sql_connector.execute(f"select avg({self.column}) from ({sub_query})")[0][0]
        std = sql_connector.execute(
            f"select stddevPopStable({self.column}) from ({sub_query})"
        )[0][0]
        if self.style == "greater":
            query = f"select count(*)" \
                    f" from ({sub_query})" \
                    f" where {self.column} > {mean + std * self.std_coef}"
        else:
            query = f"select count(*)" \
                    f" from ({sub_query})" \
                    f" where {self.column} < {mean - std * self.std_coef}"
        k = sql_connector.execute(query)[0][0]
        return {"total": n, "count": k, "delta": k / n}

    def _call_postgresql(
            self,
            table_name: str,
            sql_connector: PostgreSQLConnector
    ) -> Dict[str, Any]:
        query_mean = f'SELECT AVG({self.column}) FROM {table_name};'
        sql_connector.execute(query_mean)
        mean = sql_connector.conn.fetchone()[0]

        query_std = f'SELECT STDDEV({self.column}) FROM {table_name};'
        sql_connector.execute(query_std)
        std = sql_connector.conn.fetchone()[0]

        if self.style == 'greater':
            query_k = f'SELECT COUNT(*) FROM {table_name} ' \
                      f'WHERE {self.column} > {mean + std * self.std_coef};'

        else:
            query_k = f'SELECT COUNT(*) FROM {table_name} ' \
                      f'WHERE {self.column} < {mean - std * self.std_coef};'

        query_n = f'SELECT COUNT(*) FROM {table_name};'

        sql_connector.execute(query_k)
        k = sql_connector.conn.fetchone()[0]

        sql_connector.execute(query_n)
        n = sql_connector.conn.fetchone()[0]

        return {"total": n, "count": k, "delta": k / n}

    def _call_mssql(self, table_name: str, sql_connector: MSSQLConnector) -> Dict[str, Any]:
        total = sql_connector.execute(f"SELECT COUNT(*) FROM {table_name}").fetchone()[0]
        mean = sql_connector.execute(
            f"SELECT AVG(CAST({self.column} AS FLOAT)) FROM {table_name}"
        ).fetchone()[0]
        std = sql_connector.execute(f"SELECT STDEV({self.column}) FROM {table_name}").fetchone()[0]

        if self.style == "greater":
            count = sql_connector.execute(
                f"SELECT COUNT({self.column}) "
                f"FROM {table_name} "
                f"WHERE {self.column} > {mean + std * self.std_coef}"
            ).fetchone()[0]

        else:
            count = sql_connector.execute(
                f"SELECT COUNT({self.column}) "
                f"FROM {table_name} "
                f"WHERE {self.column} < {mean - std * self.std_coef}"
            ).fetchone()[0]

        return {"total": total, "count": count, "delta": count / total}


@dataclass
class CountExtremeValuesQuantile(Metric):
    """Number of extreme values calculated with quantile.

    Calculate quantile in chosen column.
    If style == 'greater', then count values in 'column' that are greater than
    calculated quantile. Otherwise, if style == 'lower', count values that are lower
    than calculated quantile.
    """

    column: str
    q: float = 0.8
    style: str = "greater"

    def __post_init__(self):
        if self.style not in ["greater", "lower"]:
            raise ValueError("Style must be either 'greater' or 'lower'.")
        if not 0 <= self.q <= 1:
            raise ValueError("Quantile should be in the interval [0, 1]")

    def _call_pandas(self, df: pd.DataFrame) -> Dict[str, Any]:
        n = len(df)
        quantile_value = df[self.column].quantile(self.q)
        if self.style == "greater":
            k = (df[self.column] > quantile_value).sum()
        else:
            k = (df[self.column] < quantile_value).sum()
        return {"total": n, "count": k, "delta": k / n}

    def _call_pyspark(self, df: ps.DataFrame) -> Dict[str, Any]:
        from pyspark.sql import DataFrameStatFunctions
        from pyspark.sql.functions import col, isnan

        n = df.count()

        mask = isnan(col(self.column)) | col(self.column).isNull()
        df = df.filter(~mask)

        st = DataFrameStatFunctions(df)
        quantile_value = st.approxQuantile(self.column, [self.q], 0)[0]
        if self.style == "greater":
            k = df.filter(col(self.column) > quantile_value).count()
        else:
            k = df.filter(col(self.column) < quantile_value).count()
        return {"total": n, "count": k, "delta": k / n}

    def _call_clickhouse(
            self,
            table_name: str,
            sql_connector: ClickHouseConnector
    ) -> Dict[str, Any]:
        n = sql_connector.execute(f"select count(*) from {table_name}")[0][0]
        sub_query = f"select {self.column} from {table_name} where isFinite({self.column})"
        quantile = sql_connector.execute(
            f"select quantileExact({self.q})({self.column}) from ({sub_query})"
        )[0][0]
        if self.style == "greater":
            query = f"select count(*) from ({sub_query}) where {self.column} > {quantile}"
        else:
            query = f"select count(*) from ({sub_query}) where {self.column} < {quantile}"
        k = sql_connector.execute(query)[0][0]
        return {"total": n, "count": k, "delta": k / n}

    def _call_postgresql(
            self,
            table_name: str,
            sql_connector: PostgreSQLConnector
    ) -> Dict[str, Any]:
        query_quantile = f'SELECT percentile_disc({self.q}) ' \
                         f'WITHIN GROUP (ORDER BY {self.column}) AS p ' \
                         f'FROM {table_name};'
        sql_connector.execute(query_quantile)
        quantile = sql_connector.conn.fetchone()[0]

        if self.style == 'greater':
            query_k = f'SELECT COUNT(*) FROM {table_name} ' \
                      f'WHERE {self.column} > {quantile};'

        else:
            query_k = f'SELECT COUNT(*) FROM {table_name} ' \
                      f'WHERE {self.column} < {quantile};'

        query_n = f'SELECT COUNT(*) FROM {table_name};'

        sql_connector.execute(query_k)
        k = sql_connector.conn.fetchone()[0]

        sql_connector.execute(query_n)
        n = sql_connector.conn.fetchone()[0]

        return {"total": n, "count": k, "delta": k / n}

    def _call_mssql(self, table_name: str, sql_connector: MSSQLConnector) -> Dict[str, Any]:
        total = sql_connector.execute(f"SELECT COUNT(*) FROM {table_name}").fetchone()[0]
        value = sql_connector.execute(
            f"SELECT PERCENTILE_DISC({self.q}) WITHIN GROUP (ORDER BY {self.column}) OVER() "
            f"FROM {table_name}"
        ).fetchone()[0]

        if self.style == "greater":
            count = sql_connector.execute(
                f"SELECT COUNT({self.column}) FROM {table_name} WHERE {self.column} > {value}"
            ).fetchone()[0]

        else:
            count = sql_connector.execute(
                f"SELECT COUNT({self.column}) FROM {table_name} WHERE {self.column} < {value}"
            ).fetchone()[0]

        return {"total": total, "count": count, "delta": count / total}


@dataclass
class CountLastDayRows(Metric):
    """Check if number of values in last day is at least 'percent'% of the average.

    Calculate average number of rows per day in chosen date column.
    If number of rows in last day is at least 'percent' value of the average, then
    return True, else return False.
    """

    column: str
    percent: float = 80

    def __post_init__(self):
        if self.percent < 0:
            raise ValueError("Percent value should be greater than 0.")

    def _call_pandas(self, df: pd.DataFrame) -> Dict[str, Any]:
        at_least = False
        last_date = df[self.column].max()
        last_date_count = len(df[df[self.column] == last_date])
        df_without_last = df[df[self.column] != last_date]
        day_groups = df_without_last.groupby(
            pd.to_datetime(df_without_last[self.column]).dt.date
        )
        average = day_groups.size().mean()

        percentage = (last_date_count / average) * 100
        if percentage >= self.percent:
            at_least = True
        return {
            "average": average,
            "last_date_count": last_date_count,
            "percentage": percentage,
            f"at_least_{self.percent}%": at_least,
        }

    def _call_pyspark(self, df: ps.DataFrame) -> Dict[str, Any]:
        from pyspark.sql.functions import col
        from pyspark.sql.functions import max as max_
        from pyspark.sql.functions import mean as mean_
        from pyspark.sql.functions import to_date

        at_least = False
        df_to_date = df.select(to_date(col(self.column)).alias("date"))
        last_date = df_to_date.select(max_("date")).collect()[0][0]
        last_date_count = df_to_date.filter(col("date") == last_date).count()
        df_without_last = df_to_date.filter(col("date") != last_date)
        average = (
            df_without_last.groupby("date")
            .count()
            .select(mean_("count"))
            .collect()[0][0]
        )
        percentage = (last_date_count / average) * 100
        if percentage >= self.percent:
            at_least = True
        return {
            "average": average,
            "last_date_count": last_date_count,
            "percentage": percentage,
            f"at_least_{self.percent}%": at_least,
        }

    def _call_clickhouse(
            self,
            table_name: str,
            sql_connector: ClickHouseConnector
    ) -> Dict[str, Any]:
        at_least = False

        query_last_day = f"select toDate({self.column}) as dt" \
                         f" from {table_name} " \
                         f"order by dt desc limit 1"
        last_day = sql_connector.execute(query_last_day)[0][0]
        subquery = f"select {self.column}" \
                   f" from {table_name}" \
                   f" where {self.column} != toDate('{last_day}')"

        n_rows_without_last = sql_connector.execute(f"select count(*) from ({subquery})")[0][0]
        n_days_without_last = sql_connector.execute(
            f"select countDistinct(toDate({self.column})) from ({subquery})")[0][0]
        average = n_rows_without_last / n_days_without_last

        last_date_count = sql_connector.execute(
            f"select count(*) from {table_name} where {self.column} = toDate('{last_day}')")[0][0]

        percentage = (last_date_count / average) * 100
        if percentage >= self.percent:
            at_least = True
        return {
            "average": average,
            "last_date_count": last_date_count,
            "percentage": percentage,
            f"at_least_{self.percent}%": at_least,
        }

    def _call_postgresql(
            self,
            table_name: str,
            sql_connector: PostgreSQLConnector
    ) -> Dict[str, Any]:
        pass

    def _call_mssql(self, table_name: str, sql_connector: MSSQLConnector) -> Dict[str, Any]:
        last_date_count = sql_connector.execute(
            "SELECT COUNT(*) "
            f"FROM {table_name} "
            f"WHERE CAST({self.column} AS DATE) = "
            f"(SELECT CAST(MAX({self.column}) AS DATE) FROM {table_name})"
        ).fetchone()[0]

        non_last_day_avg = sql_connector.execute(
            "SELECT AVG(CAST(n AS FLOAT)) "
            "FROM "
            f"(SELECT COUNT(*) AS n "
            f"FROM {table_name} "
            f"GROUP BY {self.column} "
            f"HAVING {self.column} != (SELECT MAX({self.column}) FROM {table_name})) t"
        ).fetchone()[0]

        percentage = (last_date_count / non_last_day_avg) * 100

        if percentage >= self.percent:
            is_at_least = True
        else:
            is_at_least = False

        return {
            "average": non_last_day_avg,
            "last_date_count": last_date_count,
            "percentage": percentage,
            f"at_least_{self.percent}%": is_at_least,
        }


@dataclass
class CountFewLastDayRows(Metric):
    """
    Calculate average number of rows per day in chosen date column.
    For each of the last 'number' days, check if number of rows in the day
    is at least 'percent' of the average.
    """

    column: str
    percent: float = 80
    number: int = 2

    def __post_init__(self):
        if self.percent < 0:
            raise ValueError("Percent value should be greater than 0.")
        if self.number <= 0:
            raise ValueError("Number of days to  check should be greater than 0.")

    def _call_pandas(self, df: pd.DataFrame) -> Dict[str, Any]:
        if self.number >= len(np.unique(df[self.column])):
            raise ValueError(
                "Number of days to check is greater or equal than total number of days."
            )

        sorted_df = df.sort_values(by=self.column)
        sorted_df[self.column] = pd.to_datetime(sorted_df[self.column])
        rows_per_day = sorted_df.groupby(sorted_df[self.column].dt.date).size()
        average = rows_per_day[: -self.number].mean()
        k = ((rows_per_day[-self.number:] / average * 100) >= self.percent).sum()
        return {"average": average, "days": k}

    def _call_pyspark(self, df: ps.DataFrame) -> Dict[str, Any]:
        # TODO: add pyspark implementation of call method
        raise NotImplementedError("This method is not implemented yet.")

    def _call_clickhouse(self, df: str, sql_connector: ClickHouseConnector) -> Dict[str, Any]:
        pass

    def _call_postgresql(self, df: str, sql_connector: PostgreSQLConnector) -> Dict[str, Any]:
        pass

    def _call_mssql(self, table_name: str, sql_connector: MSSQLConnector) -> Dict[str, Any]:
        avg_rows_number = sql_connector.execute(
            "SELECT AVG(rows_n) "
            "FROM "
            f"(SELECT CAST({self.column} AS DATE) AS date, COUNT(*) AS rows_n "
            f"FROM {table_name} "
            f"GROUP BY CAST({self.column} AS DATE)) t "
            f"WHERE date < DATEADD("
            f"DAY, {-self.number + 1}, (SELECT CAST(MAX({self.column}"
            f") AS DATE) "
            f"FROM {table_name}))"
        ).fetchone()[0]

        is_at_least = sql_connector.execute(
            "SELECT COUNT(date) "
            "FROM "
            f"(SELECT CAST({self.column} AS DATE) AS date, COUNT(*) AS rows_n "
            f"FROM {table_name} "
            f"GROUP BY CAST({self.column} AS DATE)) t "
            f"WHERE date >= DATEADD("
            f"DAY, "
            f"{-self.number + 1}, "
            f"(SELECT CAST(MAX({self.column}) AS DATE) FROM {table_name})"
            f") "
            f"AND (rows_n / {avg_rows_number}) * 100 >= {self.percent}"
        ).fetchone()[0]

        return {"average": avg_rows_number, "days": is_at_least}


@dataclass
class CheckAdversarialValidation(Metric):
    """Apply adversarial validation technic.

    Define indexes for first and second slices.
    For given slices of data apply adversarial technic
    to check if distributions of slices are the same or not.
    If there is a doubt about first slice being
    indistinguishable with the second slice,
    then return False and list of column names
    that might include some crucial differences.
    Otherwise, if classification score is about 0.5, return True.

    Take into consideration only numerical columns.
    """

    first_slice: tuple
    second_slice: tuple
    eps: float = 0.05

    def __post_init__(self):
        if len(self.first_slice) != 2 or len(self.second_slice) != 2:
            raise ValueError("Slices must be length of 2.")

    def _call_pandas(self, df: pd.DataFrame) -> Dict[str, Any]:
        np.random.seed(42)
        flag = True
        importance_dict = {}

        start_1, end_1 = self.first_slice[0], self.first_slice[1]
        start_2, end_2 = self.second_slice[0], self.second_slice[1]
        if start_1 >= end_1 or start_2 >= end_2:
            raise ValueError(
                "First value in slice must be lower than second value in slice."
            )

        # try except: slices contain index values
        try:
            first_part = df.select_dtypes(include=["number"]).loc[start_1:end_1, :]
            second_part = df.select_dtypes(include=["number"]).loc[start_2:end_2, :]
            first_part.insert(0, "av_label", 0)
            second_part.insert(0, "av_label", 1)

            data = pd.concat([first_part, second_part], axis=0)
            shuffled_data = data.sample(frac=1)
            shuffled_data = shuffled_data.fillna(np.min(shuffled_data.min()) - 1000)

            X, y = shuffled_data.drop(["av_label"], axis=1), shuffled_data["av_label"]

            # cross validation, binary classifier
            classifier = RandomForestClassifier(random_state=42)
            scores = cross_val_score(classifier, X, y, cv=5, scoring="roc_auc")
            mean_score = np.mean(scores)
            if mean_score > 0.5 + self.eps:
                flag = False
                forest = RandomForestClassifier(random_state=42)
                forest.fit(X, y)
                importances = np.around(forest.feature_importances_, 5)
                importance_dict = dict(zip(X.columns, importances))
            return {
                "similar": flag,
                "importances": importance_dict,
                "cv_roc_auc": np.around(mean_score, 5),
            }
        except TypeError:
            print("Values in slices should be values from df.index .")
            raise

    def _call_payspark(self, df: pd.DataFrame) -> Dict[str, Any]:
        # TODO: add pyspark implementation of call method
        raise NotImplementedError("This method is not implemented yet.")

    def _call_clickhouse(self, df: str, sql_connector: ClickHouseConnector) -> Dict[str, Any]:
        pass

    def _call_postgresql(self, df: str, sql_connector: PostgreSQLConnector) -> Dict[str, Any]:
        pass

    def _call_mssql(self, df: str, sql_connector: MSSQLConnector) -> Dict[str, Any]:
        pass
