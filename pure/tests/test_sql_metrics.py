'''
To run tests, you need to set up access to the corresponding databases
and they must contain the following tables: `views`, `sales`, `av_table_none`.

Meta-data and contents of these tables can be found here:
`/pure/tests/test_fixtures/tables.sql`

Note: By default, MSSQL and MySQL are case-insensitive, so for case-sensitive checks -
you need to change the collation for the whole database or target tables.
'''
import numbers

import numpy as np
import pure.tests.test_fixtures.sql_metric_cases as metric_cases
from pure import metrics
import pure.sql_connector as conn


def test_metrics_clickhouse():
    """Test metrics for Clickhouse database."""
    ch_connector = conn.ClickHouseConnector(
        host='localhost',
        port=9000,
        user='default',
        password='***'
    )

    for metric_name in metric_cases.TEST_CASES.keys():
        run_one_sql_test(metric_name, ch_connector)


def test_metrics_postgresql():
    """Test metrics for PostgreSQL database."""
    pg_connector = conn.PostgreSQLConnector(
        host='localhost',
        database='***',
        port=5432,
        user='default',
        password='***'
    )

    for metric_name in metric_cases.TEST_CASES.keys():
        run_one_sql_test(metric_name, pg_connector)


def test_metrics_mssql():
    """Test metrics for MSSQL database."""
    ms_connector = conn.MSSQLConnector(
        host='localhost',
        database='***',
        port=1433,
        user='default',
        password='***'
    )

    for metric_name in metric_cases.TEST_CASES.keys():
        run_one_sql_test(metric_name, ms_connector)


def test_metrics_mysql():
    """Test metrics for MySQL database."""
    my_connector = conn.MySQLConnector(
        host="localhost",
        user="default",
        password="***",
        database="***",
        port=3306
    )

    for metric_name in metric_cases.TEST_CASES.keys():
        run_one_sql_test(metric_name, my_connector)


def run_one_sql_test(metric_name: str, sql_connector: conn.SQLConnector):
    """Test one metric for specified database connector."""
    test_cases = metric_cases.TEST_CASES[metric_name]
    for i, case in enumerate(test_cases):
        table_name = case["table_name"]
        params = case["params"]
        expected_result = case["expected_result"]
        metric_instance = getattr(metrics, metric_name)(*params)
        metric_result = metric_instance(df=table_name, engine=sql_connector.engine, sql_connector=sql_connector)

        msg = f"Metric '{metric_name}' should " "return Dict[str, Any[float, int, str]]"
        assert isinstance(metric_result, dict), msg

        msg = (
            f"DB engine: {sql_connector.engine}."
            f" Metric {metric_name} returns wrong value in case №{i + 1}."
            f" Yours value: {metric_result}. Valid value: {expected_result}"
        )
        for key, value in metric_result.items():
            if isinstance(expected_result[key], numbers.Number):
                assert np.isclose(value, expected_result[key], rtol=1e-04), msg
            else:
                assert value == expected_result[key], msg
