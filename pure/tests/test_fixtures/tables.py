"""Tables for checks."""

import numpy as np
import pandas as pd
import os
import pickle

values = np.arange(100, 1000, 2)

dir = os.path.abspath(os.path.dirname(__file__))
dumps_path = os.path.join(dir, "metrics_dumps")
dump_big_table_1 = os.path.join(dumps_path, "big_table_1.pkl")
dump_big_table_2 = os.path.join(dumps_path, "big_table_2.pkl")
dump_av_table_shift = os.path.join(dumps_path, "av_table_shift.pkl")
dump_av_table_none = os.path.join(dumps_path, "av_table_none.pkl")


big_table_1 = pickle.load(open(dump_big_table_1, "rb"))
big_table_2 = pickle.load(open(dump_big_table_2, "rb"))
av_table_shift = pickle.load(open(dump_av_table_shift, "rb"))
av_table_none = pickle.load(open(dump_av_table_none, "rb"))

TABLES1 = {
    # Table with transactions
    "sales": pd.DataFrame(
        [
            ["2022-10-24", 100, np.nan, 120.0, 500.0, 'visa'],
            ["2022-10-24", 100, np.nan, np.nan, 720.0, 'visa'],
            ["2022-10-24", 200, 2, 200.0, 400.0, 'mastercard'],
            ["2022-10-24", 300, 10, 85.0, 850.0, 'Visa'],
            ["2022-10-23", 100, 3, 110.0, 330.0, 'mastercard'],
            ["2022-10-23", 200, 8, 200.0, 1600.0, 'Visa'],
            ["2022-10-23", 300, 0, 90.0, 0.0, np.nan],
        ],
        columns=["day", "item_id", "qty", "price", "revenue", "pay_card"],
    ),
    # Table with clickstream
    "views": pd.DataFrame(
        [
            ["2022-09-24", 100, 1000, 219, 56],
            ["2022-09-24", 200, 1248, 343, 1],
            ["2022-09-24", 300, 993, 102, 71],
            ["2022-09-23", 100, 3244, 730, 18],
            ["2022-09-23", 200, 830, 203, 9],
            ["2022-09-23", 300, 0, 0, 2],
            ["2022-09-22", 100, 2130, 123, 20],
            ["2022-09-22", 200, 5320, 500, 13],
            ["2022-09-22", 300, 777, 68, 2],
        ],
        columns=["dt", "item_id", "views", "clicks", "payments"],
    ),
    # Table 10_000 samples
    "big_table": big_table_1,
    "two_years": pd.DataFrame(
        [
            ["2022-09-24", 100, 1000, 219, 56],
            ["2022-09-24", 200, 1248, 343, 1],
            ["2022-09-24", 300, 993, 102, 71],
            ["2022-09-23", 100, 3244, 730, 18],
            ["2022-09-23", 200, 830, 203, 9],
            ["2021-09-23", 300, 0, 0, 2],
            ["2021-09-22", 100, 2130, 123, 20],
            ["2022-09-22", 200, 5320, 500, 13],
            ["2022-09-22", 300, 777, 68, 2],
        ],
        columns=["dt", "item_id", "views", "clicks", "payments"],
    ),
    "av_table_shift": av_table_shift,
}

TABLES2 = {
    # Table with transactions
    "sales": pd.DataFrame(
        [
            ["2022-10-21", 100, None, 120.0, 500.0, 'visa'],
            ["2022-10-21", 100, 6, 120.0, 720.0, 'visa'],
            ["2022-10-21", 200, 2, 200.0, 400.0, None],
            ["2022-10-22", 300, None, 85.0, 850.0, "мир"],
            ["2022-10-22", 100, 3, 110.0, 330.0, "tinkoff"],
            ["2022-10-22", 200, None, 200.0, 1600.0, "paypal"],
            ["2022-10-23", 300, 0, 90.0, 0.0, "mastercard"],
            ["2022-10-23", 100, 5, 120.0, 500.0, "visa"],
            ["2022-10-23", 100, 6, 120.0, 720.0, "masteRcard"],
            ["2022-10-23", 200, 2, 200.0, 400.0, "mastercard"],
            ["2022-10-23", 300, None, 85.0, 850.0, "visa"],
            ["2022-10-27", 100, 3, 110.0, 33.0, None],
            ["2022-10-27", 200, 8, 200.0, 160.0, "мир"],
            ["2022-10-27", 300, 0, 90.0, 0.0, "visa"],
            ["2022-10-27", 100, None, 120.0, 500.0, "mastercard"],
            ["2022-10-28", 100, 6, 120.0, 720.0, "мир"],
            ["2022-10-29", 200, 2, 200.0, 400.0, 'visa'],
            ["2022-10-29", 300, None, 85.0, 850.0, 'visa'],
            ["2022-10-29", 100, 3, 110.0, 330.0, "мир"],
            ["2022-10-30", 200, 8, 0.0, 160.0, 'visa'],
            ["2022-10-31", 300, 1, 0.0, 1000.0, 'visa'],
        ],
        columns=["day", "item_id", "qty", "price", "revenue", "pay_card"],
    ),
    # Table with clickstream
    "views": pd.DataFrame(
        [
            ["2022-09-24", 100, 0, 219, 56],
            ["2022-09-24", 200, 0, 343, 1],
            ["2022-09-24", 300, 0, 102, 71],
            ["2022-09-23", 100, None, 730, 18],
            ["2022-09-23", 200, None, 203, 9],
            ["2022-09-23", 300, 0, 0, 2],
            ["2022-09-22", 100, None, 123, 20],
            ["2022-09-22", 200, 0, 500, 13],
            ["2022-09-22", 300, 0, 68, 2],
            ["2022-09-25", 100, 1000, 219, 56],
            ["2022-09-25", 200, 1248, 343, 1],
            ["2022-09-25", 300, 993, 102, 71],
            ["2022-09-25", 100, 3244, 730, 18],
            ["2022-09-25", 200, None, 203, 9],
            ["2022-09-25", 300, 0, 0, 2],
            ["2022-09-21", 100, 0, 123, 20],
            ["2022-09-21", 200, 50, 500, 13],
            ["2022-09-21", 300, 0, 68, 2],
        ],
        columns=["dt", "item_id", "views", "clicks", "payments"],
    ),
    # Table 10_000 samples
    "big_table": big_table_2,
    "av_table_none": av_table_none
}

