from typing import Any, Dict, Union, List
from clickhouse_driver import Client
import pandas as pd
import numpy as np


class ClickhouseMetric:
    """
    Realization of metrics for clickhouse database.

    For all methods table_name must be in format database.table_name
    """

    def __init__(self, host, port, password, user):
        self.host = host
        self.port = port
        self.password = password
        self.user = user
        self._connect()

    def _connect(self):
        """Connect to database using authorization data from init."""
        try:
            self.client = Client(host=self.host,
                                 port=self.port,
                                 user=self.user,
                                 password=self.password, settings={'use_numpy': True})
        except Exception as e:
            print(e)

    def countTotal(self, table_name: str) -> Dict[str, Any]:
        """Total number of rows in DataFrame."""
        n = self.client.execute(f"select count(*) from {table_name}")[0][0]
        return {"total": n}

    def countZeros(self, table_name: str, column: str) -> Dict[str, Any]:
        """Number of zeros in chosen column.

        Count rows where value in chosen column is equal to zero.
        """
        n = self.client.execute(f"select count(*) from {table_name}")[0][0]
        k = self.client.execute(f"select countIf({column} = 0) from {table_name}")[0][0]
        return {"total": n, "count": k, "delta": k / n}

    def countNull(self, table_name: str, columns: List[str], aggregation: str = "any") -> Dict[str, Any]:
        """Number of empty values in chosen columns.

        If 'aggregation' == 'any', then count rows where
        at least one value from defined 'columns' set is Null.
        If 'aggregation' == 'all', then count rows where
        all values from defined 'columns' set are Null.
        """

        n = self.client.execute(f"select count(*) from {table_name}")[0][0]
        if aggregation == "all":
            sep = "and"
        elif aggregation == "any":
            sep = "or"
        else:
            raise ValueError("Unknown value for aggregation")
        try:
            columns_null = f") {sep} (".join(f'isNaN({col})' for col in columns)
            query = f"select count(*) from {table_name} where ({columns_null})"
            k = self.client.execute(query)[0][0]
            return {"total": n, "count": k, "delta": k / n}
        except Exception as e:
            # check values to be NULL or zero length
            columns_null = f") {sep} (".join(f'isNull({col})' for col in columns)
            zero_length = f") {sep} (".join(f"length({col}) = 0" for col in columns)
            query = f"select count(*) from {table_name} where ({columns_null})"
            query_zero = f"select count(*) from {table_name} where ({zero_length})"
            k = self.client.execute(query)[0][0] + self.client.execute(query_zero)[0][0]
            return {"total": n, "count": k, "delta": k / n}

    def countDuplicates(self, table_name: str, columns: List[str]) -> Dict[str, Any]:
        """Number of duplicates in chosen columns."""
        n = self.client.execute(f"select count(*) from {table_name}")[0][0]
        table_columns = ','.join(f"{col}" for col in columns)
        subquery = f"select count(*) - 1 as duplicates_count from {table_name} group by {table_columns} having " \
                   f"duplicates_count > 0 "
        query = f"SELECT SUM(duplicates_count) AS total_duplicates_count from ({subquery}) subquery"
        k = self.client.execute(query)[0][0]
        return {"total": n, "count": k, "delta": k / n}

    def countValue(self, table_name: str, column: str, value: Union[str, int, float]) -> Dict[str, Any]:
        """Number of values in chosen column.

        Count rows that value in chosen column is equal to 'value'.
        """
        n = self.client.execute(f"select count(*) from {table_name}")[0][0]
        try:
            query = f"select count(*) from {table_name} where toDate({column}) = toDate('{value}')"
            k = self.client.execute(query)[0][0]
            return {"total": n, "count": k, "delta": k / n}
        except Exception as e:
            try:
                query = f"select count(*) from {table_name} where {column} = {value}"
                k = self.client.execute(query)[0][0]
                return {"total": n, "count": k, "delta": k / n}
            except Exception as e:
                print(e)

    def countBelowValue(self, table_name: str, column: str, value: float, strict: bool = False) -> Dict[str, Any]:
        """Number of values below threshold.

        Count values in chosen column
        that are lower than defined threshold ('value').
        If 'strict' == False, then inequality is non-strict.
        """

        n = self.client.execute(f"select count(*) from {table_name}")[0][0]
        if not strict:
            ineq = "<="
        else:
            ineq = "<"
        query = f"select count(*) from {table_name} where {column} {ineq} {value}"
        k = self.client.execute(query)[0][0]
        return {"total": n, "count": k, "delta": k / n}

    def countBelowColumn(self, table_name: str, column_x: str, column_y: str, strict: bool = False) -> Dict[str, Any]:
        """Count how often column X below Y.

        Calculate number of rows that value in 'column_x'
        is lower than value in 'column_y'.
        """
        n = self.client.execute(f"select count(*) from {table_name}")[0][0]
        if not strict:
            ineq = "<="
        else:
            ineq = "<"
        query = f"select count(*) from {table_name} where {column_x} {ineq} {column_y}"
        k = self.client.execute(query)[0][0]
        return {"total": n, "count": k, "delta": k / n}

    def countRatioBelow(self, table_name: str, column_x: str, column_y: str, column_z: str, strict: bool = False) -> \
            Dict[str, Any]:
        """Count how often X / Y below Z.

        Calculate number of rows that ratio of values
        in columns 'column_x' and 'column_y' is lower than value in 'column_z'.
        If 'strict' == False, then inequality is non-strict.
        """

        n = self.client.execute(f"select count(*) from {table_name}")[0][0]
        if not strict:
            ineq = "<="
        else:
            ineq = "<"
        query = f"select count(*) from {table_name} where {column_x} / {column_y} {ineq} {column_z}"
        k = self.client.execute(query)[0][0]
        return {"total": n, "count": k, "delta": k / n}

    def countGreaterValue(self, table_name: str, column: str, value: float, strict: bool = False) -> Dict[str, Any]:
        """Number of values greater than threshold.

        Count values in chosen column
        that are greater than defined threshold ('value').
        If 'strict' == False, then inequality is non-strict.
        """

        n = self.client.execute(f"select count(*) from {table_name}")[0][0]
        if not strict:
            ineq = ">="
        else:
            ineq = ">"
        query = f"select count(*) from {table_name} where {column} {ineq} {value}"
        k = self.client.execute(query)[0][0]
        return {"total": n, "count": k, "delta": k / n}

    def countCB(self, table_name: str, column: str, conf: float = 0.95) -> Dict[str, Any]:
        """Lower/upper bounds for N%-confidence interval.

        Calculate bounds for 'conf'-percent interval in chosen column.
        """
        alpha = 1 - conf
        lcb = self.client.execute(f"select quantile({alpha / 2})({column}) from {table_name}")[0][0]
        ucb = self.client.execute(f"select quantile({alpha / 2 + conf})({column}) from {table_name}")[0][0]
        return {"lcb": lcb, "ucb": ucb}

    def countLag(self, table_name: str, column: str) -> Dict[str, Any]:
        """A lag between last date and today.

        Define last date in chosen date column.
        Calculate a lag in days between last date and today.
        """
        today = self.client.execute(f"select today()")[0][0]
        query = f"select toDate({column}) as dt from {table_name} order by dt desc limit 1"
        last_day = self.client.execute(query)[0][0]
        lag = self.client.execute(f"select dateDiff('day', toDate('{last_day}'), toDate('{today}'))")[0][0]
        return {"today": str(today), "last_day": str(last_day), "lag": lag}


if __name__ == "__main__":
    base_params = {'host': 'localhost',
                   'port': '9000',
                   'user': 'user',
                   'password': 'password'}
    # client = Client(host='localhost',
    #                 port='9000',
    #                 user='user',
    #                 password='password', settings={'use_numpy': True})
    table_name = "TABLES2.sales"
    metric = ClickhouseMetric(**base_params)
    # print(metric.countTotal(table_name))
    print(metric.countLag(table_name, "day"))
