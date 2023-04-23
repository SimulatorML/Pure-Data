from pure import metrics


import pandas as pd
import numpy as np


from test_fixtures.tables import TABLES1
from test_fixtures.tables import TABLES2


def test_pandas_count_total():
    """Test CountTotal metric (pandas engine)."""

    # TABLE1

    table = TABLES1["sales"].copy()
    metric_result = metrics.CountTotal()(table)

    msg = (
        f"Metric 'CountTotal' should "
        "return Dict[str, Any[float, int, str]]"
    )
    assert isinstance(metric_result, dict), msg

    expected_result = {'total': 7}
    msg = (
        f"Metric {metrics.CountTotal.__name__} returns wrong value."
        f" Yours value: {metric_result}. Valid value: {expected_result}"
    )
    assert metric_result == expected_result, msg


    # TABLE2

    table = TABLES2["sales"].copy()
    metric_result = metrics.CountTotal()(table)

    expected_result = {'total': 21}
    msg = (
        f"Metric {metrics.CountTotal.__name__} returns wrong value."
        f" Yours value: {metric_result}. Valid value: {expected_result}"
    )
    assert metric_result == expected_result, msg

    

def test_pandas_count_zeros():
    """Test CountZeros metric (pandas engine)."""
    
    # TABLE1

    table = TABLES1["sales"].copy()
    metric_result = metrics.CountZeros("qty")(table)

    expected_result = {'total': 7, 'count': 1, 'delta': 0.14285}
    msg = (
        f"Metric {metrics.CountZeros.__name__} returns wrong value."
        f" Yours value: {metric_result}. Valid value: {expected_result}"
    )
    for key, value in metric_result.items():
        assert np.isclose(value, expected_result[key], rtol=1e-04), msg

    # TABLE2

    table = TABLES2["sales"].copy()
    metric_result = metrics.CountZeros("qty")(table)

    expected_result = {'total': 21, 'count': 2, 'delta': 0.09523}
    msg = (
        f"Metric {metrics.CountZeros.__name__} returns wrong value."
        f" Yours value: {metric_result}. Valid value: {expected_result}"
    )
    
    for key, value in metric_result.items():
        assert np.isclose(value, expected_result[key], rtol=1e-04), msg
