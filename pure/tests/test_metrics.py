import numbers

import numpy as np
from pure.tests.test_fixtures.metric_cases import TEST_CASES as metric_cases
from pure.tests.test_fixtures.tables import TABLES1, TABLES2

from pure import metrics
from pure.utils import PySparkSingleton


def test_metrics_pandas():
    """Test pandas engine metrics."""

    for metric_name in metric_cases.keys():
        run_one_pandas_test(metric_name)


def test_metrics_pyspark():
    """Test pyspark engine metrics."""
    for metric_name in metric_cases.keys():
        try:
            run_one_pyspark_test(metric_name)
        except NotImplementedError:
            pass


def run_one_pandas_test(metric_name):
    """Test one pandas engine metric."""
    test_cases = metric_cases[metric_name]
    for i, case in enumerate(test_cases):
        tables_set = case["tables_set"]
        table_name = case["table_name"]
        params = case["params"]
        expected_result = case["expected_result"]

        table = tables_set[table_name].copy()
        metric_result = getattr(metrics, metric_name)(*params)('pandas', table)

        msg = f"Metric '{metric_name}' should " "return Dict[str, Any[float, int, str]]"
        assert isinstance(metric_result, dict), msg

        msg = (
            "Engine: pandas."
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
    pss = PySparkSingleton()

    spark = pss.sql.SparkSession.builder.master("local").appName("spark_test").getOrCreate()
    spark.sparkContext.setLogLevel("OFF")
    test_cases = metric_cases[metric_name]
    for i, case in enumerate(test_cases):
        tables_set = case["tables_set"]
        table_name = case["table_name"]
        params = case["params"]
        expected_result = case["expected_result"]

        table = tables_set[table_name].copy()
        table_spark = spark.createDataFrame(table.reset_index())
        metric_result = getattr(metrics, metric_name)(*params)('pyspark', table_spark)

        msg = f"Metric '{metric_name}' should " "return Dict[str, Any[float, int, str]]"
        assert isinstance(metric_result, dict), msg

        msg = (
            "Engine: pyspark."
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
        metrics.CountNull(["qty"], "ALL")
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
        metrics.CountCB("qty", 1.5)
    except ValueError:
        pass
    else:
        raise AssertionError(
            "Confidence level value out of [0, 1] interval is not handled"
        )


def test_count_value_in_bound_wrong_bounds():
    """Test CountValueInBounds metric initialization.

    Test that metric initialization with 'lower_bound' parameter
    greater than 'upper_bound' parameter raises ValueError.
    """
    try:
        metrics.CountValueInBounds("qty", 10, 5, False)
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
        metrics.CountExtremeValuesFormula("qty", 1, "equal")
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
        metrics.CountExtremeValuesQuantile("qty", 0.2, "equal")
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
        metrics.CountExtremeValuesQuantile("qty", 2, "greater")
    except ValueError:
        pass
    else:
        raise AssertionError("Quantile value out of [0, 1] interval is not handled.")


def test_count_last_day_rows_negative_percent():
    """Test CountLastDayRowsPercent metric initialization.

    Test that metric initialization with
    negative 'percent' parameter value raises ValueError.
    """
    try:
        metrics.CountLastDayRowsPercent("day", -10)
    except ValueError:
        pass
    else:
        raise AssertionError("Negative percent is not handled.")


def test_count_few_last_day_rows_negative_percent():
    """Test CountFewLastDayRows metric initialization.

    Test that metric initialization with
    negative 'percent' parameter value raises ValueError.
    """
    try:
        metrics.CountFewLastDayRows("day", -10)
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
        metrics.CountFewLastDayRows("day", 40, -2)
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
        model = metrics.CountFewLastDayRows("day", 40, 8)
        df = TABLES2["sales"]
        model('pandas', df)
    except ValueError:
        pass
    else:
        raise AssertionError(
            "Number greater than number of days in dataset is not handled."
        )


def test_check_adversarial_validation_slices_wrong_length():
    """Test CheckAdversarialValidation metric initialization, pandas version,
    with inappropriate slices length.

    Test that metric initialization with slices that length != 2 raises ValueError.
    """
    try:
        model = metrics.CheckAdversarialValidation((100, 200), (300,), eps=0.05)
    except ValueError:
        pass
    else:
        raise AssertionError("Slices with wrong length not handled.")


def test_check_adversarial_validation_slices_wrong_values():
    """Test CheckAdversarialValidation metric, pandas version,
    with inappropriate slices values.

    Test that metric calling with slices where
    first value in slice is greater than second one raises ValueError.
    """
    try:
        model = metrics.CheckAdversarialValidation((100, 200), (300, 250), eps=0.05)
        df = TABLES2["av_table_none"]
        model('pandas', df)
    except ValueError:
        pass
    else:
        raise AssertionError("Slices with wrong value order not handled.")


def test_check_adversarial_validation_non_index_slices():
    """Test CheckAdversarialValidation metric, pandas version,
    with non index slice.

    Test that metric calling with slices where
    values are not index type of input dataframe raises TypeError.
    """
    try:
        model = metrics.CheckAdversarialValidation((100, 200), (250, 300), eps=0.05)
        df = TABLES2["av_table_none"]
        model('pandas', df)
    except TypeError:
        pass
    else:
        raise AssertionError("Slices with wrong value order not handled.")
