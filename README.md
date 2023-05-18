# Pure Data
Developed by students of the [Simulator ML (Karpov.Courses)](https://karpov.courses/simulator-ml)

Pure Data is a framework designed to help with solving the problem of data quality. 
Numerous metrics have been developed to check the accuracy of the data.

# Launch
```bash
git clone https://github.com/uberkinder/Pure-Data.git
```

## Key Functionality
There are plenty of metrics that you can use to control yourr data for accuracy and reliability.\
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

You can either just apply metrics you need to your data or use Report class.\
Report class provide opportunity to run a list of metrics and see some summary information about what metrics are passed, failed or dropped with error.

## Usage
There is a simple example where the key functionality of the package is presented:\
https://github.com/uberkinder/Pure-Data/blob/usage_example/examples/simple_example.ipynb





