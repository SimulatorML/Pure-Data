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
        lcb = self.client.execute(f"select quantileExact({alpha / 2})({column}) from {table_name}")[0][0]
        ucb = self.client.execute(f"select quantileExact({alpha / 2 + conf})({column}) from {table_name}")[0][0]
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

    def countValueInRequiredSet(self, table_name: str, column: str, required_set: List) -> Dict[str, any]:
        """Number of values that satisfy possible values set.

        Count values in chosen column
        that are included in the given list ('required_set').
        """
        n = self.client.execute(f"select count(*) from {table_name}")[0][0]
        query = f"select countIf({column} in {required_set}) as cnt from {table_name}"
        k = self.client.execute(query)[0][0]
        return {"total": n, "count": k, "delta": k / n}

    def countValueInBounds(self, table_name: str, column: str, lower_bound: float, upper_bound: float,
                           strict: bool = False) -> Dict[str, any]:

        """Number of values that are inside available bounds.

        Count values in chosen column that do satisfy defined bounds:
        they are greater than 'lower_bound' or lower than 'upper_bound'.
        If 'strict' is False, then inequalities are non-strict.
        """
        n = self.client.execute(f"select count(*) from {table_name}")[0][0]
        if not strict:
            ineq_1, ineq_2 = ">=", "<="
        else:
            ineq_1, ineq_2 = ">", "<"
        n = self.client.execute(f"select count(*) from {table_name}")[0][0]
        query = f"select countIf({column} {ineq_1} {lower_bound} and {column} {ineq_2} {upper_bound}) as cnt from {table_name}"
        k = self.client.execute(query)[0][0]
        return {"total": n, "count": k, "delta": k / n}

    def countExtremeValuesFormula(self, table_name: str, column: str, std_coef: int, style: str = "greater") -> Dict[
        str, any]:
        """Number of extreme values calculated by formula.

        Calculate mean and std in chosen column.
        Count values in chosen column that are
        greater than mean + std_coef * std if style == 'greater',
        lower than mean - std_coef * std if style == 'lower'.
        """
        n = self.client.execute(f"select count(*) from {table_name}")[0][0]
        sub_query = f"select {column} from {table_name} where isFinite({column})"
        mean = self.client.execute(f"select avg({column}) from ({sub_query})")[0][0]
        std = self.client.execute(f"select stddevPopStable({column}) from ({sub_query})")[0][0]
        if style == "greater":
            query = f"select count(*) from ({sub_query}) where {column} > {mean + std * std_coef}"
        else:
            query = f"select count(*) from ({sub_query}) where {column} < {mean - std * std_coef}"
        k = self.client.execute(query)[0][0]
        return {"total": n, "count": k, "delta": k / n}

    def countExtremeValuesQuantile(self, table_name: str, column: str, q: float = 0.8, style: str = "greater") -> Dict[
        str, any]:
        """Number of extreme values calculated with quantile.

        Calculate quantile in chosen column.
        If style == 'greater', then count values in 'column' that are greater than
        calculated quantile. Otherwise, if style == 'lower', count values that are lower
        than calculated quantile.
        """
        n = self.client.execute(f"select count(*) from {table_name}")[0][0]
        print(n)
        sub_query = f"select {column} from {table_name} where isFinite({column})"
        quantile = self.client.execute(f"select quantileExact({q})({column}) from ({sub_query})")[0][0]
        if style == "greater":
            query = f"select count(*) from ({sub_query}) where {column} > {quantile}"
        else:
            query = f"select count(*) from ({sub_query}) where {column} < {quantile}"
        k = self.client.execute(query)[0][0]
        return {"total": n, "count": k, "delta": k / n}

    def countLastDayRows(self, table_name: str, column: str, percent: float = 80) -> Dict[str, any]:
        """Check if number of values in last day is at least 'percent'% of the average.

        Calculate average number of rows per day in chosen date column.
        If number of rows in last day is at least 'percent' value of the average, then
        return True, else return False.
        """
        at_least = False

        query_last_day = f"select toDate({column}) as dt from {table_name} order by dt desc limit 1"
        last_day = self.client.execute(query_last_day)[0][0]
        subquery = f"select {column} from {table_name} where {column} != toDate('{last_day}')"

        n_rows_without_last = self.client.execute(f"select count(*) from ({subquery})")[0][0]
        n_days_without_last = self.client.execute(
            f"select countDistinct(toDate({column})) from ({subquery})")[0][0]
        average = n_rows_without_last / n_days_without_last

        last_date_count = self.client.execute(
            f"select count(*) from {table_name} where {column} = toDate('{last_day}')")[0][0]

        percentage = (last_date_count / average) * 100
        if percentage >= percent:
            at_least = True
        return {
            "average": average,
            "last_date_count": last_date_count,
            "percentage": percentage,
            f"at_least_{percent}%": at_least,
        }


def create_table(client, name, columns: str):
    client.execute(
        f"CREATE TABLE IF NOT EXISTS {name} ({columns}) ENGINE = Log;")


if __name__ == "__main__":
    base_params = {'host': 'localhost',
                   'port': '9000',
                   'user': 'user',
                   'password': 'password'}
    # client = Client(host='localhost',
    #                 port='9000',
    #                 user='user',
    #                 password='password', settings={'use_numpy': True})

    table_name = "TABLES1.big_table"
    metric = ClickhouseMetric(**base_params)
    # print(metric.countTotal(table_name))
    print(metric.countExtremeValuesQuantile(table_name, "revenue", 0.9, "greater"))
