"""Test cases."""
from pure.metrics import *
import datetime as dt

# Checklist contains checks consist of:
# - table_name
# - metric
# - limits

# TABLES1
CHECKLIST1 = [
    # Table with sales ["day", "item_id", "qty", "revenue", "price"]
    ("sales", CountTotal(), {"total": (1, 1e6)}),
    ("sales", CountZeros("qty"), {"delta": (0, 0.3)}),
    ("sales", CountLag("day"), {"lag": (0, 3)}),
    ("sales", CountDuplicates(["day", "item_id"]), {"total": (0, 0)}),
    ("sales", CountNull(["qty"]), {"total": (0, 0)}),
    (
        "sales",
        CountRatioBelow("revenue", "price", "qty", False),
        {"delta": (0, 0.05)},
    ),
    ("sales", CountBelowValue("price", 100.0), {"delta": (0, 0.3)}),
    ("sales", CountValueInRequiredSet("pay_card", ["mastercard", "visa"]), {"delta": (0, 0.5)}),
    ("sales", CountValueInBounds('qty', 1, 8, True), {"count": (0, 2)}),

    # big_table ["revenue"]
    ("big_table", CountCB("revenue"), {},),
    ("big_table", CountExtremeValuesQuantile("revenue", 0.9, "greater"), {"delta": (0, 0.2)}),

    # Table with clickstream ["dt", "item_id", "views", "clicks", "payments"]
    ("views", CountTotal(), {"total": (1, 1e6)}),
    ("views", CountLag("dt"), {"lag": (0, 3)}),
    ("views", CountZeros("views"), {"delta": (0, 0.2)}),
    ("views", CountZeros("clicks"), {"delta": (0, 0.5)}),
    ("views", CountNull(["views", "clicks", "payments"]), {"delta": (0, 0.1)}),
    ("views", CountBelowValue("views", 10), {"delta": (0, 0.5)}),
    ("views", CountGreaterValue("views", 1000, True), {"delta": (0, 0.3)}),
    ("views", CountBelowColumn("clicks", "views"), {"total": (0, 0)}),
    ("views", CountBelowColumn("payments", "clicks"), {"total": (0, 0)}),
    ("views", CountExtremeValuesFormula('views', 1, 'greater'), {"delta": (0, 0.2)}),

    # views table with dates from two years
    ("two_years", CountLastDayRows("dt", 80), {"last_date_count": (1, 1e6)}),
    ("two_years", CountFewLastDayRows("dt", 80, 2), {"days": (1, 2)}),
    ("two_years", CountFewLastDayRows("dt", 80, 22), {"days": (1, 2)}),

    # av_testing table ["revenue", "qty"], values for some dates are shifted by a constant
    (
        "av_table_shift",
        CheckAdversarialValidation((dt.date(2022, 4, 17), dt.date(2022, 5, 3)),
                                   (dt.date(2022, 5, 3), dt.date(2022, 5, 17)), 0.05), {}
    )
]

# TABLES 2
CHECKLIST2 = [
    # Table with sales ["day", "item_id", "qty", "revenue", "price"]
    ("sales", CountTotal(), {"total": (1, 1e6)}),
    ("sales", CountZeros("qty"), {"delta": (0, 0.3)}),
    ("sales", CountNull(["price", "qty"], "all"), {"total": (0, 0)}),
    ("sales", CountDuplicates(["qty", "item_id"]), {"delta": (0, 0.5)}),
    ("sales", CountValue("day", "2022-10-22"), {"count": (1, 5)}),
    ("sales", CountLag("day"), {"lag": (0, 3)}),
    (
        "sales",
        CountRatioBelow("revenue", "price", "qty", False),
        {"delta": (0, 0.05)}
    ),
    ("sales", CountValueInRequiredSet("pay_card", ["мир", "mastercard", "visa"]), {"delta": (0.7, 1.0)}),
    ("sales", CountValueInBounds('qty', 1, 8, True), {"count": (0, 2)}),
    ("sales", CountValueInBounds('qty', 1, 8, True), {"delta": (0, 0.5)}),
    ("sales", CountLastDayRows("day", 35), {}),

    # big_table ["revenue"]
    ("big_table", CountCB("revenue", 0.8), {}),
    ("big_table", CountExtremeValuesQuantile("revenue", 0.05, "lower"), {"delta": (0, 0.2)}),

    # Table with clickstream ["dt", "item_id", "views", "clicks", "payments"]
    ("views", CountBelowValue("views", 1000, True), {"delta": (0, 0.5)}),
    ("views", CountGreaterValue("views", 1000, True), {"delta": (0, 0.3)}),
    ("views", CountLag("dt"), {"lag": (0, 7)}),
    ("views", CountExtremeValuesFormula('views', 1, 'greater'), {"delta": (0, 0.2)}),
    ("views", CountLastDayRows("dt", 80), {"percentage": (50, 100)}),
    ("views", CountFewLastDayRows("dt", 80, 2), {"days": (1, 2)}),

    # av_testing table ["revenue", "qty"], values for some dates are set to None
    (
        "av_table_none",
        CheckAdversarialValidation((dt.date(2022, 4, 17), dt.date(2022, 5, 3)),
                                   (dt.date(2022, 5, 3), dt.date(2022, 5, 17)), 0.05), {}
    ),
    ("av_table_none", CheckAdversarialValidation((100, 200), (300, 400)), {})
]
