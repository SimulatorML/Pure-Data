"""
============================================
Data Quality Check for E-commerce Sales Data
============================================

This script demonstrates how to use the 'Pure Data' library to perform data quality checks
on a sample e-commerce sales dataset. The dataset contains daily sales data, including item
IDs, quantities sold, prices, revenues, and payment methods.

The data quality checks performed include:

1. Counting the total number of records and ensuring they fall within a specified range.
2. Counting the number of zero values in the 'qty' column and ensuring the proportion of zeros
    is within a specified range.
3. Counting the number of null values in both the 'price' and 'qty' columns and ensuring there
    are no null values.

The results of these checks are then printed in a tabular format, indicating the status of each
check (passed, failed, or error).

"""


import pandas as pd
from pure.report import Report
import pure.metrics as m

# Create a table with some data
sales = pd.DataFrame(
    [
        ["2022-10-21", 100, None, 120.0, 500.0, "visa"],
        ["2022-10-21", 100, 6, 120.0, 720.0, "visa"],
        ["2022-10-21", 200, 2, 200.0, 400.0, None],
        ["2022-10-22", 300, None, 85.0, 850.0, "unionpay"],
        ["2022-10-22", 100, 3, 110.0, 330.0, "tinkoff"],
        ["2022-10-22", 200, None, 200.0, 1600.0, "paypal"]
    ],
    columns=["day", "item_id", "qty", "price", "revenue", "pay_card"]
)

# Define a checklist
checklist = [
    ("sales", m.CountTotal(), {"total": (1, 1e6)}),
    ("sales", m.CountZeros("qty"), {"delta": (0, 0.3)}),
    ("sales", m.CountNull(["price", "qty"], "all"), {"total": (0, 0)})
]

tables = {'sales': sales}

report = Report(tables, checklist, engine='pandas')
print(report)