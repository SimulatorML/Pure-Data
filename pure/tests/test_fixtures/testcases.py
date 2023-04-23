"""Test cases."""
METRIC_TESTCASES = {
    "CountTotal": [{"table": "sales", "params": []}],
    "CountZeros": [{"table": "sales", "params": ["qty"]}],
    "CountNull": [
        {"table": "sales", "params": [["qty", "price"], "any"]},
        {"table": "sales", "params": [["qty", "price"], "all"]},
    ],
    "CountDuplicates": [{"table": "sales", "params": [["day", "item_id"]]}],
    "CountValue": [{"table": "sales", "params": ["qty", 1]}],
    "CountBelowValue": [{"table": "sales", "params": ["price", 100]}],
    "CountBelowColumn": [{"table": "views", "params": ["clicks", "views"]}],
    "CountRatioBelow": [{"table": "sales", "params": ["revenue", "price", "qty"]}],
    "CountCB": [{"table": "big_table", "params": ["revenue"]}],
    "CountLag": [{"table": "sales", "params": ["day"]}],
}
