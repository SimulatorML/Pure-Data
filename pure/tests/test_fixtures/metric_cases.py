"""Test cases."""
from test_fixtures.tables import TABLES1, TABLES2

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
    "CountRatioBelow": [],
    "CountCB": [],
    "CountLag": [],
    "CountValueInRequiredSet": [],
    "CountValueOutOfBounds": [],
    "CountExtremeValuesFormula": [],
    "CountExtremeValuesQuantile": [],
    "CountLastDayRows": [],
    "CountFewLastDayRows": [],

}
