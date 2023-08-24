"""Valid metrics."""

from __future__ import annotations

__all__ = [
    'CountTotal',
    'CountZeros',
    'CountNull',
    'CountDuplicates',
    'CountUnique',
    'CountValue',
    'CountBelowValue',
    'CountBelowColumn',
    'CountRatioBelow',
    'CountCB',
    'CountLag',
    'CountAboveValue',
    'CountValueInSet',
    'CountValueInBounds',
    'CountExtremeValuesFormula',
    'CountExtremeValuesQuantile',
    'CountLastDayRows',
    'CountFewLastDayRows',
    'CheckAdversarialValidation'
]

from datetime import datetime
from dataclasses import dataclass
from typing import Any, Dict, List, Tuple, Union, TYPE_CHECKING

import numpy as np
import pandas as pd

from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import cross_validate
from sklearn.utils import shuffle

import pure.sql_connector as conn
from pure.utils import PySparkSingleton
from psycopg2.extensions import AsIs

if TYPE_CHECKING:
    import pyspark.sql as ps


@dataclass
class Metric:
    """Base class for Metric"""

    def __call__(
            self,
            engine: str,
            df: Union[pd.DataFrame, ps.DataFrame, str],
            sql_connector: Union[
                conn.ClickHouseConnector,
                conn.PostgreSQLConnector,
                conn.MSSQLConnector,
                conn.MySQLConnector
            ] = None
    ) -> Dict[str, Any]:

        if engine == "pandas":
            return self._call_pandas(df)

        if engine == "pyspark":
            pss = PySparkSingleton()

            if pss is not None:
                return self._call_pyspark(pss, df)

        if engine == "clickhouse":
            return self._call_clickhouse(df, sql_connector)

        if engine == "postgresql":
            return self._call_postgresql(df, sql_connector)

        if engine == "mssql":
            return self._call_mssql(df, sql_connector)

        if engine == "mysql":
            return self._call_mysql(df, sql_connector)

        msg = (
            f"Not supported type of 'engine': {engine}. "
            "Supported engines: `pandas`, `pyspark`, `clickhouse`, `mssql`, `postgresql`, `mysql`."
        )
        raise NotImplementedError(msg)

    def _call_pandas(self, df: pd.DataFrame) -> Dict[str, Any]:
        pass

    def _call_pyspark(self, pss: PySparkSingleton, df: ps.DataFrame) -> Dict[str, Any]:
        pass

    def _call_clickhouse(self, table_name: str, sql_connector: conn.ClickHouseConnector) -> Dict[str, Any]:
        pass

    def _call_postgresql(self, table_name: str, sql_connector: conn.PostgreSQLConnector) -> Dict[str, Any]:
        pass

    def _call_mssql(self, table_name: str, sql_connector: conn.MSSQLConnector) -> Dict[str, Any]:
        pass

    def _call_mysql(self, table_name: str, sql_connector: conn.MySQLConnector) -> Dict[str, Any]:
        pass


@dataclass
class CountTotal(Metric):
    """Total number of rows in DataFrame."""

    def _call_pandas(self, df: pd.DataFrame) -> Dict[str, Any]:
        return {"total": len(df)}

    def _call_pyspark(self, pss: PySparkSingleton, df: ps.DataFrame) -> Dict[str, Any]:
        return {"total": df.count()}

    def _call_clickhouse(
            self,
            table_name: str,
            sql_connector: conn.ClickHouseConnector
    ) -> Dict[str, Any]:
        query = f"select count(1) from {table_name}"
        n = sql_connector.execute(query)[0][0]

        return {"total": n}

    def _call_postgresql(
            self,
            table_name: str,
            sql_connector: conn.PostgreSQLConnector
    ) -> Dict[str, Any]:
        query = "select count(1) from %(table)s"
        params = {'table': AsIs(table_name)}

        n = sql_connector.execute(query, params)[0][0]

        return {"total": n}

    def _call_mssql(self, table_name: str, sql_connector: conn.MSSQLConnector) -> Dict[str, Any]:
        query = f'select count(1) from {table_name}'
        total = sql_connector.execute(query)[0][0]

        return {"total": total}

    def _call_mysql(self, table_name: str, sql_connector: conn.MySQLConnector) -> Dict[str, Any]:
        query = f'select count(1) from {table_name}'
        total = sql_connector.execute(query)[0][0]

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

    def _call_pyspark(self, pss: PySparkSingleton, df: ps.DataFrame) -> Dict[str, Any]:
        n = df.count()
        k = df.filter(pss.func.col(self.column) == 0).count()

        return {"total": n, "count": k, "delta": k / n}

    def _call_clickhouse(
            self,
            table_name: str,
            sql_connector: conn.ClickHouseConnector
    ) -> Dict[str, Any]:
        query = f'''
            select count(1) as n,
                count(1) filter(where {self.column}=0) as k
            from {table_name}
        '''

        n, k = sql_connector.execute(query)[0]
        delta = 0 if n == 0 else k / n

        return {"total": n, "count": k, "delta": delta}

    def _call_postgresql(
        self,
        table_name: str,
        sql_connector: conn.PostgreSQLConnector
    ) -> Dict[str, Any]:
        query = '''
            select count(1) as n,
	            sum(case when %(column)s=0 then 1 else 0 end) as k
            from %(table)s
        '''

        params = {
            'table': AsIs(table_name),
            'column': AsIs(self.column)
        }

        n, k = sql_connector.execute(query, params)[0]
        delta = 0 if n == 0 else k / n

        return {"total": n, "count": k, "delta": delta}

    def _call_mssql(self, table_name: str, sql_connector: conn.MSSQLConnector) -> Dict[str, Any]:
        query = f'''
            select count(1) as n,
	            sum(case when {self.column} = 0 then 1 else 0 end) as k
            from {table_name}
        '''

        n, k = sql_connector.execute(query)[0]
        delta = 0 if n == 0 else k / n

        return {"total": n, "count": k, "delta": delta}

    def _call_mysql(self, table_name: str, sql_connector: conn.MySQLConnector) -> Dict[str, Any]:
        query = f'''
            select count(1) as n,
	            cast(sum(case when {self.column} = 0 then 1 else 0 end) as unsigned) as k
            from {table_name}
        '''

        n, k = sql_connector.execute(query)[0]
        delta = 0 if n == 0 else k / n

        return {"total": n, "count": k, "delta": delta}


@dataclass
class CountNull(Metric):
    """
    Number of empty values in chosen columns.
    Columns can be passed as list of strings or string with comma separated values.

    If 'aggregation' == 'any', then count rows where
    at least one value from defined 'columns' set is Null.
    If 'aggregation' == 'all', then count rows where
    all values from defined 'columns' set are Null.
    """

    columns: Union[List[str], str]
    aggregation: str = "any"  # either "all", or "any"

    def __post_init__(self):
        if self.aggregation not in ["all", "any"]:
            raise ValueError("Aggregation must be either 'all' or 'any'.")

        if isinstance(self.columns, str):
            self.columns = [value.strip() for value in self.columns.split(',') if value.strip()]

        if not self.columns:
            raise ValueError('Passed empty list or string without comma separated columns.')

        if self.aggregation == 'any':
            self._cond = ' or '.join(f'{col} is null' for col in self.columns)
        elif self.aggregation == 'all':
            self._cond = ' and '.join(f'{col} is null' for col in self.columns)

    def _call_pandas(self, df: pd.DataFrame) -> Dict[str, Any]:
        n = len(df)

        if self.aggregation == "any":
            k = np.sum(np.bitwise_or.reduce(df[self.columns].isna(), axis=1))
        elif self.aggregation == "all":
            k = np.sum(np.bitwise_and.reduce(df[self.columns].isna(), axis=1))
        else:
            raise ValueError("Unknown value for aggregation")

        return {"total": n, "count": k, "delta": k / n}

    def _call_pyspark(self, pss: PySparkSingleton, df: ps.DataFrame) -> Dict[str, Any]:
        n = df.count()

        empty_cols = df.select(
            sum([
                pss.func.when(pss.func.isnan(c) | pss.func.col(c).isNull(), 1).otherwise(0) \
                for c in self.columns
            ]).alias('cols')
        )

        if self.aggregation == 'all':
            k = empty_cols.where(pss.func.col('cols') == len(self.columns)).count()
        else:
            k = empty_cols.where(pss.func.col('cols') != 0).count()

        return {"total": n, "count": k, "delta": k / n}

    def _call_clickhouse(
            self,
            table_name: str,
            sql_connector: conn.ClickHouseConnector
    ) -> Dict[str, Any]:
        query = f'''
            select count(1) as n,
	            count(1) filter(where {self._cond}) as k
            from {table_name}
        '''

        n, k = sql_connector.execute(query)[0]
        delta = 0 if n == 0 else k / n

        return {"total": n, "count": k, "delta": delta}

    def _call_postgresql(
            self,
            table_name: str,
            sql_connector: conn.PostgreSQLConnector
    ) -> Dict[str, Any]:
        query = '''
            select count(1) as n,
	            sum(case when %(cond)s then 1 else 0 end) as k
            from %(table)s
        '''

        params = {
            'table': AsIs(table_name),
            'cond': AsIs(self._cond)
        }

        n, k = sql_connector.execute(query, params)[0]
        delta = 0 if n == 0 else k / n

        return {"total": n, "count": k, "delta": delta}

    def _call_mssql(self, table_name: str, sql_connector: conn.MSSQLConnector) -> Dict[str, Any]:
        query = f'''
            select count(1) as n,
	            sum(case when {self._cond} then 1 else 0 end) as k
            from {table_name}
        '''

        n, k = sql_connector.execute(query)[0]
        delta = 0 if n == 0 else k / n

        return {"total": n, "count": k, "delta": delta}

    def _call_mysql(self, table_name: str, sql_connector: conn.MySQLConnector) -> Dict[str, Any]:
        query = f'''
            select count(1) as n,
	            cast(sum(case when {self._cond} then 1 else 0 end) as unsigned) as k
            from {table_name}
        '''

        n, k = sql_connector.execute(query)[0]
        delta = 0 if n == 0 else k / n

        return {"total": n, "count": k, "delta": delta}


@dataclass
class CountDuplicates(Metric):
    """
    Number of duplicates in chosen columns.
    Columns can be passed as list of strings or string with comma separated values.
    """

    columns: Union[List[str], str]

    def __post_init__(self):
        if isinstance(self.columns, str):
            self.columns = [value.strip() for value in self.columns.split(',') if value.strip()]

        if not self.columns:
            raise ValueError('Passed empty list or string without comma separated columns.')

        self._table_columns = ', '.join(f"{col}" for col in self.columns)

    def _call_pandas(self, df: pd.DataFrame) -> Dict[str, Any]:
        n = len(df)
        k = df.duplicated(subset=self.columns).sum()

        return {"total": n, "count": k, "delta": k / n}

    def _call_pyspark(self, pss: PySparkSingleton, df: ps.DataFrame) -> Dict[str, Any]:
        n = df.count()
        m = df.select(self.columns).distinct().count()
        k = n - m

        return {"total": n, "count": k, "delta": k / n}

    def _call_clickhouse(
            self,
            table_name: str,
            sql_connector: conn.ClickHouseConnector
    ) -> Dict[str, Any]:
        query = f'''
            with groups as (
                select count(1) as n, count(1) - 1 as k
                from {table_name}
                group by {self._table_columns}
            )
            select sum(n) as n, sum(k) as k
            from groups
        '''
        n, k = sql_connector.execute(query)[0]
        delta = 0 if n == 0 else k / n

        return {"total": n, "count": k, "delta": delta}

    def _call_postgresql(
            self,
            table_name: str,
            sql_connector: conn.PostgreSQLConnector
    ) -> Dict[str, Any]:
        query = '''
            with groups as (
                select count(1) as n, count(1) - 1 as k
                from %(table)s
                group by %(columns)s
            )
            select sum(n)::int as n, sum(k)::int as k
            from groups
        '''

        params = {
            'table': AsIs(table_name),
            'columns': AsIs(self._table_columns)
        }

        n, k = sql_connector.execute(query, params)[0]
        delta = 0 if n == 0 else k / n

        return {"total": n, "count": k, "delta": delta}

    def _call_mssql(self, table_name: str, sql_connector: conn.MSSQLConnector) -> Dict[str, Any]:
        query = f'''
            with groups as (
                select count(1) as n, count(1) - 1 as k
                from {table_name}
                group by {self._table_columns}
            )
            select sum(n) as n, sum(k) as k
            from groups
        '''
        n, k = sql_connector.execute(query)[0]
        delta = 0 if n == 0 else k / n

        return {"total": n, "count": k, "delta": delta}

    def _call_mysql(self, table_name: str, sql_connector: conn.MySQLConnector) -> Dict[str, Any]:
        query = f'''
            with _groups as (
                select count(1) as n, count(1) - 1 as k
                from {table_name}
                group by {self._table_columns}
            )
            select cast(sum(n) as unsigned) as n,
                cast(sum(k) as unsigned) as k
            from _groups
        '''
        n, k = sql_connector.execute(query)[0]
        delta = 0 if n == 0 else k / n

        return {"total": n, "count": k, "delta": delta}


@dataclass
class CountUnique(Metric):
    """
    Number of unique rows in chosen columns.
    Columns can be passed as list of strings or string with comma separated values.
    """

    columns: Union[List[str], str]

    def __post_init__(self):
        if isinstance(self.columns, str):
            self.columns = [value.strip() for value in self.columns.split(',') if value.strip()]

        if not self.columns:
            raise ValueError('Passed empty list or string without comma separated columns.')

        self._table_columns = ', '.join(f"{col}" for col in self.columns)

    def _call_pandas(self, df: pd.DataFrame) -> Dict[str, Any]:
        n = len(df)

        groups = df.groupby(self.columns, dropna=False).size()
        k = np.sum(groups == 1)

        return {"total": n, "count": k, "delta": k / n}

    def _call_pyspark(self, pss: PySparkSingleton, df: ps.DataFrame) -> Dict[str, Any]:
        n = df.count()

        first_col = self.columns[0]
        k = df.groupby(self.columns).agg(pss.func.count(first_col).alias('_group_qty')).\
            filter(pss.func.col('_group_qty') == 1).count()

        return {"total": n, "count": k, "delta": k / n}

    def _call_clickhouse(
            self,
            table_name: str,
            sql_connector: conn.ClickHouseConnector
    ) -> Dict[str, Any]:
        query = f'''
            with groups as (
                select count(1) as n, count(1) as k
                from {table_name}
                group by {self._table_columns}
            )
            select sum(n) as n, sum(k) filter(where k = 1) as k
            from groups
        '''
        n, k = sql_connector.execute(query)[0]
        delta = 0 if n == 0 else k / n

        return {"total": n, "count": k, "delta": delta}

    def _call_postgresql(
            self,
            table_name: str,
            sql_connector: conn.PostgreSQLConnector
    ) -> Dict[str, Any]:
        query = '''
            with groups as (
                select count(1) as n, count(1) as k
                from %(table)s
                group by %(columns)s
            )
            select sum(n)::int as n,
                sum(case when k=1 then 1 else 0 end)::int as k
            from groups
        '''

        params = {
            'table': AsIs(table_name),
            'columns': AsIs(self._table_columns)
        }

        n, k = sql_connector.execute(query, params)[0]
        delta = 0 if n == 0 else k / n

        return {"total": n, "count": k, "delta": delta}

    def _call_mssql(self, table_name: str, sql_connector: conn.MSSQLConnector) -> Dict[str, Any]:
        query = f'''
            with groups as (
                select count(1) as n, count(1) as k
                from {table_name}
                group by {self._table_columns}
            )
            select sum(n) as n,
                sum(case when k=1 then 1 else 0 end) as k
            from groups
        '''
        n, k = sql_connector.execute(query)[0]
        delta = 0 if n == 0 else k / n

        return {"total": n, "count": k, "delta": delta}

    def _call_mysql(self, table_name: str, sql_connector: conn.MySQLConnector) -> Dict[str, Any]:
        query = f'''
            with _groups as (
                select count(1) as n, count(1) as k
                from {table_name}
                group by {self._table_columns}
            )
            select cast(sum(n) as unsigned) as n,
                cast(sum(case when k=1 then 1 else 0 end) as unsigned) as k
            from _groups
        '''
        n, k = sql_connector.execute(query)[0]
        delta = 0 if n == 0 else k / n

        return {"total": n, "count": k, "delta": delta}


@dataclass
class CountValue(Metric):
    """Number of values in chosen column.

    Count rows that value in chosen column is equal to 'value'.
    """

    column: str
    value: Union[str, int, float]

    def _call_pandas(self, df: pd.DataFrame) -> Dict[str, Any]:
        n = len(df)
        k = np.sum(df[self.column] == self.value)

        return {"total": n, "count": k, "delta": k / n}

    def _call_pyspark(self, pss: PySparkSingleton, df: ps.DataFrame) -> Dict[str, Any]:
        n = df.count()
        k = df.filter(pss.func.col(self.column) == self.value).count()

        return {"total": n, "count": k, "delta": k / n}

    def _call_clickhouse(
            self,
            table_name: str,
            sql_connector: conn.ClickHouseConnector
    ) -> Dict[str, Any]:
        query = f'''
            select count(1) as n,
                count(1) filter(where {self.column} = %(value)s) as k
            from {table_name}
        '''

        params = {'value': self.value}

        n, k = sql_connector.execute(query, params)[0]
        delta = 0 if n == 0 else k / n

        return {"total": n, "count": k, "delta": delta}

    def _call_postgresql(
            self,
            table_name: str,
            sql_connector: conn.PostgreSQLConnector
    ) -> Dict[str, Any]:
        query = '''
            select count(1) as n,
                sum(case when %(column)s=%(value)s then 1 else 0 end) as k
            from %(table)s
        '''

        params = {
            'table': AsIs(table_name),
            'column': AsIs(self.column),
            'value': self.value
        }

        n, k = sql_connector.execute(query, params)[0]
        delta = 0 if n == 0 else k / n

        return {"total": n, "count": k, "delta": delta}

    def _call_mssql(self, table_name: str, sql_connector: conn.MSSQLConnector) -> Dict[str, Any]:
        query = f'''
            select count(1) as n,
                sum(case when {self.column}=%(value)s then 1 else 0 end) as k
            from {table_name}
        '''

        params = {'value': self.value}

        n, k = sql_connector.execute(query, params)[0]
        delta = 0 if n == 0 else k / n

        return {"total": n, "count": k, "delta": delta}

    def _call_mysql(self, table_name: str, sql_connector: conn.MySQLConnector) -> Dict[str, Any]:
        query = f'''
            select count(1) as n,
                cast(sum(case when {self.column}=%(value)s then 1 else 0 end) as unsigned) as k
            from {table_name}
        '''

        params = {'value': self.value}

        n, k = sql_connector.execute(query, params)[0]
        delta = 0 if n == 0 else k / n

        return {"total": n, "count": k, "delta": delta}


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

    def __post_init__(self):
        self._cmp_sign = '<' if self.strict else '<='

    def _call_pandas(self, df: pd.DataFrame) -> Dict[str, Any]:
        n = len(df)

        if self.strict:
            k = np.sum(df[self.column] < self.value)
        else:
            k = np.sum(df[self.column] <= self.value)

        return {"total": n, "count": k, "delta": k / n}

    def _call_pyspark(self, pss: PySparkSingleton, df: ps.DataFrame) -> Dict[str, Any]:
        n = df.count()

        if self.strict:
            k = df.filter(pss.func.col(self.column) < self.value).count()
        else:
            k = df.filter(pss.func.col(self.column) <= self.value).count()

        return {"total": n, "count": k, "delta": k / n}

    def _call_clickhouse(
            self,
            table_name: str,
            sql_connector: conn.ClickHouseConnector
    ) -> Dict[str, Any]:
        query = f'''
            select count(1) as n,
                count(1) filter(where {self.column} {self._cmp_sign} %(value)s) as k
            from {table_name}
        '''

        params = {'value': self.value}

        n, k = sql_connector.execute(query, params)[0]
        delta = 0 if n == 0 else k / n

        return {"total": n, "count": k, "delta": delta}

    def _call_postgresql(
            self,
            table_name: str,
            sql_connector: conn.PostgreSQLConnector
    ) -> Dict[str, Any]:
        query = '''
            select count(1) as n,
                sum(case when %(column)s %(cmp)s %(value)s then 1 else 0 end) as k
            from %(table)s
        '''

        params = {
            'table': AsIs(table_name),
            'column': AsIs(self.column),
            'cmp': AsIs(self._cmp_sign),
            'value': self.value
        }

        n, k = sql_connector.execute(query, params)[0]
        delta = 0 if n == 0 else k / n

        return {"total": n, "count": k, "delta": delta}

    def _call_mssql(self, table_name: str, sql_connector: conn.MSSQLConnector) -> Dict[str, Any]:
        query = f'''
            select count(1) as n,
                sum(case when {self.column} {self._cmp_sign} %(value)s then 1 else 0 end) as k
            from {table_name}
        '''

        params = {'value': self.value}

        n, k = sql_connector.execute(query, params)[0]
        delta = 0 if n == 0 else k / n

        return {"total": n, "count": k, "delta": delta}

    def _call_mysql(self, table_name: str, sql_connector: conn.MySQLConnector) -> Dict[str, Any]:
        query = f'''
            select count(1) as n,
                cast(sum(case when {self.column} {self._cmp_sign} %(value)s then 1 else 0 end) as unsigned) as k
            from {table_name}
        '''

        params = {'value': self.value}

        n, k = sql_connector.execute(query, params)[0]
        delta = 0 if n == 0 else k / n

        return {"total": n, "count": k, "delta": delta}


@dataclass
class CountBelowColumn(Metric):
    """Count how often column X below Y.

    Calculate number of rows that value in 'column_x'
    is lower than value in 'column_y'.
    """

    column_x: str
    column_y: str
    strict: bool = True

    def __post_init__(self):
        self._cmp_sign = '<' if self.strict else '<='

    def _call_pandas(self, df: pd.DataFrame) -> Dict[str, Any]:
        n = len(df)
        if self.strict:
            k = np.sum(df[self.column_x] < df[self.column_y])
        else:
            k = np.sum(df[self.column_x] <= df[self.column_y])
        return {"total": n, "count": k, "delta": k / n}

    def _call_pyspark(self, pss: PySparkSingleton, df: ps.DataFrame) -> Dict[str, Any]:
        n = df.count()

        mask = pss.func.isnan(pss.func.col(self.column_x)) | pss.func.col(self.column_x).isNull()
        mask |= pss.func.isnan(pss.func.col(self.column_y)) | pss.func.col(self.column_y).isNull()
        df = df.filter(~mask)

        if self.strict:
            k = df.filter(pss.func.col(self.column_x) < pss.func.col(self.column_y)).count()
        else:
            k = df.filter(pss.func.col(self.column_x) <= pss.func.col(self.column_y)).count()

        return {"total": n, "count": k, "delta": k / n}

    def _call_clickhouse(
            self,
            table_name: str,
            sql_connector: conn.ClickHouseConnector
    ) -> Dict[str, Any]:
        query = f'''
            select count(1) as n,
                count(1) filter(where {self.column_x} {self._cmp_sign} {self.column_y}) as k
            from {table_name}
        '''
        n, k = sql_connector.execute(query)[0]
        delta = 0 if n == 0 else k / n

        return {"total": n, "count": k, "delta": delta}

    def _call_postgresql(
            self,
            table_name: str,
            sql_connector: conn.PostgreSQLConnector
    ) -> Dict[str, Any]:
        query = '''
            select count(1) as n,
                sum(case when %(column1)s %(cmp)s %(column2)s then 1 else 0 end) as k
            from %(table)s
        '''

        params = {
            'table': AsIs(table_name),
            'column1': AsIs(self.column_x),
            'column2': AsIs(self.column_y),
            'cmp': AsIs(self._cmp_sign)
        }

        n, k = sql_connector.execute(query, params)[0]
        delta = 0 if n == 0 else k / n

        return {"total": n, "count": k, "delta": delta}

    def _call_mssql(self, table_name: str, sql_connector: conn.MSSQLConnector) -> Dict[str, Any]:
        query = f'''
            select count(1) as n,
                sum(case when {self.column_x} {self._cmp_sign} {self.column_y} then 1 else 0 end) as k
            from {table_name}
        '''

        n, k = sql_connector.execute(query)[0]
        delta = 0 if n == 0 else k / n

        return {"total": n, "count": k, "delta": delta}

    def _call_mysql(self, table_name: str, sql_connector: conn.MySQLConnector) -> Dict[str, Any]:
        query = f'''
            select count(1) as n,
                cast(sum(case when {self.column_x} {self._cmp_sign} {self.column_y} then 1 else 0 end) as unsigned) as k
            from {table_name}
        '''

        n, k = sql_connector.execute(query)[0]
        delta = 0 if n == 0 else k / n

        return {"total": n, "count": k, "delta": delta}


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

    def __post_init__(self):
        self._cmp_sign = '<' if self.strict else '<='

    def _call_pandas(self, df: pd.DataFrame) -> Dict[str, Any]:
        n = len(df)
        ratio = df[self.column_x] / df[self.column_y]

        if self.strict:
            k = np.sum(ratio < df[self.column_z])
        else:
            k = np.sum(ratio <= df[self.column_z])

        return {"total": n, "count": k, "delta": k / n}

    def _call_pyspark(self, pss: PySparkSingleton, df: ps.DataFrame) -> Dict[str, Any]:
        n = df.count()

        mask = pss.func.isnan(pss.func.col(self.column_x)) | pss.func.col(self.column_x).isNull()
        mask |= pss.func.isnan(pss.func.col(self.column_y)) | pss.func.col(self.column_y).isNull()
        mask |= pss.func.isnan(pss.func.col(self.column_z)) | pss.func.col(self.column_z).isNull()
        df = df.filter(~mask)

        ratio = pss.func.col(self.column_x) / pss.func.col(self.column_y)

        if self.strict:
            k = df.filter(ratio < pss.func.col(self.column_z)).count()
        else:
            k = df.filter(ratio <= pss.func.col(self.column_z)).count()

        return {"total": n, "count": k, "delta": k / n}

    def _call_clickhouse(
            self,
            table_name: str,
            sql_connector: conn.ClickHouseConnector
    ) -> Dict[str, Any]:
        query = f'''
            select count(1) as n,
                count(1) filter(where {self.column_y} != 0 and
                    ({self.column_x} / {self.column_y}) {self._cmp_sign} {self.column_z}) as k
            from {table_name}
        '''

        n, k = sql_connector.execute(query)[0]
        delta = 0 if n == 0 else k / n

        return {"total": n, "count": k, "delta": delta}

    def _call_postgresql(
            self,
            table_name: str,
            sql_connector: conn.PostgreSQLConnector
    ) -> Dict[str, Any]:
        query = '''
            select count(1) as n,
                sum(case when %(col2)s != 0 and (%(col1)s / %(col2)s) %(cmp)s %(col3)s then 1 else 0 end) as k
            from %(table)s
        '''

        params = {
            'table': AsIs(table_name),
            'col1': AsIs(self.column_x),
            'col2': AsIs(self.column_y),
            'col3': AsIs(self.column_z),
            'cmp': AsIs(self._cmp_sign)
        }

        n, k = sql_connector.execute(query, params)[0]
        delta = 0 if n == 0 else k / n

        return {"total": n, "count": k, "delta": delta}

    def _call_mssql(self, table_name: str, sql_connector: conn.MSSQLConnector) -> Dict[str, Any]:
        query = f'''
            select count(1) as n,
                sum(case when {self.column_y} != 0 and
                    ({self.column_x} / {self.column_y}) {self._cmp_sign} {self.column_z} then 1 else 0 end) as k
            from {table_name}
        '''

        n, k = sql_connector.execute(query)[0]
        delta = 0 if n == 0 else k / n

        return {"total": n, "count": k, "delta": delta}

    def _call_mysql(self, table_name: str, sql_connector: conn.MySQLConnector) -> Dict[str, Any]:
        query = f'''
            select count(1) as n,
                cast(sum(case when {self.column_y} != 0 and
                    ({self.column_x} / {self.column_y}) {self._cmp_sign} {self.column_z} then 1 else 0 end) as unsigned) as k
            from {table_name}
        '''

        n, k = sql_connector.execute(query)[0]
        delta = 0 if n == 0 else k / n

        return {"total": n, "count": k, "delta": delta}


@dataclass
class CountCB(Metric):
    """Lower/upper bounds for N%-confidence interval.

    Calculate bounds for 'conf'-percent interval in chosen column.
    """

    column: str
    conf: float = 0.95

    def __post_init__(self):
        if not 0 <= self.conf <= 1:
            raise ValueError("Confident level should be in the interval [0, 1]")

        self.alpha = 1 - self.conf
        self.lcb_per = self.alpha / 2
        self.ucb_per = 1 - self.alpha / 2

    def _call_pandas(self, df: pd.DataFrame) -> Dict[str, Any]:
        values = df[df[self.column].notnull()][self.column].values
        lcb, ucb = np.quantile(values, [self.lcb_per, self.ucb_per])

        return {"lcb": lcb, "ucb": ucb}

    def _call_pyspark(self, pss: PySparkSingleton, df: ps.DataFrame) -> Dict[str, Any]:
        st = pss.sql.DataFrameStatFunctions(df)
        ci = st.approxQuantile(self.column, [self.lcb_per, self.ucb_per], 0.00001)

        return {"lcb": ci[0], "ucb": ci[1]}

    def _call_clickhouse(
            self,
            table_name: str,
            sql_connector: conn.ClickHouseConnector
    ) -> Dict[str, Any]:
        query = f'''
            select quantiles(%(lcb)s, %(ucb)s)({self.column}) as qv
            from {table_name}
        '''

        params = {
            'lcb': self.lcb_per,
            'ucb': self.ucb_per
        }

        lcb, ucb = sql_connector.execute(query, params)[0][0]

        return {"lcb": lcb, "ucb": ucb}

    def _call_postgresql(
            self,
            table_name: str,
            sql_connector: conn.PostgreSQLConnector
    ) -> Dict[str, Any]:
        query = '''
            select percentile_cont(array[%(lcb)s, %(ucb)s])
                within group (order by %(column)s) as p
            from %(table)s;
        '''

        params = {
            'table': AsIs(table_name),
            'column': AsIs(self.column),
            'lcb': self.lcb_per,
            'ucb': self.ucb_per
        }

        lcb, ucb = sql_connector.execute(query, params)[0]

        return {"lcb": lcb, "ucb": ucb}

    def _call_mssql(self, table_name: str, sql_connector: conn.MSSQLConnector) -> Dict[str, Any]:
        query = f'''
            select distinct
	            percentile_cont(%(lcb)s) within group (order by {self.column}) over() as lcb,
	            percentile_cont(%(ucb)s) within group (order by {self.column}) over() as ucb
            from {table_name}
        '''

        params = {
            'lcb': self.lcb_per,
            'ucb': self.ucb_per
        }

        lcb, ucb = sql_connector.execute(query, params)[0]

        return {"lcb": lcb, "ucb": ucb}

    def _call_mysql(self, table_name: str, sql_connector: conn.MySQLConnector) -> Dict[str, Any]:
        query = f'''
            with pos as (
                select
                    floor(%(lcb)s*count(1)) as lcb_start, ceil(%(lcb)s*count(1)) as lcb_end,
                    floor(%(ucb)s*count(1)) as ucb_start, ceil(%(ucb)s*count(1)) as ucb_end
                from {table_name}
                where {self.column} is not null
            ),
            ranked_rows as (
                select {self.column},
                    row_number() over(order by {self.column}) as x
                from {table_name}
                where {self.column} is not null
            ),
            lcb as (
                select avg(rr.{self.column}) as x
                from ranked_rows rr, pos p
                where rr.x between p.lcb_start and p.lcb_end
            ),
            ucb as (
                select avg(rr.{self.column}) as x
                from ranked_rows rr, pos p
                where rr.x between p.ucb_start and p.ucb_end
            )
            select lcb.x, ucb.x
            from lcb, ucb
        '''

        params = {
            'lcb': self.lcb_per,
            'ucb': self.ucb_per
        }

        lcb, ucb = sql_connector.execute(query, params)[0]

        return {"lcb": float(lcb), "ucb": float(ucb)}


@dataclass
class CountLag(Metric):
    """
    A lag between the last datetime value in the table and today.

    Args:
        column (str):
            Column name for datetime value from table
        step (str, optional):
            Determine step for difference between datetimes: {`day`, `hour`, `minute`}
            Defaults to `day`

        _today_test (str, optional):
            Only for tests, don't use in other cases!
            Defaults to None
    """

    column: str
    step: str = 'day'
    _today_test: datetime = None

    def __post_init__(self):
        if self.step not in ['day', 'hour', 'minute']:
            raise ValueError("Passed `step` value differs from `day`, `hour` or `minute`.")

        if self._today_test:
            if not isinstance(self._today_test, datetime):
                raise TypeError("Type of parameter `_today_test` must be `datetime`.")

    def _lag(self, last_dt: datetime) -> Dict:
        if self._today_test:
            today = self._today_test
        else:
            today = datetime.now()

        diff = today - last_dt
        fmt = '%Y-%m-%d %H:%M'

        if self.step == 'day':
            lag = diff.days
            fmt = '%Y-%m-%d'
        elif self.step == 'hour':
            lag = int(diff.total_seconds() / 3600)
        elif self.step == 'minute':
            lag = int(diff.total_seconds() / 60)

        return {
            "today": today.strftime(fmt),
            "last_day": last_dt.strftime(fmt),
            "lag": lag
        }

    def _call_pandas(self, df: pd.DataFrame) -> Dict[str, Any]:
        last_dt = pd.to_datetime(df[self.column]).max().to_pydatetime()

        return self._lag(last_dt)

    def _call_pyspark(self, pss: PySparkSingleton, df: ps.DataFrame) -> Dict[str, Any]:
        last_dt = df.select(
            pss.func.max(
                pss.func.col(self.column).cast(pss.sql.types.TimestampType())
            )
        ).collect()[0][0]

        return self._lag(last_dt)

    def _call_clickhouse(
            self,
            table_name: str,
            sql_connector: conn.ClickHouseConnector
    ) -> Dict[str, Any]:
        query = f'''
            select max({self.column})::datetime as last_dt
            from {table_name}
        '''

        last_dt = sql_connector.execute(query)[0][0]

        return self._lag(last_dt)

    def _call_postgresql(
            self,
            table_name: str,
            sql_connector: conn.PostgreSQLConnector
    ) -> Dict[str, Any]:
        query = '''
            select max(%(column)s)::timestamp as last_dt
            from %(table)s;
        '''

        params = {
            'table': AsIs(table_name),
            'column': AsIs(self.column)
        }

        last_dt = sql_connector.execute(query, params)[0][0]

        return self._lag(last_dt)

    def _call_mssql(self, table_name: str, sql_connector: conn.MSSQLConnector) -> Dict[str, Any]:
        query = f'''
            select cast(max({self.column}) as smalldatetime) as last_dt
            from {table_name}
        '''

        last_dt = sql_connector.execute(query)[0][0]

        return self._lag(last_dt)

    def _call_mysql(self, table_name: str, sql_connector: conn.MySQLConnector) -> Dict[str, Any]:
        query = f'''
            select cast(max({self.column}) as datetime) as last_dt
            from {table_name}
        '''

        last_dt = sql_connector.execute(query)[0][0]

        return self._lag(last_dt)


@dataclass
class CountAboveValue(Metric):
    """Number of values greater than threshold.

    Count values in chosen column
    that are greater than defined threshold ('value').
    If 'strict' == False, then inequality is non-strict.
    """

    column: str
    value: float
    strict: bool = False

    def __post_init__(self):
        self._cmp_sign = '>' if self.strict else '>='

    def _call_pandas(self, df: pd.DataFrame) -> Dict[str, Any]:
        n = len(df)

        if self.strict:
            k = np.sum(df[self.column] > self.value)
        else:
            k = np.sum(df[self.column] >= self.value)

        return {"total": n, "count": k, "delta": k / n}

    def _call_pyspark(self, pss: PySparkSingleton, df: ps.DataFrame) -> Dict[str, Any]:
        n = df.count()

        mask = pss.func.isnan(pss.func.col(self.column)) | pss.func.col(self.column).isNull()
        df = df.filter(~mask)

        if self.strict:
            k = df.filter(pss.func.col(self.column) > self.value).count()
        else:
            k = df.filter(pss.func.col(self.column) >= self.value).count()

        return {"total": n, "count": k, "delta": k / n}

    def _call_clickhouse(
            self,
            table_name: str,
            sql_connector: conn.ClickHouseConnector
    ) -> Dict[str, Any]:
        query = f'''
            select count(1) as n,
                count(1) filter (where {self.column} {self._cmp_sign} %(value)s) as k
            from {table_name}
        '''

        params = {'value': self.value}

        n, k = sql_connector.execute(query, params)[0]
        delta = 0 if n == 0 else k / n

        return {"total": n, "count": k, "delta": delta}

    def _call_postgresql(
            self,
            table_name: str,
            sql_connector: conn.PostgreSQLConnector
    ) -> Dict[str, Any]:
        query = '''
            select count(1) as n,
                sum(case when %(column)s %(cmp)s %(value)s then 1 else 0 end) as k
            from %(table)s
        '''

        params = {
            'table': AsIs(table_name),
            'column': AsIs(self.column),
            'cmp': AsIs(self._cmp_sign),
            'value': self.value
        }

        n, k = sql_connector.execute(query, params)[0]
        delta = 0 if n == 0 else k / n

        return {"total": n, "count": k, "delta": delta}

    def _call_mssql(self, table_name: str, sql_connector: conn.MSSQLConnector) -> Dict[str, Any]:
        query = f'''
            select count(1) as n,
                sum(case when {self.column} {self._cmp_sign} %(value)s then 1 else 0 end) as k
            from {table_name}
        '''

        params = {'value': self.value}

        n, k = sql_connector.execute(query, params)[0]
        delta = 0 if n == 0 else k / n

        return {"total": n, "count": k, "delta": delta}

    def _call_mysql(self, table_name: str, sql_connector: conn.MySQLConnector) -> Dict[str, Any]:
        query = f'''
            select count(1) as n,
                cast(sum(case when {self.column} {self._cmp_sign} %(value)s then 1 else 0 end) as unsigned) as k
            from {table_name}
        '''

        params = {'value': self.value}

        n, k = sql_connector.execute(query, params)[0]
        delta = 0 if n == 0 else k / n

        return {"total": n, "count": k, "delta": delta}


@dataclass
class CountValueInSet(Metric):
    """Number of values that satisfy possible values set.

    Count values in chosen column
    that are included in the given list ('required_set').
    """

    column: str
    required_set: List

    def _call_pandas(self, df: pd.DataFrame) -> Dict[str, Any]:
        n = len(df)
        k = np.sum(np.isin(df[self.column], self.required_set))

        return {"total": n, "count": k, "delta": k / n}

    def _call_pyspark(self, pss: PySparkSingleton, df: ps.DataFrame) -> Dict[str, Any]:
        n = df.count()
        k = df.filter(pss.func.col(self.column).isin(self.required_set)).count()

        return {"total": n, "count": k, "delta": k / n}

    def _call_clickhouse(
            self,
            table_name: str,
            sql_connector: conn.ClickHouseConnector
    ) -> Dict[str, Any]:
        query = f'''
            select count(1) as n,
	            count(1) filter(where {self.column} in {tuple(self.required_set)}) as k
            from {table_name};
        '''

        n, k = sql_connector.execute(query)[0]
        delta = 0 if n == 0 else k / n

        return {"total": n, "count": k, "delta": delta}

    def _call_postgresql(
            self,
            table_name: str,
            sql_connector: conn.PostgreSQLConnector
    ) -> Dict[str, Any]:
        query = '''
            select count(1) as n,
	            sum(case when %(column)s in %(set)s then 1 else 0 end) as k
            from %(table)s;
        '''

        params = {
            'table': AsIs(table_name),
            'column': AsIs(self.column),
            'set': AsIs(tuple(self.required_set))
        }

        n, k = sql_connector.execute(query, params)[0]
        delta = 0 if n == 0 else k / n

        return {"total": n, "count": k, "delta": delta}


    def _call_mssql(self, table_name: str, sql_connector: conn.MSSQLConnector) -> Dict[str, Any]:
        query = f'''
            select count(1) as n,
	            sum(case when {self.column} in {tuple(self.required_set)} then 1 else 0 end) as k
            from {table_name}
        '''

        n, k = sql_connector.execute(query)[0]
        delta = 0 if n == 0 else k / n

        return {"total": n, "count": k, "delta": delta}

    def _call_mysql(self, table_name: str, sql_connector: conn.MySQLConnector) -> Dict[str, Any]:
        query = f'''
            select count(1) as n,
	            cast(sum(case when {self.column} in {tuple(self.required_set)} then 1 else 0 end) as unsigned) as k
            from {table_name}
        '''

        n, k = sql_connector.execute(query)[0]
        delta = 0 if n == 0 else k / n

        return {"total": n, "count": k, "delta": delta}


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

        self._cmp_signs = ('>', '<') if self.strict else ('>=', '<=')

    def _call_pandas(self, df: pd.DataFrame) -> Dict[str, Any]:
        n = len(df)
        values = df[self.column].values

        if self.strict:
            k = np.sum(np.logical_and(
                values > self.lower_bound,
                values < self.upper_bound
            ))
        else:
            k = np.sum(np.logical_and(
                values >= self.lower_bound,
                values <= self.upper_bound
            ))

        return {"total": n, "count": k, "delta": k / n}

    def _call_pyspark(self, pss: PySparkSingleton, df: ps.DataFrame) -> Dict[str, Any]:
        n = df.count()

        if self.strict:
            k = df.filter(
                (pss.func.col(self.column) < self.upper_bound)
                & (pss.func.col(self.column) > self.lower_bound)
            ).count()
        else:
            k = df.filter(
                (pss.func.col(self.column) <= self.upper_bound)
                & (pss.func.col(self.column) >= self.lower_bound)
            ).count()

        return {"total": n, "count": k, "delta": k / n}

    def _call_clickhouse(
            self,
            table_name: str,
            sql_connector: conn.ClickHouseConnector
    ) -> Dict[str, Any]:
        query = f'''
            select count(1) as n,
	            count(1) filter(where {self.column} {self._cmp_signs[0]} %(val1)s and
                    {self.column} {self._cmp_signs[1]} %(val2)s) as k
            from {table_name};
        '''

        params = {
            'val1': self.lower_bound,
            'val2': self.upper_bound
        }

        n, k = sql_connector.execute(query, params)[0]
        delta = 0 if n == 0 else k / n

        return {"total": n, "count": k, "delta": delta}

    def _call_postgresql(
            self,
            table_name: str,
            sql_connector: conn.PostgreSQLConnector
    ) -> Dict[str, Any]:
        query = '''
            select count(1) as n,
	            sum(case when %(column)s %(cmp1)s %(val1)s and
                    %(column)s %(cmp2)s %(val2)s then 1 else 0 end) as k
            from %(table)s;
        '''

        params = {
            'table': AsIs(table_name),
            'column': AsIs(self.column),
            'cmp1': AsIs(self._cmp_signs[0]),
            'val1': self.lower_bound,
            'cmp2': AsIs(self._cmp_signs[1]),
            'val2': self.upper_bound
        }

        n, k = sql_connector.execute(query, params)[0]
        delta = 0 if n == 0 else k / n

        return {"total": n, "count": k, "delta": delta}

    def _call_mssql(self, table_name: str, sql_connector: conn.MSSQLConnector) -> Dict[str, Any]:
        query = f'''
            select count(1) as n,
	            sum(case when {self.column} {self._cmp_signs[0]} %(val1)s and
                    {self.column} {self._cmp_signs[1]} %(val2)s then 1 else 0 end) as k
            from {table_name}
        '''

        params = {
            'val1': self.lower_bound,
            'val2': self.upper_bound
        }

        n, k = sql_connector.execute(query, params)[0]
        delta = 0 if n == 0 else k / n

        return {"total": n, "count": k, "delta": delta}

    def _call_mysql(self, table_name: str, sql_connector: conn.MySQLConnector) -> Dict[str, Any]:
        query = f'''
            select count(1) as n,
                cast(sum(case when {self.column} {self._cmp_signs[0]} %(val1)s and
                    {self.column} {self._cmp_signs[1]} %(val2)s then 1 else 0 end) as unsigned) as k
            from {table_name}
        '''

        params = {
            'val1': self.lower_bound,
            'val2': self.upper_bound
        }

        n, k = sql_connector.execute(query, params)[0]
        delta = 0 if n == 0 else k / n

        return {"total": n, "count": k, "delta": delta}


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

        self._signs = ('>', '+') if self.style == 'greater' else ('<', '-')

    def _call_pandas(self, df: pd.DataFrame) -> Dict[str, Any]:
        n = len(df)
        values = df[self.column]
        mean = np.mean(values)
        std = np.std(values)

        if self.style == "greater":
            k = np.sum(values > (mean + self.std_coef * std))
        else:
            k = np.sum(values < (mean - self.std_coef * std))

        return {"total": n, "count": k, "delta": k / n}

    def _call_pyspark(self, pss: PySparkSingleton, df: ps.DataFrame) -> Dict[str, Any]:
        n = df.count()

        mask = pss.func.isnan(pss.func.col(self.column)) | pss.func.col(self.column).isNull()
        df = df.filter(~mask)

        df_stats = df.select(
            pss.func.mean(pss.func.col(self.column)).alias("mean"),
            pss.func.stddev(pss.func.col(self.column)).alias("std")
        ).collect()

        mean = df_stats[0]["mean"]
        std = df_stats[0]["std"]

        if self.style == "greater":
            k = df.filter(pss.func.col(self.column) > (mean + self.std_coef * std)).count()
        else:
            k = df.filter(pss.func.col(self.column) < (mean - self.std_coef * std)).count()

        return {"total": n, "count": k, "delta": k / n}

    def _call_clickhouse(
            self,
            table_name: str,
            sql_connector: conn.ClickHouseConnector
    ) -> Dict[str, Any]:
        query = f'''
            with stats as (
                select avg({self.column}) as mean, stddevPopStable({self.column}) as std
                from {table_name}
            )
            select count(1) as n,
                count(1) filter(where {self.column} {self._signs[0]} (st.mean {self._signs[1]} %(coeff)s*st.std)) as k
            from {table_name} t, stats st;
        '''
        params = {'coeff': self.std_coef}

        n, k = sql_connector.execute(query, params)[0]
        delta = 0 if n == 0 else k / n

        return {"total": n, "count": k, "delta": delta}

    def _call_postgresql(
            self,
            table_name: str,
            sql_connector: conn.PostgreSQLConnector
    ) -> Dict[str, Any]:
        query = '''
            with stats as (
                select avg(%(column)s) as mean, stddev(%(column)s) as std
                from %(table)s
            )
            select count(1) as n,
                sum(case when %(column)s %(sign1)s (st.mean %(sign2)s %(coeff)s*st.std) then 1 else 0 end) as k
            from %(table)s t, stats st;
        '''

        params = {
            'table': AsIs(table_name),
            'column': AsIs(self.column),
            'sign1': AsIs(self._signs[0]),
            'sign2': AsIs(self._signs[1]),
            'coeff': self.std_coef
        }

        n, k = sql_connector.execute(query, params)[0]
        delta = 0 if n == 0 else k / n

        return {"total": n, "count": k, "delta": delta}

    def _call_mssql(self, table_name: str, sql_connector: conn.MSSQLConnector) -> Dict[str, Any]:
        query = f'''
            with stats as (
                select avg(cast({self.column} as real)) as mean,
                    stdev(cast({self.column} as real)) as std
                from {table_name}
            )
            select count(1) as n,
                sum(case when {self.column} {self._signs[0]} (st.mean {self._signs[1]} %(coeff)s*st.std) then 1 else 0 end) as k
            from {table_name} t, stats st;
        '''

        params = {'coeff': self.std_coef}

        n, k = sql_connector.execute(query, params)[0]
        delta = 0 if n == 0 else k / n

        return {"total": n, "count": k, "delta": delta}

    def _call_mysql(self, table_name: str, sql_connector: conn.MySQLConnector) -> Dict[str, Any]:
        query = f'''
            with stats as (
                select avg({self.column}) as mean,
                    stddev({self.column}) as std
                from {table_name}
            )
            select count(1) as n,
                cast(sum(case when {self.column} {self._signs[0]} (st.mean {self._signs[1]} %(coeff)s*st.std) then 1 else 0 end) as unsigned) as k
            from {table_name} t, stats st;
        '''

        params = {'coeff': self.std_coef}

        n, k = sql_connector.execute(query, params)[0]
        delta = 0 if n == 0 else k / n

        return {"total": n, "count": k, "delta": delta}


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

        self._cmp_sign = '>' if self.style == 'greater' else '<'

    def _call_pandas(self, df: pd.DataFrame) -> Dict[str, Any]:
        n = len(df)

        values = df[df[self.column].notnull()][self.column].values
        quantile_value = np.quantile(values, self.q)

        if self.style == "greater":
            k = np.sum(values > quantile_value)
        else:
            k = np.sum(values < quantile_value)

        return {"total": n, "count": k, "delta": k / n}

    def _call_pyspark(self, pss: PySparkSingleton, df: ps.DataFrame) -> Dict[str, Any]:
        n = df.count()

        mask = pss.func.isnan(pss.func.col(self.column)) | pss.func.col(self.column).isNull()
        df = df.filter(~mask)

        st = pss.sql.DataFrameStatFunctions(df)
        quantile_value = st.approxQuantile(self.column, [self.q], 0)[0]
        if self.style == "greater":
            k = df.filter(pss.func.col(self.column) > quantile_value).count()
        else:
            k = df.filter(pss.func.col(self.column) < quantile_value).count()

        return {"total": n, "count": k, "delta": k / n}

    def _call_clickhouse(
            self,
            table_name: str,
            sql_connector: conn.ClickHouseConnector
    ) -> Dict[str, Any]:
        query = f'''
            with stats as (
                select quantile(%(per)s)({self.column}) as qv
                from {table_name}
            )
            select count(1) as n,
                count(1) filter(where t.{self.column} {self._cmp_sign} st.qv) as k
            from {table_name} t, stats st
        '''

        params = {'per': self.q}

        n, k = sql_connector.execute(query, params)[0]
        delta = 0 if n == 0 else k / n

        return {"total": n, "count": k, "delta": delta}

    def _call_postgresql(
            self,
            table_name: str,
            sql_connector: conn.PostgreSQLConnector
    ) -> Dict[str, Any]:
        query = '''
            with stats as (
                select percentile_cont(%(per)s) within group (order by %(column)s) as p
                from %(table)s
            )
            select count(1) as n,
                sum(case when t.%(column)s %(cmp)s st.p then 1 else 0 end) as k
            from %(table)s t, stats st
        '''

        params = {
            'table': AsIs(table_name),
            'column': AsIs(self.column),
            'cmp': AsIs(self._cmp_sign),
            'per': self.q,
        }

        n, k = sql_connector.execute(query, params)[0]
        delta = 0 if n == 0 else k / n

        return {"total": n, "count": k, "delta": delta}

    def _call_mssql(self, table_name: str, sql_connector: conn.MSSQLConnector) -> Dict[str, Any]:
        cmp_sign = '>' if self.style == 'greater' else '<'

        query = f'''
            with stats as (
                select distinct percentile_cont(%(per)s) within group (order by {self.column}) over () as p
                from {table_name}
            )
            select count(1) as n,
                sum(case when {self.column} {cmp_sign} st.p then 1 else 0 end) as k
            from {table_name} t, stats st
        '''

        params = {'per': self.q}

        n, k = sql_connector.execute(query, params)[0]
        delta = 0 if n == 0 else k / n

        return {"total": n, "count": k, "delta": delta}

    def _call_mysql(self, table_name: str, sql_connector: conn.MySQLConnector) -> Dict[str, Any]:
        query = f'''
            with pos as (
                select floor(%(per)s*count(1)) as start_pos,
                    ceil(%(per)s*count(1)) as end_pos
                from {table_name}
                where {self.column} is not null
            ),
            ranked_rows as (
                select {self.column},
                    row_number() over(order by {self.column}) as x
                from {table_name}
                where {self.column} is not null
            ),
            qv as (
                select avg(rr.{self.column}) as x
                from ranked_rows rr, pos p
                where rr.x between p.start_pos and p.end_pos
            )
            select count(1) as n,
                cast(sum(case when {self.column} {self._cmp_sign} qv.x then 1 else 0 end) as unsigned) as k
            from {table_name} t, qv
        '''

        params = {'per': self.q}

        n, k = sql_connector.execute(query, params)[0]
        delta = 0 if n == 0 else k / n

        return {"total": n, "count": k, "delta": delta}


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
        empty_rows_qty = np.sum(df[self.column].isna())

        if empty_rows_qty != 0:
            raise ValueError(f"None/nan values in column: {self.column}.")

        daily_rows = df.groupby(pd.to_datetime(df[self.column]).dt.date).size().values

        last_date_count = daily_rows[-1]
        average = np.mean(daily_rows[:-1])
        percentage = (last_date_count / average) * 100
        at_least = percentage >= self.percent

        return {
            "average": average,
            "last_date_count": last_date_count,
            "percentage": percentage,
            f"at_least_{self.percent}%": at_least,
        }

    def _call_pyspark(self, pss: PySparkSingleton, df: ps.DataFrame) -> Dict[str, Any]:
        empty_rows_qty = df.filter(
            pss.func.col(self.column).isNull() |
            pss.func.isnan(self.column)
        ).count()

        if empty_rows_qty != 0:
            raise ValueError(f"None/nan values in column: {self.column}.")

        daily_rows = df.groupBy(pss.func.to_date(pss.func.col(self.column)).alias(self.column)).\
            count().sort(pss.func.asc(self.column)).select('count')

        counts = [row['count'] for row in daily_rows.select('count').toLocalIterator()]
        last_date_count = counts[-1]
        average = np.mean(counts[:-1])
        percentage = (last_date_count / average) * 100
        at_least = percentage >= self.percent

        return {
            "average": average,
            "last_date_count": last_date_count,
            "percentage": percentage,
            f"at_least_{self.percent}%": at_least,
        }

    def _call_clickhouse(
            self,
            table_name: str,
            sql_connector: conn.ClickHouseConnector
    ) -> Dict[str, Any]:
        query = f'''
            with groups as (
                select {self.column}::date, count(1) as qty, row_number() over w as x
                from {table_name}
                group by {self.column}::date
                window w as (
                    order by {self.column}::date desc
                )
            )
            select sum(qty) filter(where x != 1) / count(1) filter(where x != 1) as average,
                max(qty) filter(where x = 1) as last_day_count
            from groups
        '''

        average, last_date_count = sql_connector.execute(query)[0]
        percentage = (last_date_count / float(average)) * 100
        at_least = percentage >= self.percent

        return {
            "average": float(average),
            "last_date_count": last_date_count,
            "percentage": percentage,
            f"at_least_{self.percent}%": at_least,
        }

    def _call_postgresql(
            self,
            table_name: str,
            sql_connector: conn.PostgreSQLConnector
    ) -> Dict[str, Any]:
        query = '''
            with groups as (
                select %(column)s::date, count(1) as qty, row_number() over w as x
                from %(table)s
                group by %(column)s::date
                window w as (
                    order by %(column)s::date desc
                )
            )
            select sum(case when x != 1 then qty else 0 end) /
                sum(case when x != 1 then 1 else 0 end) as average,
                max(case when x = 1 then qty else 0 end) as last_day_count
            from groups
        '''

        params = {
            'table': AsIs(table_name),
            'column': AsIs(self.column)
        }

        average, last_date_count = sql_connector.execute(query, params)[0]
        percentage = (last_date_count / float(average)) * 100
        at_least = percentage >= self.percent

        return {
            "average": float(average),
            "last_date_count": last_date_count,
            "percentage": percentage,
            f"at_least_{self.percent}%": at_least,
        }

    def _call_mssql(self, table_name: str, sql_connector: conn.MSSQLConnector) -> Dict[str, Any]:
        query = f'''
            with groups as (
                select cast({self.column} as date) as day,
                    count(1) as qty,
                    row_number() over (order by cast({self.column} as date) desc) as x
                from {table_name}
                group by cast({self.column} as date)
            )
            select sum(case when x != 1 then cast(qty as real) else 0 end) /
                sum(case when x != 1 then 1 else 0 end) as average,
                max(case when x = 1 then qty else 0 end) as last_day_count
            from groups
        '''

        average, last_date_count = sql_connector.execute(query)[0]
        percentage = (last_date_count / float(average)) * 100
        at_least = percentage >= self.percent

        return {
            "average": float(average),
            "last_date_count": last_date_count,
            "percentage": percentage,
            f"at_least_{self.percent}%": at_least,
        }

    def _call_mysql(self, table_name: str, sql_connector: conn.MySQLConnector) -> Dict[str, Any]:
        query = f'''
            with groups_ as (
                select cast({self.column} as date) as day,
                    count(1) as qty,
                    row_number() over (order by cast({self.column} as date) desc) as x
                from {table_name}
                group by cast({self.column} as date)
            )
            select sum(case when x != 1 then qty else 0 end) /
                sum(case when x != 1 then 1 else 0 end) as average,
                max(case when x = 1 then qty else 0 end) as last_day_count
            from groups_
        '''

        average, last_date_count = sql_connector.execute(query)[0]
        percentage = (last_date_count / float(average)) * 100
        at_least = percentage >= self.percent

        return {
            "average": float(average),
            "last_date_count": last_date_count,
            "percentage": percentage,
            f"at_least_{self.percent}%": at_least,
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
        empty_rows_qty = np.sum(df[self.column].isna())

        if empty_rows_qty != 0:
            raise ValueError(f"None/nan values in column: {self.column}.")

        if self.number >= len(np.unique(df[self.column])):
            raise ValueError(
                "Number of days to check is greater or equal than total number of days."
            )

        daily_rows = df.groupby(pd.to_datetime(df[self.column]).dt.date).size().values
        average = daily_rows[: -self.number].mean()
        k = np.sum((daily_rows[-self.number :] / average * 100) >= self.percent)

        return {"average": average, "days": k}

    def _call_pyspark(self, pss: PySparkSingleton, df: ps.DataFrame) -> Dict[str, Any]:
        empty_rows_qty = df.filter(
            pss.func.col(self.column).isNull() |
            pss.func.isnan(self.column)
        ).count()

        if empty_rows_qty != 0:
            raise ValueError(f"None/nan values in column: {self.column}.")

        daily_rows = df.groupBy(pss.func.to_date(pss.func.col(self.column)).alias(self.column)).\
            count().sort(pss.func.asc(self.column)).select('count')

        if self.number >= daily_rows.count():
            raise ValueError(
                "Number of days to check is greater or equal than total number of days."
            )

        counts = [row['count'] for row in daily_rows.select('count').toLocalIterator()]
        last_dates_count = counts[-self.number:]
        average = np.mean(counts[:-self.number])
        k = sum([(x / average * 100) >= self.percent for x in last_dates_count])

        return {"average": average, "days": k}

    def _call_clickhouse(
        self,
        table_name: str,
        sql_connector: conn.ClickHouseConnector
    ) -> Dict[str, Any]:
        query = f'''
            with groups as (
                select {self.column}::date, count(1) as qty, row_number() over w as x
                from {table_name}
                group by {self.column}::date
                window w as (
                    order by {self.column}::date desc
                )
            ),
            stats as (
                select avg(qty) as mean
                from groups
                where x > %(days)s
            )
            select max(st.mean) as average,
                sum(case when (g.qty / st.mean) >= %(percent)s then 1 else 0 end) as days
            from groups g, stats st
            where x <= %(days)s
        '''

        params = {
            'days': self.number,
            'percent': self.percent / 100
        }

        average, days = sql_connector.execute(query, params)[0]

        return {"average": float(average), "days": days}

    def _call_postgresql(
        self,
        table_name: str,
        sql_connector: conn.PostgreSQLConnector
    ) -> Dict[str, Any]:
        query = '''
            with groups as (
                select %(column)s::date, count(1) as qty, row_number() over w as x
                from %(table)s
                group by %(column)s::date
                window w as (
                    order by %(column)s::date desc
                )
            ),
            stats as (
                select avg(qty) as mean
                from groups
                where x > %(days)s
            )
            select max(st.mean) as average,
                sum(case when (g.qty / st.mean) >= %(percent)s then 1 else 0 end) as days
            from groups g, stats st
            where x <= %(days)s
        '''

        params = {
            'table': AsIs(table_name),
            'column': AsIs(self.column),
            'days': self.number,
            'percent': self.percent / 100
        }

        average, days = sql_connector.execute(query, params)[0]

        return {"average": float(average), "days": days}

    def _call_mssql(self, table_name: str, sql_connector: conn.MSSQLConnector) -> Dict[str, Any]:
        query = f'''
            with groups as (
                select cast({self.column} as date) as day,
                    cast(count(1) as real) as qty,
                    row_number() over (order by cast({self.column} as date) desc) as x
                from {table_name}
                group by cast({self.column} as date)
            ),
            stats as (
                select avg(qty) as mean
                from groups
                where x > %(days)s
            )
            select max(st.mean) as average,
                sum(case when (g.qty / st.mean) >= %(percent)s then 1 else 0 end) as days
            from groups g, stats st
            where x <= %(days)s
        '''

        params = {
            'days': self.number,
            'percent': self.percent / 100
        }

        average, days = sql_connector.execute(query, params)[0]

        return {"average": average, "days": days}

    def _call_mysql(self, table_name: str, sql_connector: conn.MySQLConnector) -> Dict[str, Any]:
        query = f'''
            with groups_ as (
                select cast({self.column} as date) as day,
                    count(1) as qty,
                    row_number() over (order by cast({self.column} as date) desc) as x
                from {table_name}
                group by cast({self.column} as date)
            ),
            stats as (
                select avg(qty) as mean
                from groups_
                where x > %(days)s
            )
            select max(st.mean) as average,
                cast(sum(case when (g.qty / st.mean) >= %(percent)s then 1 else 0 end) as unsigned) as days
            from groups_ g, stats st
            where x <= %(days)s
        '''

        params = {
            'days': self.number,
            'percent': self.percent / 100
        }

        average, days = sql_connector.execute(query, params)[0]

        return {"average": float(average), "days": days}


@dataclass
class CheckAdversarialValidation(Metric):
    """Apply adversarial validation technic.

    Define indexes for first and second slices.
    To get slices of initial dataset uses indexes for pandas dataframe
    otherwise values from specified column.

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
    column: str = "index"

    def __post_init__(self):
        if len(self.first_slice) != 2 or len(self.second_slice) != 2:
            raise ValueError("Slices must be length of 2.")

        self._start_1, self._end_1 = self.first_slice[0], self.first_slice[1]
        self._start_2, self._end_2 = self.second_slice[0], self.second_slice[1]

        if self._start_1 >= self._end_1 or self._start_2 >= self._end_2:
            raise ValueError("First value in slice must be lower than second value in slice.")

        if (self._start_1 < self._start_2 < self._end_1) or \
            (self._start_1 < self._end_2 < self._end_1):
            raise ValueError("Slices must not overlap.")

    def _compare_samples(self, X: np.ndarray, y: np.ndarray, columns: List[str]) ->\
        Tuple[bool, Dict[str, float], float]:
        """
        Determines how successfully the binary classification model
        separates the elements of the training and test samples.

        Returns averaged roc_auc_score and feature importances for 5-folds cv.
        """

        is_similar = True
        importance_dict = {}

        classifier = RandomForestClassifier(random_state=42)
        cv_result = cross_validate(classifier, X, y, cv=5, scoring='roc_auc', return_estimator=True)
        mean_score = np.mean(cv_result['test_score'])

        if mean_score > 0.5 + self.eps:
            is_similar = False

            importances = np.mean(
                [est.feature_importances_ for est in cv_result['estimator']],
                axis=0
            )
            importance_dict = dict(zip(columns, np.around(importances, 5)))

        return is_similar, importance_dict, np.around(mean_score, 5)

    def _call_pandas(self, df: pd.DataFrame) -> Dict[str, Any]:
        num_data = df.select_dtypes(include=["number"])
        if len(num_data) == 0:
            raise ValueError("Dataframe contains only non-numeric values.")

        try:
            first_part = num_data.loc[self._start_1 : self._end_1, :]
            second_part = num_data.loc[self._start_2 : self._end_2, :]
        except:
            raise

        if len(first_part) == 0 or len(second_part) == 0:
            raise ValueError("Values in slices should be values from dataframe index.")

        first_part.insert(0, "av_label", 0)
        second_part.insert(0, "av_label", 1)

        data = pd.concat([first_part, second_part], axis=0)
        shuffled_data = data.sample(frac=1, random_state=42)
        shuffled_data = shuffled_data.fillna(np.min(shuffled_data.min()) - 1000)

        X = shuffled_data.drop(["av_label"], axis=1)
        y = shuffled_data["av_label"].values

        is_similar, importance_dict, score = self._compare_samples(X.values, y, X.columns)

        return {
            "similar": is_similar,
            "importances": importance_dict,
            "cv_roc_auc": score
        }

    def _call_pyspark(self, pss: PySparkSingleton, df: ps.DataFrame) -> Dict[str, Any]:
        if self.column not in df.columns:
            raise ValueError(f'Dataframe must contain "{self.column}" column to get slices.')

        is_similar = True
        importance_dict = {}

        num_types = ['int', 'bigint', 'float', 'double']
        num_cols = [
            col for col, data_type in df.dtypes
            if (data_type in num_types) & (col != self.column)
        ]

        if len(num_cols) == 0:
            raise ValueError("Dataframe contains only non-numeric values.")

        num_data = df.select(num_cols)

        col_mins = num_data.agg(
            *[pss.func.min(pss.func.col(column)).alias(f"{column}") for column in num_cols]
        )
        min_value = col_mins.select(pss.func.least(*col_mins.columns)).collect()[0][0]
        num_data = num_data.fillna(min_value - 1000)

        try:
            first_part = num_data.filter(
                (pss.func.to_date(pss.func.col(self.column)) >= self._start_1) &
                (pss.func.to_date(pss.func.col(self.column)) < self._end_1)
            ).withColumn('av_label', pss.func.lit(0))

            second_part = num_data.filter(
                (pss.func.to_date(pss.func.col(self.column)) >= self._start_2) &
                (pss.func.to_date(pss.func.col(self.column)) < self._end_2)
            ).withColumn('av_label', pss.func.lit(1))
        except:
            raise

        if first_part.count() == 0 or second_part.count() == 0:
            raise ValueError(f"Values in slices should be values from column {self.column}.")

        data = first_part.union(second_part)
        shuffled_data = np.array(shuffle(data.collect(), random_state=42))

        X = shuffled_data[:, :-1]
        y = shuffled_data[:, -1]

        is_similar, importance_dict, score = self._compare_samples(X, y, num_cols)

        return {
            "similar": is_similar,
            "importances": importance_dict,
            "cv_roc_auc": score
        }

    def _call_clickhouse(
            self,
            table_name: str,
            sql_connector: conn.ClickHouseConnector
    ) -> Dict[str, Any]:
        query_num_cols = '''
            select groupArray(column_name) as num_columns
            from information_schema.columns
            where table_name=%(table)s and column_name != %(index_col)s and
                data_type in (
                    'UInt8', 'UInt16', 'UInt32', 'UInt64', 'UInt128', 'UInt256',
                    'Int8', 'Int16', 'Int32', 'Int64', 'Int128', 'Int256', 'Float32', 'Float64', 'Decimal',
                    'Nullable(UInt8)', 'Nullable(UInt16)', 'Nullable(UInt32)', 'Nullable(UInt64)', 'Nullable(UInt128)', 'Nullable(UInt256)',
                    'Nullable(Int8)', 'Nullable(Int16)', 'Nullable(Int32)', 'Nullable(Int64)', 'Nullable(Int128)', 'Nullable(Int256)',
                    'Nullable(Float32)', 'Nullable(Float64)', 'Nullable(Decimal)'
                )
        '''

        params = {
            'table': table_name,
            'index_col': self.column
        }

        num_cols = sql_connector.execute(query_num_cols, params)[0][0]

        if num_cols is None:
            raise ValueError(f'Table "{table_name}" contains only non-numeric values.')

        coalesce_cols = [f"coalesce(t.{col}, m.min) as {col}" for col in  num_cols]

        query_final = f'''
            with global_min as (
                select min(least({', '.join(num_cols)})) - 1000 as min
                from {table_name}
            )
            select {', '.join(coalesce_cols)},
                case when ({self.column} >= %(start1)s and {self.column} < %(end1)s) then 0 else 1 end as av_label
            from {table_name} t, global_min m
            where ({self.column} >= %(start1)s and {self.column} < %(end1)s) or
                ({self.column} >= %(start2)s and {self.column} < %(end2)s)
            order by {self.column}
        '''

        params = {
            'start1': self._start_1,
            'end1': self._end_1,
            'start2': self._start_2,
            'end2': self._end_2
        }

        data = np.array(sql_connector.execute(query_final, params))

        first_part_size = np.sum(data[:, -1] == 0)
        second_part_size = np.sum(data[:, -1] == 1)

        if first_part_size == 0 or second_part_size == 0:
            raise ValueError(f"Values in slices should be values from column {self.column}.")

        shuffled_data = shuffle(data, random_state=42)
        X = shuffled_data[:, :-1]
        y = shuffled_data[:, -1]

        is_similar, importance_dict, score = self._compare_samples(X, y, num_cols)

        return {
            "similar": is_similar,
            "importances": importance_dict,
            "cv_roc_auc": score
        }

    def _call_postgresql(
        self,
        table_name: str,
        sql_connector: conn.PostgreSQLConnector
    ) -> Dict[str, Any]:
        query_num_cols = '''
            select string_agg(column_name, ',') as num_columns
            from information_schema.columns
            where table_name=%(table)s and column_name != %(index_col)s and
                data_type in ('smallint', 'integer', 'bigint', 'decimal', 'numeric', 'real', 'double precision')
        '''

        params = {
            'table': table_name,
            'index_col': self.column
        }

        str_num_cols = sql_connector.execute(query_num_cols, params)[0][0]
        num_cols = str_num_cols.split(',')

        if str_num_cols is None:
            raise ValueError(f'Table "{table_name}" contains only non-numeric values.')

        coalesce_cols = [f"coalesce({col}, m.min)::float as {col}" for col in  num_cols]

        query_final = '''
            with global_min as (
                select min(least(%(num_columns)s)) - 1000 as min
                from %(table)s
            )
            select %(coalesce_columns)s,
                case when (%(index_col)s >= %(start1)s and %(index_col)s < %(end1)s) then 0 else 1 end as av_label
            from %(table)s t, global_min m
            where (%(index_col)s >= %(start1)s and %(index_col)s < %(end1)s) or
                (%(index_col)s >= %(start2)s and %(index_col)s < %(end2)s)
            order by %(index_col)s
        '''

        params = {
            'table': AsIs(table_name),
            'index_col': AsIs(self.column),
            'num_columns': AsIs(str_num_cols),
            'coalesce_columns': AsIs(', '.join(coalesce_cols)),
            'start1': self._start_1,
            'end1': self._end_1,
            'start2': self._start_2,
            'end2': self._end_2
        }

        data = np.array(sql_connector.execute(query_final, params))

        first_part_size = np.sum(data[:, -1] == 0)
        second_part_size = np.sum(data[:, -1] == 1)

        if first_part_size == 0 or second_part_size == 0:
            raise ValueError(f"Values in slices should be values from column {self.column}.")

        shuffled_data = shuffle(data, random_state=42)
        X = shuffled_data[:, :-1]
        y = shuffled_data[:, -1]

        is_similar, importance_dict, score = self._compare_samples(X, y, num_cols)

        return {
            "similar": is_similar,
            "importances": importance_dict,
            "cv_roc_auc": score
        }

    def _call_mssql(self, table_name: str, sql_connector: conn.MSSQLConnector) -> Dict[str, Any]:
        query_num_cols = '''
            select string_agg(column_name, ',') as num_columns
            from information_schema.columns
            where table_name=%(table)s and column_name != %(index_col)s and
                data_type in ('bit', 'decimal', 'numeric', 'float', 'real',
                    'int', 'bigint', 'smallint', 'tinyint', 'money', 'smallmoney')
        '''

        params = {
            'table': table_name,
            'index_col': self.column
        }

        str_num_cols = sql_connector.execute(query_num_cols, params)[0][0]
        num_cols = str_num_cols.split(',')

        if str_num_cols is None:
            raise ValueError(f'Table "{table_name}" contains only non-numeric values.')

        coalesce_cols = [f"coalesce(t.{col}, m.min) as {col}" for col in  num_cols]
        str_coalesce_cols = ', '.join(coalesce_cols)

        min_cols = [f"min(cast({col} as float)) as {col}" for col in  num_cols]
        str_min_cols = ', '.join(min_cols)

        query_final = f'''
            with columns_min as (
                select {str_min_cols}
                from {table_name}
            ),
            global_min as (
                select min(col_min) - 1000 as min
                from columns_min
                unpivot (col_min for column_name in ({str_num_cols})) as t
            )
            select {str_coalesce_cols},
                case when ([{self.column}] >= %(start1)s and [{self.column}] < %(end1)s) then 0 else 1 end as av_label
            from {table_name} t, global_min m
            where ([{self.column}] >= %(start1)s and [{self.column}] < %(end1)s) or
                ([{self.column}] >= %(start2)s and [{self.column}] < %(end2)s)
            order by [{self.column}]
        '''

        params = {
            'start1': self._start_1,
            'end1': self._end_1,
            'start2': self._start_2,
            'end2': self._end_2
        }

        data = np.array(sql_connector.execute(query_final, params))

        first_part_size = np.sum(data[:, -1] == 0)
        second_part_size = np.sum(data[:, -1] == 1)

        if first_part_size == 0 or second_part_size == 0:
            raise ValueError(f"Values in slices should be values from column {self.column}.")

        shuffled_data = shuffle(data, random_state=42)
        X = shuffled_data[:, :-1]
        y = shuffled_data[:, -1]

        is_similar, importance_dict, score = self._compare_samples(X, y, num_cols)

        return {
            "similar": is_similar,
            "importances": importance_dict,
            "cv_roc_auc": score
        }

    def _call_mysql(self, table_name: str, sql_connector: conn.MySQLConnector) -> Dict[str, Any]:
        query_num_cols = '''
            select group_concat(column_name) as num_columns
            from information_schema.columns
            where table_name=%(table)s and numeric_precision is not null and column_name <>%(index_col)s;
        '''

        params = {
            'table': table_name,
            'index_col': self.column
        }

        str_num_cols = sql_connector.execute(query_num_cols, params)[0][0]
        num_cols = str_num_cols.split(',')

        if str_num_cols is None:
            raise ValueError(f'Table "{table_name}" contains only non-numeric values.')

        coalesce_cols = [f"coalesce(t.{col}, m.min) as {col}" for col in  num_cols]
        str_coalesce_cols = ', '.join(coalesce_cols)

        query_final = f'''
            with global_min as (
                select min(least({str_num_cols})) - 1000 as min
                from {table_name}
            )
            select {str_coalesce_cols},
                case when (`{self.column}` >= %(start1)s and `{self.column}` < %(end1)s) then 0 else 1 end as av_label
            from {table_name} t, global_min m
            where (`{self.column}` >= %(start1)s and `{self.column}` < %(end1)s) or
                (`{self.column}` >= %(start2)s and `{self.column}` < %(end2)s)
            order by `{self.column}`
        '''

        params = {
            'start1': self._start_1,
            'end1': self._end_1,
            'start2': self._start_2,
            'end2': self._end_2
        }

        data = np.array(sql_connector.execute(query_final, params), dtype=np.float64)

        first_part_size = np.sum(data[:, -1] == 0)
        second_part_size = np.sum(data[:, -1] == 1)

        if first_part_size == 0 or second_part_size == 0:
            raise ValueError(f"Values in slices should be values from column {self.column}.")

        shuffled_data = shuffle(data, random_state=42)
        X = shuffled_data[:, :-1]
        y = shuffled_data[:, -1]

        is_similar, importance_dict, score = self._compare_samples(X, y, num_cols)

        return {
            "similar": is_similar,
            "importances": importance_dict,
            "cv_roc_auc": score
        }
