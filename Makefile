set_path:
	export PYTHONPATH=$PYTHONPATH:..

test:
	clear
	pytest -vv

onetest:
	clear
	pytest --import-mode=append pure/tests/test_metrics.py::test_pandas_count_zeros
