"""
Data Quality (DQ) Reporting Module

This module defines the `Report` class, which facilitates the generation of data quality reports
based on a checklist of metrics and corresponding tables. The class supports various engines
for data processing, including 'pandas', 'pyspark', 'postgresql', 'clickhouse', 'mssql' and `mysql`.
"""

from __future__ import annotations
from dataclasses import dataclass
from typing import Dict, List, Tuple, Union, TYPE_CHECKING

import pandas as pd
from tqdm import tqdm

from pure.metrics import Metric
import pure.sql_connector as conn
from pure.utils import ReportCache, round_nested_dict

from tabulate import tabulate

LimitType = Dict[str, Tuple[float, float]]
CheckType = Tuple[str, Metric, LimitType]

if TYPE_CHECKING:
    import pyspark.sql as ps

_cache = ReportCache()


@dataclass
class Report:
    """
    A class for generating a data quality report based on specified tables, metrics, and checklist.

    Args:
        tables (Dict[str, Union[pd.DataFrame, ps.DataFrame, str]]):
            A dictionary of table names mapped to pandas DataFrames, PySpark DataFrames, or table identifiers.
        checklist (List[CheckType]):
            Each tuple contains (table_name, metric_function, limits), where:
                - table_name (str): The name of the table to be checked.
                - metric_function (Callable): The function to compute the metric for the check.
                - limits (Optional[Dict[str, Tuple[float, float]]]): Limits for the metric, if applicable.
        engine (str, optional):
            The processing engine to use for executing the metrics. Supported engines:
            'pandas', 'pyspark', 'postgresql', 'clickhouse', 'mssql'. Defaults to 'pandas'.
        decimal_places (int, optional):
            The number of decimal places to round numeric metric values to. Must be in the range [0, 8].
            Defaults to 3.
        table_max_col_width (int, optional):
            Limits the maximum number of characters in a table column when printing a report.
            For `None` value - column width is unlimited and varies depending on its content.
        verbose (bool, optional):
            If True, prints verbose output during metric calculations. Defaults to False.

    Properties:
        df (Pandas DataFrame):
            Get the DataFrame representation of the report:
                - table:      Checked table name
                - metric:     Metric parameters
                - metric:     Metric values for checked table
                - limits:     Non-strict lower and upper bound for specified metric value
                - status:     `.` check is passed, `F` check is not passed, `E` erorr during check
                - error:      Error message if check is failed, otherwise empty string

        stats (Dict):
            Get the summary of the report:
                - tables: List[str], List of table names
                - total: int, Total number of checks performed
                - passed: int, Number of checks passed
                - failed: int, Number of checks failed
                - errors: int  Number of checks with errors

    Raises:
        NotImplementedError:
            If the specified engine is not supported.
        ValueError:
            - If the checklist is empty.
            - If the tables dictionary is empty.
            - If table_max_col_width is not within the valid range [8, 1024].
            - If decimal_places is not within the valid range [0, 8].

    Returns:
        Report:
            A Report instance containing the generated data quality report.
    """
    tables: Dict[str, Union[pd.DataFrame, ps.DataFrame, str]]
    checklist: List[CheckType]
    engine: str = "pandas"
    decimal_places: int = 3
    table_max_col_width: int = None
    verbose: bool = False

    _cached_reports = _cache
    _result = {}

    def __post_init__(self):
        """
        Perform post-initialization checks and validations:
            - If the provided `engine` is supported among ['pandas', 'pyspark', 'postgresql', 'clickhouse', 'mssql', 'mysql'].
            - If the `checklist` is not empty.
            - If the `tables` dictionary is not empty.
            - If the `decimal_places` value is within the valid range [0, 8].
            - If the `table_max_col_width` value is within the valid range [8, 1024].

        Raises:
            NotImplementedError: If the provided `engine` is not supported.
            ValueError: If the `checklist` is empty, `tables` is empty, `table_max_col_width` or `decimal_places` is not within the valid range.
        """
        supported_engines = {'pandas', 'pyspark', 'postgresql', 'clickhouse', 'mssql', 'mysql'}

        if self.engine not in supported_engines:
            err_msg = (
                f'Not supported engine: `{self.engine}`.\n'
                f'Use one of these engines: `pandas`, `pyspark`, `postgresql`, `clickhouse`, `mssql`, `mysql`.'
            )
            raise NotImplementedError(err_msg)

        if len(self.checklist) == 0:
            raise ValueError('Empty checklist passed.')

        if len(self.tables) == 0:
            raise ValueError('Empty tables passed.')

        if not (0 <= self.decimal_places <= 8):
            raise ValueError('Decimal places for numeric data must be in range [0, 8].')

        if self.table_max_col_width:
            if not (8 <= self.table_max_col_width <= 1024):
                raise ValueError('Max column width must be in range [8, 1024].')

        self._fit()

    def _fit(self):
        """
        Calculate DQ metrics and build a report.

        This method calculates data quality metrics based on the provided checklist
        and tables using the specified engine. It iterates througheach table
        and associated metric in the checklist, performs the metric calculation,
        and generates a report with relevant information.

        Returns:
            self: This method updates the internal _result attribute with a dictionary
                containing the report DataFrame and statistics.
                The dictionary structure is as follows:
                {
                    'df': pd.DataFrame,  # Data quality report
                    'stats': Dict, # Summary of the report
                }
        """
        if self.engine in {'pandas', 'pyspark'}:
            report = self._cached_reports.get(self.tables, self.checklist)

            if report is not None:
                self._result = report
                return self

        rows = []
        conn_pool = {}

        try:
            for table_name, metric, limits in (pbar:=tqdm(self.checklist, desc="Running checks", unit="check")):
                pbar.set_postfix_str(f'{table_name}: {metric}')

                row = {
                    'table': table_name,
                    'metric': repr(metric),
                    'limits': str(limits),
                }

                metric_values = {}
                status = '.'
                error = ''

                try:
                    table = self.tables.get(table_name)

                    if table is None:
                        raise ValueError(f'Not found "{table_name}" in passed tables.')

                    if isinstance(table, dict):
                        conn_dict = conn_pool.get(str(table))

                        if conn_dict is None:
                            conn_dict = self._get_conn_dict(table)
                            conn_pool[str(table)] = conn_dict

                        connector = conn_dict['conn']
                        if connector is not None:
                            metric_values = metric(self.engine, table_name, connector)
                        else:
                            status = 'E'
                            error = conn_dict['err']
                    else:
                        metric_values = metric(self.engine, table)

                    metric_values = round_nested_dict(metric_values, self.decimal_places)

                    str_limits = str(limits)
                    if limits and metric_values:
                        chk_col = list(limits.keys())[0]
                        low, high = list(limits.values())[0]
                        chk_value = metric_values.get(chk_col)

                        str_limits = f'{chk_col} == {high}' if low == high else f'{low} <= {chk_col} <= {high}'

                        if chk_value < low or chk_value > high:
                            status = 'F'

                except Exception as ex:
                    status = 'E'
                    error = str(ex)

                row['values'] = metric_values
                row['limits'] = str_limits
                row['status'] = status
                row['error'] = error

                rows.append(row)

                if self.verbose:
                    print(f"Check '{table_name}:{metric}' completed with status `{status}`.")

            if self.verbose:
                tqdm.write("All checks completed.")
        finally:
            for conn_dict in conn_pool.values():
                if conn_dict['conn'] is not None:
                    conn_dict['conn'].close()

        df = pd.DataFrame(
            data=rows,
            columns=['table', 'metric', 'values', 'limits', 'status', 'error'],
        )

        self._result = {
            'df': df,
            'stats': {
                'tables': list(self.tables.keys()),
                'total': len(df),
                'passed': sum(df["status"] == "."),
                'failed': sum(df["status"] == "F"),
                'errors': sum(df["status"] == "E")
            }
        }

        if self.engine in {'pandas', 'pyspark'}:
            self._cached_reports.set(self.tables, self.checklist, self._result)

        return self

    def _get_conn_dict(self, params: Dict[str, str]) -> Dict:
        """
        Generate a dictionary containing database connection information based on the specified parameters and engine.

        Args:
            params (Dict[str, str]): A dictionary of parameters required for establishing the database connection.

        Returns:
            Dict: A dictionary with connection information and potential error message.
                - 'conn' (object or None): The database connector object if connection is successful, otherwise None.
                - 'err' (str): An error message string if an exception occurs during connection setup, otherwise an empty string.
        """
        result = {
            'conn': None,
            'err': f'Unknown engine: {self.engine}.'
        }

        connector = None

        try:
            if self.engine == 'clickhouse':
                connector = conn.ClickHouseConnector(params)

            if self.engine == 'postgresql':
                connector = conn.PostgreSQLConnector(params)

            if self.engine == 'mssql':
                connector = conn.MSSQLConnector(params)

            if connector is not None:
                result['conn'] = connector
                result['err'] = ''
        except Exception as ex:
            result['err'] = str(ex)

        return result

    def clear_cache(self):
        """
        Clear the cached results for this instance.
        """
        self._cached_reports.clear_cache()

    def __str__(self) -> str:
        """
        Generate a human-readable string representation of the Data Quality (DQ) report.

        Returns:
            str: A string summarizing the DQ report, including table names, engine, data frame representation,
                and statistics on the total checks, passed checks, failed checks, and errors.
        """
        result = (
            f"DQ Report for tables {self.stats['tables']}, engine: `{self.engine}`.\n"
            f"{tabulate(self.df, headers='keys', tablefmt='psql', showindex=False, maxcolwidths=self.table_max_col_width)}\n"
            f"Total checks: {self.stats['total']},  passed: {self.stats['passed']}, failed: {self.stats['failed']}, errors: {self.stats['errors']}."
        )

        return result

    @property
    def df(self):
        """
        Get the DataFrame representation of the report.

        Returns:
            pandas.DataFrame: The DataFrame containing the report data.

        Raises:
            ValueError: If the report is empty (no entries found).
        """
        if not self._result:
            raise ValueError('Empty report, no entries found.')

        return self._result['df']

    @property
    def stats(self):
        """
        Get the summary of the report.

        Returns:
            dict: A dictionary containing statistics about the report.
                - tables (List[str]): List of table names covered in the report.
                - total (int): Total number of checks performed.
                - passed (int): Number of checks that passed successfully.
                - failed (int): Number of checks that failed.
                - errors (int): Number of checks that encountered errors.

        Raises:
            ValueError: If the report is empty (no entries found).
        """
        if not self._result:
            raise ValueError('Empty report, no entries found.')

        return self._result['stats']
