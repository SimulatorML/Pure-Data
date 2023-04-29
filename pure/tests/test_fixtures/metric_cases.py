"""Test cases."""
from test_fixtures.tables import TABLES1, TABLES2
import datetime as dt

today = dt.datetime.now()
# Each metric can have multiple test cases with different tables,
# params and expected results.
TEST_CASES = {
    "CountTotal": [
        {
            "tables_set": TABLES1,
            "table_name": "sales",
            "params": [],
            "expected_result": {"total": 7},
        },
        {
            "tables_set": TABLES2,
            "table_name": "sales",
            "params": [],
            "expected_result": {"total": 21},
        },
    ],
    "CountZeros": [
        {
            "tables_set": TABLES1,
            "table_name": "sales",
            "params": ["qty"],
            "expected_result": {"total": 7, "count": 1, "delta": 0.14285},
        },
        {
            "tables_set": TABLES2,
            "table_name": "sales",
            "params": ["qty"],
            "expected_result": {"total": 21, "count": 2, "delta": 0.09523},
        },
    ],
    "CountNull": [
        {
            "tables_set": TABLES1,
            "table_name": "sales",
            "params": [["qty"], 'any'],
            "expected_result": {"total": 7, "count": 2, "delta": 0.285714},
        },
        {
            "tables_set": TABLES2,
            "table_name": "sales",
            "params": [["qty", "price"], 'any'],
            "expected_result": {"total": 21, "count": 6, "delta": 0.28571},
        },
        {
            "tables_set": TABLES1,
            "table_name": "sales",
            "params": [["qty", "price"], 'all'],
            "expected_result": {"total": 7, "count": 1, "delta": 0.142857},
        },
        {
            "tables_set": TABLES2,
            "table_name": "sales",
            "params": [["qty", "price"], 'all'],
            "expected_result": {"total": 21, "count": 0, "delta": 0.0},
        },
        {
            "tables_set": TABLES2,
            "table_name": "sales",
            "params": [["price"], 'all'],
            "expected_result": {"total": 21, "count": 0, "delta": 0.0},
        },
        {
            "tables_set": TABLES2,
            "table_name": "sales",
            "params": [["qty"], 'all'],
            "expected_result": {"total": 21, "count": 6, "delta": 0.28571},
        },
    ],
    "CountDuplicates": [
        {
            "tables_set": TABLES1,
            "table_name": "sales",
            "params": [["item_id", "qty"]],
            "expected_result": {"total": 7, "count": 1, "delta": 0.14285},
        },
        {
            "tables_set": TABLES2,
            "table_name": "sales",
            "params": [["item_id", "qty"]],
            "expected_result": {"total": 21, "count": 11, "delta": 0.523809},
        },
    ],
    "CountValue": [
        {
            "tables_set": TABLES1,
            "table_name": "views",
            "params": ["item_id", 100],
            "expected_result": {"total": 9, "count": 3, "delta": 0.33333},
        },
        {
            "tables_set": TABLES2,
            "table_name": "sales",
            "params": ["day", "2022-10-22"],
            "expected_result": {"total": 21, "count": 3, "delta": 0.14285},
        }
    ],
    "CountBelowValue": [
        {
            "tables_set": TABLES1,
            "table_name": "views",
            "params": ["views", 1000, True],
            "expected_result": {"total": 9, "count": 4, "delta": 0.44444},
        },
        {
            "tables_set": TABLES1,
            "table_name": "views",
            "params": ["views", 1000, False],
            "expected_result": {"total": 9, "count": 5, "delta": 0.55555},
        },
        {
            "tables_set": TABLES2,
            "table_name": "views",
            "params": ["views", 1000, True],
            "expected_result": {"total": 18, "count": 11, "delta": 0.61111},
        },
        {
            "tables_set": TABLES2,
            "table_name": "views",
            "params": ["views", 1000, False],
            "expected_result": {"total": 18, "count": 12, "delta": 0.66666},
        },
    ],
    "CountGreaterValue": [
        {
            "tables_set": TABLES1,
            "table_name": "views",
            "params": ["views", 1000, True],
            "expected_result": {"total": 9, "count": 4, "delta": 0.44444},
        },
        {
            "tables_set": TABLES1,
            "table_name": "views",
            "params": ["views", 1000, False],
            "expected_result": {"total": 9, "count": 5, "delta": 0.55555},
        },
        {
            "tables_set": TABLES2,
            "table_name": "views",
            "params": ["views", 1000, True],
            "expected_result": {"total": 18, "count": 2, "delta": 0.11111},
        },
        {
            "tables_set": TABLES2,
            "table_name": "views",
            "params": ["views", 1000, False],
            "expected_result": {"total": 18, "count": 3, "delta": 0.16666},
        },
    ],
    "CountBelowColumn": [
        {
            "tables_set": TABLES1,
            "table_name": "views",
            "params": ["clicks", "views", False],
            "expected_result": {"total": 9, "count": 9, "delta": 1},
        },
        {
            "tables_set": TABLES1,
            "table_name": "views",
            "params": ["clicks", "views", True],
            "expected_result": {"total": 9, "count": 8, "delta": 0.88888},
        },
        {
            "tables_set": TABLES1,
            "table_name": "sales",
            "params": ["price", "revenue", True],
            "expected_result": {"total": 7, "count": 5, "delta": 0.71428},
        },
    ],
    "CountRatioBelow": [
        {
            "tables_set": TABLES1,
            "table_name": "sales",
            "params": ["qty", "price", "revenue", True],
            "expected_result": {"total": 7, "count": 4, "delta": 0.57143},
        },
        {
            "tables_set": TABLES1,
            "table_name": "sales",
            "params": ["qty", "price", "revenue", False],
            "expected_result": {"total": 7, "count": 5, "delta": 0.71429},
        },
        {
            "tables_set": TABLES2,
            "table_name": "sales",
            "params": ["qty", "price", "revenue", True],
            "expected_result": {"total": 21, "count": 11, "delta": 0.52381},
        },
        {
            "tables_set": TABLES2,
            "table_name": "sales",
            "params": ["qty", "price", "revenue", False],
            "expected_result": {"total": 21, "count": 13, "delta": 0.61905},
        },
    ],
    "CountCB": [
        {
            "tables_set": TABLES1,
            "table_name": "sales",
            "params": ["qty", 0.95],
            "expected_result": {"lcb": 0.2, "ucb": 9.8},
        },
        {
            "tables_set": TABLES1,
            "table_name": "sales",
            "params": ["price", 0.95],
            "expected_result": {"lcb": 85.625, "ucb": 200.0},
        },
    ],
    "CountLag": [
        {
            "tables_set": TABLES2,
            "table_name": "sales",
            "params": ["day", "%Y-%m-%d"],
            "expected_result": {"today": today.strftime("%Y-%m-%d"), "last_day": "2022-10-31",
                                "lag": (today - dt.datetime(2022, 10, 31)).days},
        },
        {
            "tables_set": TABLES2,
            "table_name": "views",
            "params": ["dt", "%Y-%m-%d"],
            "expected_result": {"today": today.strftime("%Y-%m-%d"), "last_day": "2022-09-25",
                                "lag": (today - dt.datetime(2022, 9, 25)).days},
        },
    ],
    "CountValueInRequiredSet": [
        {
            "tables_set": TABLES1,
            "table_name": "sales",
            "params": ["pay_card", {"visa", "mastercard"}],
            "expected_result": {"total": 7, "count": 4, "delta": 4 / 7},
        },
        {
            "tables_set": TABLES2,
            "table_name": "sales",
            "params": ["pay_card", {"visa", "mastercard", "мир"}],
            "expected_result": {"total": 21, "count": 16, "delta": 16 / 21},
        },
    ],
    "CountValueInBounds": [
        {
            "tables_set": TABLES1,
            "table_name": "sales",
            "params": ['qty', 1, 8, True],
            "expected_result": {"total": 7, "count": 2, "delta": 0.28571},
        },
        {
            "tables_set": TABLES1,
            "table_name": "sales",
            "params": ['qty', 1, 8, False],
            "expected_result": {"total": 7, "count": 3, "delta": 0.42857},
        },
        {
            "tables_set": TABLES2,
            "table_name": "sales",
            "params": ['qty', 1, 8, True],
            "expected_result": {"total": 21, "count": 10, "delta": 0.47619},
        },
        {
            "tables_set": TABLES2,
            "table_name": "sales",
            "params": ['qty', 1, 8, False],
            "expected_result": {"total": 21, "count": 13, "delta": 0.61905},
        },
    ],
    "CountExtremeValuesFormula": [
        {
            "tables_set": TABLES1,
            "table_name": "views",
            "params": ['views', 1, 'greater'],
            "expected_result": {"total": 9, "count": 1, "delta": 0.11111},
        },
        {
            "tables_set": TABLES1,
            "table_name": "views",
            "params": ['views', 1, 'lower'],
            "expected_result": {"total": 9, "count": 1, "delta": 0.11111},
        },
        {
            "tables_set": TABLES1,
            "table_name": "sales",
            "params": ['qty', 1, 'greater'],
            "expected_result": {"total": 7, "count": 1, "delta": 0.14286},
        },
        {
            "tables_set": TABLES1,
            "table_name": "sales",
            "params": ['qty', 1, 'lower'],
            "expected_result": {"total": 7, "count": 1, "delta": 0.14286},
        },
    ],
    "CountExtremeValuesQuantile": [
        {
            "tables_set": TABLES2,
            "table_name": "sales",
            "params": ["qty", 0.8, 'greater'],
            "expected_result": {"total": 21, "count": 2, "delta": 0.09524},
        },
        {
            "tables_set": TABLES2,
            "table_name": "sales",
            "params": ["qty", 0.2, 'lower'],
            "expected_result": {"total": 21, "count": 3, "delta": 0.14286},
        },
        {
            "tables_set": TABLES1,
            "table_name": "sales",
            "params": ["qty", 0.8, 'greater'],
            "expected_result": {"total": 7, "count": 1, "delta": 0.14286},
        },
        {
            "tables_set": TABLES1,
            "table_name": "sales",
            "params": ["qty", 0.2, 'lower'],
            "expected_result": {"total": 7, "count": 1, "delta": 0.14286},
        },
    ],
    "CountLastDayRows": [
        {
            "tables_set": TABLES2,
            "table_name": "sales",
            "params": ["day", 80],
            "expected_result": {'average': 2.85714, 'last_date_count': 1, 'percentage': 35.0,
                                'at_least_80%': False},
        },
        {
            "tables_set": TABLES2,
            "table_name": "sales",
            "params": ["day", 35],
            "expected_result": {'average': 2.85714, 'last_date_count': 1, 'percentage': 35.0,
                                'at_least_35%': True},
        },
        {
            "tables_set": TABLES2,
            "table_name": "views",
            "params": ["dt", 80],
            "expected_result": {'average': 3, 'last_date_count': 6, 'percentage': 200.0,
                                'at_least_80%': True},
        },
        {
            "tables_set": TABLES1,
            "table_name": "two_years",
            "params": ["dt", 80],
            "expected_result": {'average': 1.5, 'last_date_count': 3, 'percentage': 200.0,
                                'at_least_80%': True},
        },
    ],
    "CountFewLastDayRows": [
        {
            "tables_set": TABLES2,
            "table_name": "sales",
            "params": ["day", 80, 3],
            "expected_result": {'average': 3.2, 'days': 1}
        },
        {
            "tables_set": TABLES2,
            "table_name": "sales",
            "params": ["day", 30, 3],
            "expected_result": {'average': 3.2, 'days': 3}
        },
        {
            "tables_set": TABLES2,
            "table_name": "views",
            "params": ["dt", 80, 2],
            "expected_result": {'average': 3, 'days': 2},
        },
        {
            "tables_set": TABLES1,
            "table_name": "two_years",
            "params": ["dt", 80, 2],
            "expected_result": {'average': 1.33333, 'days': 2},
        },
    ],
    "CheckAdversarialValidation":[
        # TODO: add cases
    ]
}
