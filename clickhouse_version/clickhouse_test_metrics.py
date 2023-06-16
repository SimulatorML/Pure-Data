from typing import List
import numpy as np
from clickhouse_metric_cases import TEST_CASES as metric_cases

from clickhouse_metrics import ClickhouseMetric
import numbers


def test_metrics_clickhouse():
    """Test clickhouse engine metrics."""
    for metric_name in metric_cases.keys():
        run_one_clickhouse_test(metric_name)


def test_list_of_metrics_clickhouse():
    metric_names = ["countTotal", "countZeros", "countDuplicates", "countValue", "countBelowValue", "countNull",
                    "countRatioBelow", "countBelowColumn", "countGreaterValue", "countCB", "countLag",
                    "countValueInRequiredSet", "countValueInBounds", "countExtremeValuesFormula", "countExtremeValuesQuantile", "countLastDayRows"]
    # metric_names = ["countLag"]
    for metric_name in metric_names:
        run_one_clickhouse_test(metric_name)


def run_one_clickhouse_test(metric_name):
    """Test one clickhouse engine metric."""
    test_cases = metric_cases[metric_name]
    base_params = {'host': 'localhost',
                   'port': '9000',
                   'user': 'user',
                   'password': 'password'}
    print("")
    for i, case in enumerate(test_cases):
        print(metric_name, case)
        tables_set = str(case["tables_set"])
        table_name = case["table_name"]
        params = case["params"]
        expected_result = case["expected_result"]
        metric = ClickhouseMetric(**base_params)
        full_table_name = '.'.join([tables_set, table_name])
        metric_result = getattr(metric, metric_name)(full_table_name, *params)

        msg = (
            f"Metric '{metric_name}' should "
            "return Dict[str, Any[float, int, str]]"
        )
        assert isinstance(metric_result, dict), msg

        msg = ("Engine: clickhouse."
               f" Metric {metric_name} returns wrong value in case №{i + 1}."
               f" Yours value: {metric_result}. Valid value: {expected_result}"
               )
        for key, value in metric_result.items():
            if isinstance(expected_result[key], numbers.Number):
                assert np.isclose(value, expected_result[key], rtol=1e-04), msg
            else:
                assert value == expected_result[key], msg
