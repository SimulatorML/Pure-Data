test:
	clear
	python -m pytest -vv

onetest:
	clear
	python -m pytest pure/tests/test_metrics.py::test_pandas_count_zeros
