"""Test cases."""
import datetime as dt

import pure.metrics as m

# Checklist contains checks consist of:
# - table_name
# - metric
# - limits

# TABLES1
CHECKLIST1 = [
    # Table with sales ["day", "item_id", "qty", "revenue", "price"]
    ("sales", m.CountTotal(), {"total": (1, 1e6)}),
    ("sales", m.CountZeros("qty"), {"delta": (0, 0.3)}),
    ("sales", m.CountDuplicates(["day", "item_id"]), {"total": (0, 0)}),
    ("sales", m.CountNull(["qty"]), {"total": (0, 0)}),
    ("sales", m.CountRatioBelow("revenue", "price", "qty", False), {"delta": (0, 0.05)}),
    ("sales", m.CountBelowValue("price", 100.0), {"delta": (0, 0.3)}),
    ("sales", m.CountValueInSet("pay_card", ["mastercard", "visa"]), {"delta": (0, 0.5)}),
    ("sales", m.CountValueInBounds("qty", 1, 8, True), {"count": (0, 2)}),

    # big_table ["revenue"]
    ("big_table", m.CountCB("revenue"), {}),
    ("big_table", m.CountExtremeValuesQuantile("revenue", 0.9, "greater"), {"delta": (0, 0.2)}),

    # Table with clickstream ["dt", "item_id", "views", "clicks", "payments"]
    ("views", m.CountTotal(), {"total": (1, 1e6)}),
    ("views", m.CountZeros("views"), {"delta": (0, 0.2)}),
    ("views", m.CountZeros("clicks"), {"delta": (0, 0.5)}),
    ("views", m.CountNull(["views", "clicks", "payments"]), {"delta": (0, 0.1)}),
    ("views", m.CountBelowValue("views", 10), {"delta": (0, 0.5)}),
    ("views", m.CountGreaterValue("views", 1000, True), {"delta": (0, 0.3)}),
    ("views", m.CountBelowColumn("clicks", "views"), {"total": (0, 0)}),
    ("views", m.CountBelowColumn("payments", "clicks"), {"total": (0, 0)}),
    ("views", m.CountExtremeValuesFormula("views", 1, "greater"), {"delta": (0, 0.2)}),

    # views table with dates from two years
    ("two_years", m.CountLastDayRows("dt", 80), {"last_date_count": (1, 1e6)}),
    ("two_years", m.CountFewLastDayRows("dt", 80, 2), {"days": (1, 2)}),
    ("two_years", m.CountFewLastDayRows("dt", 80, 22), {"days": (1, 2)}),

    # av_testing table ["revenue", "qty"], values for some dates are shifted by a constant
    (
        "av_table_shift",
        m.CheckAdversarialValidation(
            (dt.date(2022, 4, 17), dt.date(2022, 5, 3)),
            (dt.date(2022, 5, 3), dt.date(2022, 5, 17)),
            0.05
        ),
        {}
    ),
]

# TABLES 2
CHECKLIST2 = [
    # Table with sales ["day", "item_id", "qty", "revenue", "price"]
    ("sales", m.CountTotal(), {"total": (1, 1e6)}),
    ("sales", m.CountZeros("qty"), {"delta": (0, 0.3)}),
    ("sales", m.CountNull(["price", "qty"], "all"), {"total": (0, 0)}),
    ("sales", m.CountDuplicates(["qty", "item_id"]), {"delta": (0, 0.5)}),
    ("sales", m.CountValue("day", "2022-10-22"), {"count": (1, 5)}),
    ("sales", m.CountRatioBelow("revenue", "price", "qty", False), {"delta": (0, 0.05)}),
    ("sales", m.CountValueInSet("pay_card", ["unionpay", "mastercard", "visa"]), {"delta": (0.7, 1.0)}, ),
    ("sales", m.CountValueInBounds("qty", 1, 8, True), {"count": (0, 2)}),
    ("sales", m.CountValueInBounds("qty", 1, 8, True), {"delta": (0, 0.5)}),
    ("sales", m.CountLastDayRows("day", 35), {}),

    # big_table ["revenue"]
    ("big_table", m.CountCB("revenue", 0.8), {}),
    ("big_table", m.CountExtremeValuesQuantile("revenue", 0.05, "lower"), {"delta": (0, 0.2)},),

    # Table with clickstream ["dt", "item_id", "views", "clicks", "payments"]
    ("views", m.CountBelowValue("views", 1000, True), {"delta": (0, 0.5)}),
    ("views", m.CountGreaterValue("views", 1000, True), {"delta": (0, 0.3)}),
    ("views", m.CountExtremeValuesFormula("views", 1, "greater"), {"delta": (0, 0.2)}),
    ("views", m.CountLastDayRows("dt", 80), {"percentage": (50, 100)}),
    ("views", m.CountFewLastDayRows("dt", 80, 2), {"days": (1, 2)}),

    # av_testing table ["revenue", "qty"], values for some dates are set to None
    (
        "av_table_none",
        m.CheckAdversarialValidation(
            (dt.date(2022, 4, 17), dt.date(2022, 5, 3)),
            (dt.date(2022, 5, 3), dt.date(2022, 5, 17)),
            0.05,
        ),
        {}
    ),
    (
        "av_table_none",
        m.CheckAdversarialValidation(
            (100, 200),
            (300, 400)
        ),
        {}
    ),
]
