"""Connection initializers for SQL engines"""

from typing import Any, Dict
from abc import ABC, abstractmethod
import clickhouse_driver
import psycopg2
import pymssql
import mysql.connector


class SQLConnector(ABC):
    """Base class for Connector"""

    @abstractmethod
    def __init__(self, host: str, port: int, user: str, password: str, database: str = None):
        self.host = host
        self.port = port
        self.user = user
        self.password = password
        self.database = database
        self.connect()

    @abstractmethod
    def connect(self):
        pass

    @abstractmethod
    def execute(self, query: str):
        pass

    @abstractmethod
    def close(self):
        pass


class ClickHouseConnector(SQLConnector):
    """Communication with the ClickHouse database"""
    def __init__(self, host: str, port: int, user: str, password: str):
        super().__init__(host, port, user, password)

    def connect(self):
        self.connection = clickhouse_driver.connect(
            host=self.host,
            port=self.port,
            user=self.user,
            password=self.password
        )

        self.cursor = self.connection.cursor()

        return self

    def execute(self, query, params: Dict[str, Any] = None):
        try:
            self.cursor.execute(query, params)
            return self.cursor.fetchall()
        except:
            raise

    def close(self):
        if self.cursor:
            self.cursor.close()

        if self.connection:
            self.connection.close()

    @property
    def engine(self) -> str:
        """Database engine"""
        return 'clickhouse'


class PostgreSQLConnector(SQLConnector):
    """Communication with the PostgreSQL database"""
    def __init__(self, host: str, port: int, user: str, password: str, database):
        super().__init__(host, port, user, password, database)

    def connect(self):
        self.connection = psycopg2.connect(
            user=self.user,
            password=self.password,
            host=self.host,
            port=self.port,
            database=self.database
        )

        self.cursor = self.connection.cursor()

        return self

    def execute(self, query: str, params: Dict[str, Any] = None):
        try:
            self.cursor.execute(query, params)
            return self.cursor.fetchall()
        except:
            self.connection.rollback()
            raise

        return self.cursor

    def close(self):
        if self.cursor:
            self.cursor.close()

        if self.connection:
            self.connection.close()

    @property
    def engine(self) -> str:
        """Database engine"""
        return 'postgresql'


class MSSQLConnector(SQLConnector):
    """Communication with the MSSQL database"""
    def __init__(self, host: str, port: int, user: str, password: str, database):
        super().__init__(host, port, user, password, database)

    def connect(self):
        self.connection = pymssql.connect(
            server=self.host,
            port=self.port,
            database=self.database,
            user=self.user,
            password=self.password
        )

        self.cursor = self.connection.cursor()

        return self

    def execute(self, query, params: Dict[str, Any] = None):
        try:
            self.cursor.execute(query, params)
            return self.cursor.fetchall()
        except:
            raise

    def close(self):
        if self.cursor:
            self.cursor.close()

        if self.connection:
            self.connection.close()

    @property
    def engine(self) -> str:
        """Database engine"""
        return 'mssql'


class MySQLConnector(SQLConnector):
    """Communication with the PostgreSQL database"""
    def __init__(self, host: str, port: int, user: str, password: str, database):
        super().__init__(host, port, user, password, database)

    def connect(self):
        self.connection = mysql.connector.connect(
            host=self.host,
            port=self.port,
            database=self.database,
            user=self.user,
            password=self.password
        )

        self.cursor = self.connection.cursor()

        return self

    def execute(self, query, params: Dict[str, Any] = None):
        try:
            self.cursor.execute(query, params)
            return self.cursor.fetchall()
        except:
            raise

    def close(self):
        if self.cursor:
            self.cursor.close()

        if self.connection:
            self.connection.close()

    @property
    def engine(self) -> str:
        """Database engine"""
        return 'mysql'
