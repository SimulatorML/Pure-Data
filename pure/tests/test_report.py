import numpy as np
from test_fixtures.metric_cases import TEST_CASES as metric_cases
from test_fixtures.report_checklist import CHECKLIST as checklist
from test_fixtures.tables import TABLES1, TABLES2

from pure.report import Report


def test_report_pandas():

    checked_tables = TABLES1


    result = Report(checklist).fit(checked_tables)

    # correct_order = [(row[0], str(row[1])) for row in USER_CHECKLIST]
    # user_order = [
    #     (row[1]["table_name"], row[1]["metric"])
    #     for row in user_result["result"].iterrows()
    # ]

    # msg = (
    #     "Wrong order of metrics in result. "
    #     "Order should be the same as in checklist. "
    #     f"Expected order: {correct_order}. "
    #     f"Yours order: {user_order}."
    # )
    # assert correct_order == user_order, msg

    # assert_report_equals(user_result["result"], valid_result["result"])

    # keys_to_check = list(valid_result.keys())
    # keys_to_check.remove("result")
    # for key in keys_to_check:
    #     msg = (
    #         "Method fit() return wrong result. "
    #         f'For key "{key}" expected value: {valid_result[key]}. '
    #         f"Yours value: {user_result[key]}"
    #     )
    #     assert user_result[key] == valid_result[key], msg

    # return 1


