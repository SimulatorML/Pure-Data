from typing import Any, Dict, Union, List
from clickhouse_driver import Client


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
        n = self.client.execute(f"select count(*) from {table_name}")[0][0]
        return {"total": n}

    def countZeros(self, table_name: str, column: str) -> Dict[str, Any]:
        n = self.client.execute(f"select count(*) from {table_name}")[0][0]
        k = self.client.execute(f"select countIf({column} = 0) from {table_name}")[0][0]
        return {"total": n, "count": k, "delta": k / n}

    def countNull(self, table_name: str, columns: List[str], aggregation: str = "any") -> Dict[str, Any]:
        # for now only check nan values and in 'all' mode
        n = self.client.execute(f"select count(*) from {table_name}")[0][0]
        if aggregation == "all":
            columns_is_null = ') AND ('.join(f'isNaN({col})' for col in columns)
            query = f"select countIf(({columns_is_null})) FROM {table_name} WHERE ({columns_is_null})"
            k = self.client.execute(query)[0][0]
        else:
            ...
        return {"total": n, "count": k, "delta": k / n}

    def countDuplicates(self) -> Dict[str, Any]:
        return {"total": n, "count": k, "delta": k / n}

    def countValue(self) -> Dict[str, Any]:
        return {"total": n, "count": k, "delta": k / n}

    def countBelowValue(self) -> Dict[str, Any]:
        return {"total": n, "count": k, "delta": k / n}

    def countBelowColumn(self) -> Dict[str, Any]:
        return {"total": n, "count": k, "delta": k / n}

    def countRatioBelow(self) -> Dict[str, Any]:
        return {"total": n, "count": k, "delta": k / n}


if __name__ == "__main__":
    base_params = {'host': 'localhost',
                   'port': '9000',
                   'user': 'user',
                   'password': 'password'}
    table_name = "db1.sales_table"
    metric = ClickhouseMetric(**base_params)
    print(metric.countTotal(table_name))
    print(metric.countZeros(table_name, "qty"))
    print(metric.countNull(table_name, columns=["qty", "price"], aggregation='any'))
