import numpy as np
from test_fixtures.metric_cases import TEST_CASES as metric_cases

from pure import metrics
from pyspark.sql import SparkSession


def test_metrics_pandas():
    """Test pandas engine metrics."""

    for metric_name, test_cases in metric_cases.items():
        for case in test_cases:

            tables_set = case["tables_set"]
            table_name = case["table_name"]
            params = case["params"]
            expected_result = case["expected_result"]

            table = tables_set[table_name].copy()
            metric_result = getattr(metrics, metric_name)(*params)(table)

            msg = (
                f"Metric '{metric_name}' should "
                "return Dict[str, Any[float, int, str]]"
            )
            assert isinstance(metric_result, dict), msg

            msg = (
                f"Metric {metric_name} returns wrong value."
                f" Yours value: {metric_result}. Valid value: {expected_result}"
            )
            for key, value in metric_result.items():
                assert np.isclose(value, expected_result[key], rtol=1e-04), msg


def test_metrics_pyspark():
    """Test pyspark engine metrics."""
    spark = (
        SparkSession.builder.master("local").appName("spark_test").getOrCreate()
    )
    spark.sparkContext.setLogLevel("OFF")

    for metric_name, test_cases in metric_cases.items():
        for case in test_cases:

            tables_set = case["tables_set"]
            table_name = case["table_name"]
            params = case["params"]
            expected_result = case["expected_result"]

            table = tables_set[table_name].copy()
            table_spark = spark.createDataFrame(table)
            metric_result = getattr(metrics, metric_name)(*params)(table_spark)

            msg = (
                f"Metric '{metric_name}' should "
                "return Dict[str, Any[float, int, str]]"
            )
            assert isinstance(metric_result, dict), msg

            msg = (
                f"Metric {metric_name} returns wrong value."
                f" Yours value: {metric_result}. Valid value: {expected_result}"
            )
            for key, value in metric_result.items():
                assert np.isclose(value, expected_result[key], rtol=1e-04), msg


def run_one_pandas_test(metric_name):
    """Test one pandas engine metric."""
    test_cases = metric_cases[metric_name]
    for i, case in enumerate(test_cases):
        tables_set = case["tables_set"]
        table_name = case["table_name"]
        params = case["params"]
        expected_result = case["expected_result"]

        table = tables_set[table_name].copy()
        metric_result = getattr(metrics, metric_name)(*params)(table)

        msg = (
            f"Metric '{metric_name}' should "
            "return Dict[str, Any[float, int, str]]"
        )
        assert isinstance(metric_result, dict), msg

        msg = ("Engine: pandas."
               f" Metric {metric_name} returns wrong value in case №{i + 1}."
               f" Yours value: {metric_result}. Valid value: {expected_result}"
               )
        for key, value in metric_result.items():
            assert np.isclose(value, expected_result[key], rtol=1e-04), msg


def run_one_pyspark_test(metric_name):
    """Test one pyspark engine metric."""
    spark = (
        SparkSession.builder.master("local").appName("spark_test").getOrCreate()
    )
    spark.sparkContext.setLogLevel("OFF")
    test_cases = metric_cases[metric_name]
    for i, case in enumerate(test_cases):

        tables_set = case["tables_set"]
        table_name = case["table_name"]
        params = case["params"]
        expected_result = case["expected_result"]

        table = tables_set[table_name].copy()
        table_spark = spark.createDataFrame(table)
        metric_result = getattr(metrics, metric_name)(*params)(table_spark)

        msg = (
            f"Metric '{metric_name}' should "
            "return Dict[str, Any[float, int, str]]"
        )
        assert isinstance(metric_result, dict), msg

        msg = ("Engine: pyspark."
               f" Metric {metric_name} returns wrong value in case №{i + 1}."
               f" Yours value: {metric_result}. Valid value: {expected_result}"
               )
        for key, value in metric_result.items():
            assert np.isclose(value, expected_result[key], rtol=1e-04), msg


def test_count_total():
    run_one_pandas_test("CountTotal")
    run_one_pyspark_test("CountTotal")


def test_count_zeros():
    run_one_pandas_test("CountZeros")
    run_one_pyspark_test("CountZeros")


def test_count_null():
    run_one_pandas_test("CountNull")
    run_one_pyspark_test("CountNull")


def test_count_duplicates():
    run_one_pandas_test("CountDuplicates")
    run_one_pyspark_test("CountDuplicates")


def test_count_value():
    run_one_pandas_test("CountValue")
    run_one_pyspark_test("CountValue")


def test_count_below_value():
    run_one_pandas_test("CountBelowValue")
    run_one_pyspark_test("CountBelowValue")


def test_count_greater_value():
    run_one_pandas_test("CountGreaterValue")
    run_one_pyspark_test("CountGreaterValue")


def test_count_below_column():
    run_one_pandas_test("CountBelowColumn")
    run_one_pyspark_test("CountBelowColumn")


def test_count_ration_below():
    run_one_pandas_test("CountRatioBelow")
    run_one_pyspark_test("CountRatioBelow")


def test_count_cb():
    run_one_pandas_test("CountCB")
    run_one_pyspark_test("CountCB")


