"""Test cases."""
from .report_checklists import CHECKLIST1, CHECKLIST2
from .tables import TABLES1, TABLES2

TEST_CASES = [
    # {
    #     "tables_set": TABLES1,
    #     "checklist": CHECKLIST1,
    #     "expected_result_dump_file": "dump1.pkl",
    # },
    {
        "tables_set": TABLES2,
        "checklist": CHECKLIST2,
        "expected_result_dump_file": "dump2.pkl",
    },
]
