# Pure Data
Developed by students of the [Simulator ML (Karpov.Courses)](https://karpov.courses/simulator-ml)

Pure Data is a framework designed to help solve the problem of data quality.
The Pure Data framework includes:
* a list of different metrics that you can use to check the accuracy of the data;
* Report class, with which you can iterate through a list of metrics and get some summary information about which metrics pass, fail, or drop with errors.

## Launch
```bash
git clone https://github.com/uberkinder/Pure-Data.git
```

## Key Functionality
There are plenty of metrics that you can use to control your data's accuracy and reliability.\
Metrics:
* CountTota
* CountZeros
* CountNull
* CountDuplicates
* CountValue
* CountBelowValue
* CountBelowColumn
* CountRatioBelow
* CountCB
* CountLag
* CountGreaterValue
* CountValueInRequiredSet
* CountValueInBounds
* CountExtremeValuesFormula
* CountExtremeValuesQuantile
* CountLastDayRows
* CountFewLastDayRows
* CheckAdversarialValidation

You can either just apply the metrics you need to your data or use the Report class to create a checklist with metrics you'd like to check and get summary information about the metrics results.
## Usage
Below is a brief example of how you can use Pure to verify your data.

Import Report class and metrics that you want to apply.
```python
from pure.report import Report
from pure.metrics import CountTotal, CountZeros
```
Firstly, initialize tables with names and data you want to work with, and create a checklist with metrics.

Metric returns a dict with some meta fields. In the checklist, you can specify which metric result fields you want to control within certain limits.
In this example, we will determine limits for the "total" field in the first case and the "delta" field in the second one. 
  
```python
tables = {"simple_table": data}
checklist = [("simple_table", CountTotal(), {"total": (1, 1e6)}),
             ("simple_table", CountZeros("column_1"), {"delta": (0, 0.3)})]
```
Then you can use Report just as follows
```python
report = Report(checklist=checklist, engine='pandas')
result = report.fit(tables)
```

There is a more detailed example where the key functionality of the package is presented:\
https://github.com/uberkinder/Pure-Data/blob/usage_example/examples/simple_example.ipynb





