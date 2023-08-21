# Pure Data
Developed by students of the [Simulator ML (Karpov.Courses)](https://karpov.courses/simulator-ml)

Pure Data is a tool designed to help organize data quality checks in your projects.
You simply define the data you want to test, the list of test metrics and success criteria, run the test, and get a report with the results.

The Pure Data includes:
* a list of different metrics that you can use to check the accuracy of the data;
* Report class, with which you can iterate through a list of metrics and get some summary information about which metrics pass, fail, or drop with errors.

## How to install
```bash
pip install pure-data
```

## Key Functionality
There are plenty of metrics that you can use to control your data's accuracy and reliability.\
You can either just apply the metrics you need to your data or use the **Report** class to create a checklist with metrics you'd like to check and get summary information about the metrics results.

<img src="https://drive.google.com/uc?id=1IVn9xubBaCNcf_ln3wLlhEzvCyG5clmj"
     alt="Pure application diagram"
     style="display: block; margin-right: auto; margin-left: auto; width: 45%" />

## Usage
Below is a brief example of how you can use Pure to verify your data.

Import **Report** class and metrics from which you can use any metrics you need.
```python
from pure.report import Report
import pure.metrics as m
```

Firstly, initialize tables with names and data you want to work with, and create a checklist with metrics.

**Metric** returns a dict with some meta fields. In the checklist, you can specify which metric result fields you want to control within certain limits.
In this example, we will determine limits for the "total" field in the first case and the "delta" field in the second one. 

```python
tables = {"simple_table": data}
checklist = [
    ("simple_table", m.CountTotal(), {"total": (1, 1e6)}),
    ("simple_table", m.CountZeros("column_1"), {"delta": (0, 0.3)})
]
```
Then you can use **Report** just as follows
```python
report = Report(tables=tables, checklist=checklist, engine='pandas')
```

Example of the report resulting dataframe:

<img src="https://drive.google.com/uc?id=16vehJx6HWJGlmfFaY_gjO5oL2FBOZUe_"
     alt="Report dataframe"
     style="display: block; margin-right: auto; margin-left: auto; width: 88%" />

There is a more detailed example where the key functionality of the package is presented:\
https://github.com/uberkinder/Pure-Data/blob/usage_example/examples/simple_example.ipynb
