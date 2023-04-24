import numpy as np
from test_fixtures.testcases import TEST_CASES

from pure import metrics


def test_metrics_pandas():
    """Test pandas engine metrics."""

    for metric_name, test_cases in TEST_CASES.items():
        for case in test_cases:

            tables_set = case["tables_set"]
            table_name = case["table_name"]
            params = case["params"]
            expected_result = case["expected_result"]

            table = tables_set[table_name].copy()
            metric_result = getattr(metrics, metric_name)(*params)(table)

            msg = (
                f"Metric '{metric_name}' should "
                "return Dict[str, Any[float, int, str]]"
            )
            assert isinstance(metric_result, dict), msg

            msg = (
                f"Metric {metric_name} returns wrong value."
                f" Yours value: {metric_result}. Valid value: {expected_result}"
            )
            for key, value in metric_result.items():
                assert np.isclose(value, expected_result[key], rtol=1e-04), msg
