import numpy as np
from test_fixtures.metric_cases import TEST_CASES as metric_cases
from test_fixtures.report_checklist import CHECKLIST as checklist
from test_fixtures.tables import TABLES1, TABLES2

from pure.report import Report

import pandas as pd


def test_report_pandas():

    checked_tables = TABLES1


    result = Report(checklist).fit(checked_tables)


    correct_order = [(row[0], str(row[1])) for row in checklist]
    result_order = [
        (row[1]["table_name"], row[1]["metric"])
        for row in result["result"].iterrows()
    ]

    msg = (
        "Wrong order of metrics in result. "
        "Order should be the same as in checklist. "
        f"Expected order: {correct_order}. "
        f"Yours order: {result_order}."
    )
    assert correct_order == result_order, msg


    assert_report_equals(result["result"], result["result"])

    keys_to_check = list(result.keys())
    keys_to_check.remove("result")
    for key in keys_to_check:
        msg = (
            "Method fit() return wrong result. "
            f'For key "{key}" expected value: {result[key]}. '
            f"Yours value: {result[key]}"
        )
        assert result[key] == result[key], msg



def assert_report_equals(
    user_report: pd.DataFrame, valid_report: pd.DataFrame
) -> None:
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

    msg = (
        "Shapes of yours report dataframe is wrong. "
        f"Yours shape: {user_report.shape} Valid shape: {valid_report.shape}"
    )
    assert user_report.shape == valid_report.shape, msg

    for (_, user), (_, valid) in zip(
        user_report.iterrows(), valid_report.iterrows()
    ):

        msg = (
            "Reports's structure is wrong. Report should contain columns: "
            f"{list(valid.keys())} Yours columns: {list(user.keys())}"
        )
        assert set(user.keys()) == set(valid.keys()), msg

        msg = f"Reports's line is wrong. Expected: {valid}. Got: {user}"
        for key in valid.keys():
            if key == "values":
                assert metric_results_are_equal(user[key], valid[key]), msg
                continue

            assert user[key] == valid[key], msg


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