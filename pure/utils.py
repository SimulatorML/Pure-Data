from typing import Dict, List, Union
import importlib
import hashlib


class PySparkSingleton:
    """
    A singleton class for managing a PySpark instance.

    This class ensures that only one instance of the PySpark environment is created
    and provides convenient access to the PySpark SQL and functions modules.

    Attributes:
        _instance: A reference to the singleton instance of the PySparkSingleton class.
        _version (str): The recommended version of PySpark.

    Properties:
        sql:
            Property representing the 'pyspark.sql' module.
        func:
            Property representing the 'pyspark.sql.functions' module.
    """
    _instance = None
    _version = "3.4.0"

    def __new__(cls):
        """
        Create a new instance of the PySparkSingleton class if it does not exist already.

        Returns:
            PySparkSingleton: The singleton instance of the class.
        """
        if cls._instance is None:
            try:
                cls._instance = super().__new__(cls)
                cls._instance.sql_ = importlib.import_module('pyspark.sql')
                cls._instance.functions = importlib.import_module('pyspark.sql.functions')
            except ImportError:
                print('Failed to import PySpark module.')
                print(f'Check if pyspark is installed, recommended version: {cls._version}')
                raise

        return cls._instance

    @property
    def sql(self):
        """
        Property representing the 'pyspark.sql' module.

        Returns:
            module: The 'pyspark.sql' module.
        """

        return self._instance.sql_

    @property
    def func(self):
        """
        Property representing the 'pyspark.sql.functions' module.

        Returns:
            module: The 'pyspark.sql.functions' module.
        """

        return self._instance.functions


class ReportCache:
    """
    A class for caching and retrieving reports based on checklists and tables.

    This class provides methods to cache reports based on the input checklist and tables
    and retrieve them efficiently. The caching is done using hashed versions of the input data.

    Attributes:
        cache (dict): A dictionary to store cached reports.Keys are hashed checklists,
                      and values are dictionaries with hashed tables as keys and reports as values.
    """
    def __init__(self):
        """Initialize the ReportCache instance with an empty cache."""
        self.cache = {}

    def get(self, tables: Dict, checklist: List):
        """
        Retrieve a cached report based on the provided checklist and tables.

        Args:
            tables (dict): The tables associated with the report.
            checklist (list): The checklist for which the report was generated.

        Returns:
            dict or None: The cached report if found, or None if not in cache.
        """
        report = None

        hashed_tables = self._hash(tables)
        checklist_dict = self.cache.get(hashed_tables)

        if checklist_dict is not None:
            hashed_checklist = self._hash(checklist)
            report = checklist_dict.get(hashed_checklist)

        return report

    def set(self, tables: Dict, checklist: List, report: Dict):
        """
        Cache a report based on the provided checklist, tables, and report.

        Args:
            checklist (list): The checklist associated with the report.
            tables (dict): The tables associated with the report.
            report (dict): The report to be cached.
        """

        checklist_dict = {}
        hashed_checklist = self._hash(checklist)
        checklist_dict[hashed_checklist] = report

        hashed_tables = self._hash(tables)
        self.cache[hashed_tables] = checklist_dict

    def clear_cache(self):
        """Clear all cached reports from the cache."""
        self.cache.clear()

    def _hash(self, data: Union[List, Dict]) -> str:
        """
        Generate a SHA-256 hash for the provided data (list or dict).

        Args:
            data (list or dict): The data to be hashed.

        Returns:
            str: The hexadecimal representation of the generated hash.
        """
        if not isinstance(data, (list, dict)):
            raise TypeError("Data must be either a List or a Dict.")

        data_str = str(data).encode('utf-8')
        sha256_hash = hashlib.sha256()
        sha256_hash.update(data_str)
        hash_hex = sha256_hash.hexdigest()

        return hash_hex


def round_nested_dict(d, decimals):
    """
    Recursively rounds numeric values in a nested dict to the specified number of decimal places.

    Args:
        d (dict or numeric): The dictionary to be processed. Can contain nested dictionaries.
        decimals (int): The number of decimal places to round numeric values to.

    Returns:
        dict: A new dictionary with rounded numeric values and unchanged non-numeric values.
    """
    if isinstance(d, dict):
        return {key: round_nested_dict(value, decimals) for key, value in d.items()}
    elif isinstance(d, (int, float)):
        return round(d, decimals)
    else:
        return d
