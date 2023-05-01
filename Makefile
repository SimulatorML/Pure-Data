test:
	clear
	python3 -m pytest -vv

onetest:
	clear
	python3 -m pytest pure/tests/test_metrics.py::test_metrics_pyspark
