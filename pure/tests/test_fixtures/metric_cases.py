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
}
