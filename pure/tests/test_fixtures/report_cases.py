"""Test cases."""
from test_fixtures.report_checklists import CHECKLIST1
from test_fixtures.tables import TABLES1

TEST_CASES = [
    {
        "tables_set": TABLES1,
        "checklist": CHECKLIST1,
        "expected_result_dump_file": "dump1.pkl",
    },
]
