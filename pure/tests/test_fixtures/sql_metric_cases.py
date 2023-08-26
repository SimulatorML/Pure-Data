"""Test cases."""
import datetime as dt

today = dt.datetime.now()
# Each metric can have multiple test cases with different tables,
# params and expected results.

# By defalut MSSQL and MySQL are case insestive, so for case sensitive checks -
# you need to change collation for whole database or target table.

TEST_CASES = {
    "CountTotal": [
        {
            "table_name": "sales",
            "params": [],
            "expected_result": {"total": 21},
        },
    ],
    "CountZeros": [
        {
            "table_name": "sales",
            "params": ["qty"],
            "expected_result": {"total": 21, "count": 2, "delta": 0.09523},
        },
    ],
    "CountNull": [
        {
            "table_name": "sales",
            "params": [["qty", "price"], "any"],
            "expected_result": {"total": 21, "count": 6, "delta": 0.28571},
        },
        {
            "table_name": "sales",
            "params": ["qty, price, ", "any"],
            "expected_result": {"total": 21, "count": 6, "delta": 0.28571},
        },
        {
            "table_name": "sales",
            "params": [["qty", "price"], "all"],
            "expected_result": {"total": 21, "count": 0, "delta": 0.0},
        },
        {
            "table_name": "sales",
            "params": ["  qty, price, ", "all"],
            "expected_result": {"total": 21, "count": 0, "delta": 0.0},
        },
        {
            "table_name": "sales",
            "params": [["price"], "all"],
            "expected_result": {"total": 21, "count": 0, "delta": 0.0},
        },
        {
            "table_name": "sales",
            "params": [["qty"], "all"],
            "expected_result": {"total": 21, "count": 6, "delta": 0.28571},
        },
    ],
    "CountDuplicates": [
        {
            "table_name": "sales",
            "params": [["item_id", "qty"]],
            "expected_result": {"total": 21, "count": 11, "delta": 0.523809},
        },
        {
            "table_name": "sales",
            "params": ["item_id  , qty, "],
            "expected_result": {"total": 21, "count": 11, "delta": 0.523809},
        },
    ],
    "CountUnique": [
        {
            "table_name": "sales",
            "params": [["item_id", "qty"]],
            "expected_result": {"total": 21, "count": 3, "delta": 0.142857},
        },
        {
            "table_name": "sales",
            "params": ["item_id  , qty, pay_card, , "],
            "expected_result": {"total": 21, "count": 19, "delta": 0.904761},
        },
    ],
    "CountValue": [
        {
            "table_name": "sales",
            "params": ["day", "2022-10-22"],
            "expected_result": {"total": 21, "count": 3, "delta": 0.14285},
        },
    ],
    "CountBelowValue": [
        {
            "table_name": "views",
            "params": ["views", 1000, True],
            "expected_result": {"total": 18, "count": 11, "delta": 0.61111},
        },
        {
            "table_name": "views",
            "params": ["views", 1000, False],
            "expected_result": {"total": 18, "count": 12, "delta": 0.66666},
        },
    ],
    "CountAboveValue": [
        {
            "table_name": "views",
            "params": ["views", 1000, True],
            "expected_result": {"total": 18, "count": 2, "delta": 0.11111},
        },
        {
            "table_name": "views",
            "params": ["views", 1000, False],
            "expected_result": {"total": 18, "count": 3, "delta": 0.16666},
        },
    ],
    "CountBelowColumn": [
        {
            "table_name": "sales",
            "params": ["qty", "price", False],
            "expected_result": {"total": 21, "count": 13, "delta": 0.6190476190476191},
        }
    ],
    "CountRatioBelow": [
        {
            "table_name": "sales",
            "params": ["qty", "price", "revenue", True],
            "expected_result": {"total": 21, "count": 11, "delta": 0.52381},
        },
        {
            "table_name": "sales",
            "params": ["qty", "price", "revenue", False],
            "expected_result": {"total": 21, "count": 13, "delta": 0.61905},
        },
    ],
    "CountCB": [
        {
            "table_name": "av_table_none",
            "params": ["qty", 0.95],
            "expected_result": {"lcb": 3, "ucb": 97},
        },
        {
            "table_name": "av_table_none",
            "params": ["revenue", 0.95],
            "expected_result": {"lcb": 122, "ucb": 980},
        },
        {
            "table_name": "av_table_none",
            "params": ["revenue", 0.8],
            "expected_result": {"lcb": 190.0, "ucb": 907.3999999999996},
        },
    ],
    "CountLag": [
        {
            "table_name": "sales",
            "params": ["day"],
            "expected_result": {
                "today": today.strftime("%Y-%m-%d"),
                "last_day": "2022-10-31",
                "lag": (today - dt.datetime(2022, 10, 31)).days,
            },
        },
        {
            "table_name": "views",
            "params": ["dt", "hour", today],
            "expected_result": {
                "today": today.strftime("%Y-%m-%d %H:%M"),
                "last_day": "2022-09-25 00:00",
                "lag": int((today - dt.datetime(2022, 9, 25)).total_seconds() / 3600),
            },
        },
    ],
    "CountValueInSet": [
        {
            "table_name": "sales",
            "params": ["pay_card", ["visa", "mastercard", "unionpay"]],
            "expected_result": {"total": 21, "count": 16, "delta": 0.76190},
        },
    ],
    "CountValueInBounds": [
        {
            "table_name": "sales",
            "params": ["qty", 1, 8, True],
            "expected_result": {"total": 21, "count": 10, "delta": 0.47619},
        },
        {
            "table_name": "sales",
            "params": ["qty", 1, 8, False],
            "expected_result": {"total": 21, "count": 13, "delta": 0.61905},
        },
    ],
    "CountExtremeValuesFormula": [
        {
            "table_name": "av_table_none",
            "params": ["revenue", 1.5, "greater"],
            "expected_result": {"total": 5000, "count": 346, "delta": 0.0692},
        },
        {
            "table_name": "av_table_none",
            "params": ["qty", 1.5, "lower"],
            "expected_result": {"total": 5000, "count": 289, "delta": 0.0578},
        }
    ],
    "CountExtremeValuesQuantile": [
        {
            "table_name": "views",
            "params": ["clicks", 0.9, "greater"],
            "expected_result": {"total": 18, "count": 2, "delta": 0.1111111111111111},
        },
        {
            "table_name": "av_table_none",
            "params": ["qty", 0.05, "lower"],
            "expected_result": {"total": 5000, "count": 243, "delta": 0.0486},
        },
        {
            "table_name": "av_table_none",
            "params": ["revenue", 0.9, "greater"],
            "expected_result": {"total": 5000, "count": 483, "delta": 0.0966},
        },
    ],
    "CountLastDayRowsPercent": [
        {
            "table_name": "sales",
            "params": ["day", 80],
            "expected_result": {
                "average": 2.85714,
                "last_date_count": 1,
                "percentage": 35.0,
                "at_least_80%": False,
            },
        },
        {
            "table_name": "sales",
            "params": ["day", 35],
            "expected_result": {
                "average": 2.85714,
                "last_date_count": 1,
                "percentage": 35.0,
                "at_least_35%": True,
            },
        },
        {
            "table_name": "views",
            "params": ["dt", 80],
            "expected_result": {
                "average": 3,
                "last_date_count": 6,
                "percentage": 200.0,
                "at_least_80%": True,
            },
        }
    ],
    "CountLastDayRows": [
        {
            "table_name": "sales",
            "params": ['day'],
            "expected_result": {'median': 3.0, 'last': 1.0, 'ratio': 0.3333333333333333}
        },
        {
            "table_name": "sales",
            "params": ['day', False],
            "expected_result": {'median': 3.0, 'last': 1.0, 'ratio': 0.3333333333333333}
        },
        {
            "table_name": "av_table_none",
            "params": ['index'],
            "expected_result": {'median': 23.5, 'last': 23.0, 'ratio': 0.9787234042553191}
        },
        {
            "table_name": "av_table_none",
            "params": ['index', False],
            "expected_result": {'median': 23.0, 'last': 24.0, 'ratio': 1.0434782608695652}
        },
    ],
    "CountFewLastDayRows": [
        {
            "table_name": "sales",
            "params": ["day", 80, 3],
            "expected_result": {"average": 3.2, "days": 1},
        },
        {
            "table_name": "sales",
            "params": ["day", 30, 3],
            "expected_result": {"average": 3.2, "days": 3},
        },
        {
            "table_name": "views",
            "params": ["dt", 80, 2],
            "expected_result": {"average": 3, "days": 2},
        }
    ],
    "CountLastDayAvg": [
        {
            "table_name": "sales",
            "params": ['qty', 'day'],
            "expected_result": {'median': 3.458333333333333, 'last': 8.0, 'ratio': 2.313253012048193}
        },
        {
            "table_name": "sales",
            "params": ['qty', 'day', False],
            "expected_result": {'median': 3.6666666666666665, 'last': 1.0, 'ratio': 0.27272727272727276}
        },
        {
            "table_name": "sales",
            "params": ['revenue', 'day'],
            "expected_result": {'median': 533.3333333333333, 'last': 160.0, 'ratio': 0.30000000000000004}
        },
        {
            "table_name": "sales",
            "params": ['revenue', 'day', False],
            "expected_result": {'median': 526.6666666666666, 'last': 1000.0, 'ratio': 1.89873417721519}
        },
        {
            "table_name": "av_table_none",
            "params": ['qty', 'index'],
            "expected_result": {'median': 49.95969498910675, 'last': 50.30434782608695, 'ratio': 1.0068986177168486}
        },
        {
            "table_name": "av_table_none",
            "params": ['qty', 'index', False],
            "expected_result": {'median': 50.03703703703704, 'last': 48.5, 'ratio': 0.9692820133234641}
        },
        {
            "table_name": "av_table_none",
            "params": ['revenue', 'index'],
            "expected_result": {'median': 550.6508563899868, 'last': 427.2173913043478, 'ratio': 0.7758407824971767}
        },
        {
            "table_name": "av_table_none",
            "params": ['revenue', 'index', False],
            "expected_result": {'median': 550.6060606060606, 'last': 605.0833333333334, 'ratio': 1.0989405613648873}
        },
    ],
    "CheckAdversarialValidation": [
        {
            "table_name": "av_table_none",
            "params": [
                (dt.date(2022, 4, 17), dt.date(2022, 5, 3)),
                (dt.date(2022, 5, 3), dt.date(2022, 5, 17)),
                0.05,
            ],
            "expected_result": {
                "similar": False,
                "importances": {"revenue": 0.70781, "qty": 0.29219},
                "cv_roc_auc": 0.70727,
            },
        },
    ],
}
