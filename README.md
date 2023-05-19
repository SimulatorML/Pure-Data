# Pure Data
Developed by students of the [Simulator ML (Karpov.Courses)](https://karpov.courses/simulator-ml)

Pure Data is a framework designed to help with solving the problem of data quality. 
Pure Data framework include:
* list of different metrics that you can use to check the accuracy of the data;
* Report class with which you can iterate through a list of metrics and eventually get some summary information about which metrics pass, fail, or drop with errors.

## Launch
```bash
git clone https://github.com/uberkinder/Pure-Data.git
```

## Key Functionality
There are plenty of metrics that you can use to control your data for accuracy and reliability.\
Metrics:
* CountTotal
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

You can either just apply metrics you need to your data or use Report class: create a checklist with metrics you'd like to check and get summary information ofmetrics results.

## Usage
There is a simple example where the key functionality of the package is presented:\
https://github.com/uberkinder/Pure-Data/blob/usage_example/examples/simple_example.ipynb





