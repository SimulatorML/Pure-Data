"""User's and valid report checklists."""

from solutions import metrics as valid
from user_input import metrics as user

# Checklist contains checks consist of:
# - table_name
# - metric
# - limits

VALID_CHECKLIST = [
    # Table with sales ["day", "item_id", "qty", "revenue", "price"]
    ("sales", valid.CountTotal(), {"total": (1, 1e6)}),
    ("sales", valid.CountLag("day"), {"lag": (0, 3)}),
    ("sales", valid.CountDuplicates(["day", "item_id"]), {"total": (0, 0)}),
    ("sales", valid.CountNull(["qty"]), {"total": (0, 0)}),
    (
        "sales",
        valid.CountRatioBelow("revenue", "price", "qty", False),
        {"delta": (0, 0.05)},
    ),
    ("big_table", valid.CountCB("revenue"), {}),
    ("sales", valid.CountZeros("qty"), {"delta": (0, 0.3)}),
    ("sales", valid.CountBelowValue("price", 100.0), {"delta": (0, 0.3)}),
    # Table with clickstream ["dt", "item_id", "views", "clicks", "payments"]
    ("views", valid.CountTotal(), {"total": (1, 1e6)}),
    ("views", valid.CountLag("dt"), {"lag": (0, 3)}),
    ("views", valid.CountZeros("views"), {"delta": (0, 0.2)}),
    ("views", valid.CountZeros("clicks"), {"delta": (0, 0.5)}),
    ("views", valid.CountNull(["views", "clicks", "payments"]), {"delta": (0, 0.1)}),
    ("views", valid.CountBelowValue("views", 10), {"delta": (0, 0.5)}),
    ("views", valid.CountBelowColumn("clicks", "views"), {"total": (0, 0)}),
    ("views", valid.CountBelowColumn("payments", "clicks"), {"total": (0, 0)}),
]

USER_CHECKLIST = [
    # Table with sales ["day", "item_id", "qty", "revenue", "price"]
    ("sales", user.CountTotal(), {"total": (1, 1e6)}),
    ("sales", user.CountLag("day"), {"lag": (0, 3)}),
    ("sales", user.CountDuplicates(["day", "item_id"]), {"total": (0, 0)}),
    ("sales", user.CountNull(["qty"]), {"total": (0, 0)}),
    (
        "sales",
        user.CountRatioBelow("revenue", "price", "qty", False),
        {"delta": (0, 0.05)},
    ),
    ("big_table", user.CountCB("revenue"), {}),
    ("sales", user.CountZeros("qty"), {"delta": (0, 0.3)}),
    ("sales", user.CountBelowValue("price", 100.0), {"delta": (0, 0.3)}),
    # Table with clickstream ["dt", "item_id", "views", "clicks", "payments"]
    ("views", user.CountTotal(), {"total": (1, 1e6)}),
    ("views", user.CountLag("dt"), {"lag": (0, 3)}),
    ("views", user.CountZeros("views"), {"delta": (0, 0.2)}),
    ("views", user.CountZeros("clicks"), {"delta": (0, 0.5)}),
    ("views", user.CountNull(["views", "clicks", "payments"]), {"delta": (0, 0.1)}),
    ("views", user.CountBelowValue("views", 10), {"delta": (0, 0.5)}),
    ("views", user.CountBelowColumn("clicks", "views"), {"total": (0, 0)}),
    ("views", user.CountBelowColumn("payments", "clicks"), {"total": (0, 0)}),
]
