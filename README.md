# TVac-Jitter-Analysis
| Title | Function |
| -------- | --------- |
| readTVACdata | Allows user to choose TVAC environment. Correlates all filenamess included in that environment. Filter out acquisitions where there were adjustments or stage moves. Calls jitterMag function and creates histogram. |
| jitterMag | Takes in the data from each acquisition. Subtracts moving average from each data point and takes absolute value. Returns the average jitter magnitude for the X and Y angles. |
