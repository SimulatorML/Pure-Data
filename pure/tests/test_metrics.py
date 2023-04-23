from pure import metrics


from typing import Dict

import pandas as pd

from test_fixtures.testcases import METRIC_TESTCASES
from test_fixtures.tables import TABLES1
from test_fixtures.tables import TABLES2


test_fixtures = {"fixture1": TABLES1, "fixture2": TABLES2}


def get_checked_tables(fixture: str) -> Dict[str, pd.DataFrame]:
    """Copy to avoid changing the original fixture."""
    new_fixture = {}
    for table_name, table in test_fixtures[fixture].items():
        new_fixture[table_name] = table.copy()
    return new_fixture


def run_test_metric_pandas(metric: str, fixture: str) -> int:
    """Check metric.
    Engine: pandas.

    Parameters
    ----------
    metric : str :
        Name of checking metric.
    fixture : str :
        Name of fixture.

    Returns
    -------
    int:
        1 if success, otherwise exception
    """


    cases = METRIC_TESTCASES[metric]
    checked_tables = get_checked_tables(fixture)
    for case in cases:
        table_df = checked_tables[case["table"]]
        metric_func = getattr(metrics, metric)

        metric_result = metric_func(*case["params"])(table_df)

        msg = (
            f"Metric '{metric_func.__name__}' should "
            "return Dict[str, Any[float, int, str]]"
        )
        assert isinstance(metric_result, dict), msg

        print(1)
        print (metric_result)

        # msg = (
        #     f"Metric {user_metric.__name__} returns wrong value."
        #     f" Yours value: {user_result}. Valid value: {valid_result}"
        # )

        

def test_pandas_count_total():
    """Test CountTotal metric (pandas engine)."""
    run_test_metric_pandas("CountTotal", "fixture1")
    

def test_pandas_count_zeros():
    """Test CountZeros metric (pandas engine)."""
    run_test_metric_pandas("CountZeros", "fixture1")



        # (0, xtest_metric_pandas, dict(fixture="fixture1", metric="CountTotal")),
        # (0, xtest_metric_pandas, dict(fixture="fixture1", metric="CountZeros")),