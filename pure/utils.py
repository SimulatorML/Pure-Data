import importlib


class PySparkSingleton:
    '''
    Singleton implementation for importing and using the PySpark modules: `sql`, `functions`.

    Only one instance of the class is created, properties provides access to corresponding modules.
    '''
    _instance = None
    _version = "3.4.0"

    def __new__(cls):
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
        '''pyspark.sql module'''

        return self._instance.sql_

    @property
    def func(self):
        '''pyspark.sql.functions module'''

        return self._instance.functions
