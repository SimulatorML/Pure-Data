import os
import pickle

import pandas as pd
from test_fixtures.report_cases import TEST_CASES as report_cases

from pure.report import Report


def test_report_pandas():
    """Test Report. Pandas version.

    Check on simple examples that Report returns result equal to the expected one.
    """

    dir = os.path.abspath(os.path.dirname(__file__))
    dumps_path = os.path.join(dir, "test_fixtures", "report_dumps")

    for case in report_cases:
        tables_set = case["tables_set"]
        checklist = case["checklist"]
        dump_file = os.path.join(dumps_path, case["expected_result_dump_file"])

        expected_result = pickle.load(open(dump_file, "rb"))
        result = Report(checklist).fit(tables_set)
        correct_order = [
            (row[0], row[1]) for index, row in expected_result["result"].iterrows()
        ]
        result_order = [
            (row[1]["table_name"], row[1]["metric_name"])
            for row in result["result"].iterrows()
        ]

        # order in report and order in checklist should match
        assert correct_order == result_order
        assert_report_equals(result["result"], expected_result["result"])

        keys_to_check = list(result.keys())
        keys_to_check.remove("result")
        for key in keys_to_check:
            # check that values in report (except metric results) are equal
            assert expected_result[key] == result[key]


def assert_report_equals(user_report: pd.DataFrame, valid_report: pd.DataFrame) -> None:
    """Check that user's report equals valid report.
    For float metric's values checks non-strict equality within error

    Parameters
    ----------
    user_report: pd.DataFrame :
        User's report

    valid_report: pd.DataFrame :
        Valid report

    Returns
    -------

    """

    # shapes of report should be the same
    assert user_report.shape == valid_report.shape

    for (_, user), (_, valid) in zip(user_report.iterrows(), valid_report.iterrows()):
        # keys (columns in report) are expected to match
        assert set(user.keys()) == set(valid.keys())
        # check that metric result values in report are equal
        for key in valid.keys():
            if key == "metric_values":
                assert metric_results_are_equal(user[key], valid[key])
                continue
            assert user[key] == valid[key]


def metric_results_are_equal(
    user_result: dict, valid_result: dict, error_rate: float = 0.01
) -> bool:
    """Check that user's result equals valid result.
    For float values checks non-strict equality within error

    Parameters
    ----------
    user_result : dict :
        User metric's result
    valid_result : dict :
        Valid result
    error_rate : float
        Allowable error (Default value = 0.01)

    Returns
    -------
    bool:
        True if results are equal
    """
    if set(user_result.keys()) != set(valid_result.keys()):
        return False

    for key, value in valid_result.items():
        user_value = user_result[key]
        if isinstance(value, float) and value != 0:
            if abs(value - user_value) / value > error_rate:
                return False
        elif value != user_value:
            return False

    return True
