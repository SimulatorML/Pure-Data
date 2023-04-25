"""Test cases."""
from test_fixtures.tables import TABLES1
from test_fixtures.report_checklists import CHECKLIST1



TEST_CASES = [
    {
        "tables_set": TABLES1,
        "checklist": CHECKLIST1,
        "expected_result_dump_file": "test_fixtures/report_dumps/dump1.pkl",
    },
]
