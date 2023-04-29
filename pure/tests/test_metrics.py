import numpy as np
from test_fixtures.metric_cases import TEST_CASES as metric_cases
from test_fixtures.tables import TABLES1, TABLES2

from pure import metrics
from pyspark.sql import SparkSession
import numbers


def test_metrics_pandas():
    """Test pandas engine metrics."""

    for metric_name in metric_cases.keys():
        run_one_pandas_test(metric_name)


def test_metrics_pyspark():
    """Test pyspark engine metrics."""
    spark = (
        SparkSession.builder.master("local").appName("spark_test").getOrCreate()
    )
    spark.sparkContext.setLogLevel("OFF")

    for metric_name in metric_cases.keys():
        run_one_pyspark_test(metric_name)


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
            if isinstance(expected_result[key], numbers.Number):
                assert np.isclose(value, expected_result[key], rtol=1e-04), msg
            else:
                assert value == expected_result[key], msg


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
            if isinstance(expected_result[key], numbers.Number):
                assert np.isclose(value, expected_result[key], rtol=1e-04), msg
            else:
                assert value == expected_result[key], msg


def test_count_total():
    run_one_pandas_test("CountTotal")
    run_one_pyspark_test("CountTotal")


def test_count_zeros():
    run_one_pandas_test("CountZeros")
    run_one_pyspark_test("CountZeros")


def test_count_null():
    run_one_pandas_test("CountNull")
    run_one_pyspark_test("CountNull")


def test_count_null_wrong_agg():
    try:
        metrics.CountNull(['qty'], 'ALL')
    except ValueError:
        pass
    else:
        raise AssertionError("Not acceptable aggregation value is not handled")


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


def test_count_lag():
    run_one_pandas_test("CountLag")
    run_one_pyspark_test("CountLag")


def test_count_value_in_required_set():
    run_one_pandas_test("CountValueRequiredSet")
    run_one_pyspark_test("CountValueRequiredSet")


def test_count_value_in_bounds():
    run_one_pandas_test("CountValueInBounds")
    run_one_pyspark_test("CountValueInBounds")


def test_count_value_in_bound_wrong_bounds():
    try:
        metrics.CountValueInBounds('qty', 10, 5, False)
    except ValueError:
        pass
    else:
        raise AssertionError("Lower bound greater than upper bound case is not handled")


def test_count_extreme_values_formula():
    run_one_pandas_test("CountExtremeValuesFormula")
    run_one_pyspark_test("CountExtremeValuesFormula")


def test_count_extreme_values_formula_wrong_style():
    try:
        metrics.CountExtremeValuesFormula('qty', 1, 'equal')
    except ValueError:
        pass
    else:
        raise AssertionError("Not acceptable style value is not handled.")


def test_count_extreme_values_quantile():
    run_one_pandas_test("CountExtremeValuesQuantile")
    run_one_pyspark_test("CountExtremeValuesQuantile")


def test_count_extreme_values_quantile_wrong_style():
    try:
        metrics.CountExtremeValuesQuantile('qty', 0.2, 'equal')
    except ValueError:
        pass
    else:
        raise AssertionError("Not acceptable style value is not handled.")


def test_count_extreme_values_quantile_wrong_q():
    try:
        metrics.CountExtremeValuesQuantile('qty', 2, 'greater')
    except ValueError:
        pass
    else:
        raise AssertionError("Quantile value out of [0, 1] interval is not handled.")


def test_count_last_day_rows():
    run_one_pandas_test("CountLastDayRows")
    run_one_pyspark_test("CountLastDayRows")


def test_count_last_day_rows_negative_percent():
    try:
        metrics.CountLastDayRows('day', -10)
    except ValueError:
        pass
    else:
        raise AssertionError("Negative percent is not handled.")


def test_count_few_last_day_rows():
    run_one_pandas_test("CountFewLastDayRows")
    try:
        run_one_pyspark_test("CountFewLastDayRows")
    except NotImplementedError:
        pass
    else:
        raise AssertionError("Calling not implemented method is not handled.")


def test_count_few_last_day_rows_negative_percent():
    try:
        metrics.CountFewLastDayRows('day', -10)
    except ValueError:
        pass
    else:
        raise AssertionError("Negative percent is not handled.")


def test_count_few_last_day_rows_negative_number():
    try:
        metrics.CountFewLastDayRows('day', 40, -2)
    except ValueError:
        pass
    else:
        raise AssertionError("Negative number is not handled.")


def test_count_few_last_day_rows_number_greater():
    try:
        model = metrics.CountFewLastDayRows('day', 40, 8)
        df = TABLES2["sales"]
        model(df)
    except ValueError:
        pass
    else:
        raise AssertionError("Number greater than number of days in dataset is not handled.")


