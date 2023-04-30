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


def test_count_null_wrong_agg():
    """Test CountNull metric initialization.

    Test that metric initialization with unacceptable
    aggregation parameter value raises ValueError.
    """
    try:
        metrics.CountNull(['qty'], 'ALL')
    except ValueError:
        pass
    else:
        raise AssertionError("Not acceptable aggregation value is not handled")


def test_count_cb_wrong_conf():
    """Test CountCB metric initialization.

    Test that metric initialization with 'conf' parameter value
    out of [0, 1] interval raises ValueError
    """
    try:
        metrics.CountCB('qty', 1.5)
    except ValueError:
        pass
    else:
        raise AssertionError("Confidence level value out of [0, 1] interval is not handled")


def test_count_value_in_bound_wrong_bounds():
    """Test CountValueInBounds metric initialization.

    Test that metric initialization with 'lower_bound' parameter
    greater than 'upper_bound' parameter raises ValueError.
    """
    try:
        metrics.CountValueInBounds('qty', 10, 5, False)
    except ValueError:
        pass
    else:
        raise AssertionError("Lower bound greater than upper bound case is not handled")


def test_count_extreme_values_formula_wrong_style():
    """Test CountExtremeValuesFormula metric initialization.

    Test that metric initialization with unacceptable
    'style' parameter raises ValueError.
    """
    try:
        metrics.CountExtremeValuesFormula('qty', 1, 'equal')
    except ValueError:
        pass
    else:
        raise AssertionError("Not acceptable style value is not handled.")


def test_count_extreme_values_quantile_wrong_style():
    """Test CountExtremeValuesQuantile metric initialization.

    Test that metric initialization with unacceptable
    'style' parameter raises ValueError.
    """
    try:
        metrics.CountExtremeValuesQuantile('qty', 0.2, 'equal')
    except ValueError:
        pass
    else:
        raise AssertionError("Not acceptable style value is not ha  ndled.")


def test_count_extreme_values_quantile_wrong_q():
    """Test CountExtremeValuesQuantile metric initialization.

    Test that metric initialization with
    'number' parameter out of acceptable [0, 1] interval raises ValueError.
    """
    try:
        metrics.CountExtremeValuesQuantile('qty', 2, 'greater')
    except ValueError:
        pass
    else:
        raise AssertionError("Quantile value out of [0, 1] interval is not handled.")


def test_count_last_day_rows_negative_percent():
    """Test CountLastDayRows metric initialization.

    Test that metric initialization with
    negative 'percent' parameter value raises ValueError.
    """
    try:
        metrics.CountLastDayRows('day', -10)
    except ValueError:
        pass
    else:
        raise AssertionError("Negative percent is not handled.")


def test_count_vew_last_day_rows_pyspark():
    """Test CountFewLastDayRows metric, pyspark version (not implemented yet).

    Test that calling pyspark version of CountFewLastDayRows
    raises NotImplementedError .
    """
    run_one_pandas_test("CountFewLastDayRows")
    try:
        run_one_pyspark_test("CountFewLastDayRows")
    except NotImplementedError:
        pass
    else:
        raise AssertionError("Calling not implemented method is not handled.")


def test_count_few_last_day_rows_negative_percent():
    """Test CountFewLastDayRows metric initialization.

    Test that metric initialization with
    negative 'percent' parameter value raises ValueError.
    """
    try:
        metrics.CountFewLastDayRows('day', -10)
    except ValueError:
        pass
    else:
        raise AssertionError("Negative percent is not handled.")


def test_count_few_last_day_rows_negative_number():
    """Test CountFewLastDayRows metric initialization.

    Test that metric initialization with
    negative 'number' parameter value raises ValueError.
    """
    try:
        metrics.CountFewLastDayRows('day', 40, -2)
    except ValueError:
        pass
    else:
        raise AssertionError("Negative number is not handled.")


def test_count_few_last_day_rows_number_greater():
    """Test CountFewLastDayRows metric, pandas version, with inappropriate 'number' parameter.

    Test that metric calling with 'number' value greater
    than number of unique days in dataset raises ValueError.
    """
    try:
        model = metrics.CountFewLastDayRows('day', 40, 8)
        df = TABLES2["sales"]
        model(df)
    except ValueError:
        pass
    else:
        raise AssertionError("Number greater than number of days in dataset is not handled.")
