/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class Stopwatch {
    global Stopwatch() {

    }
    global String getConsumedLimitsString() {
        return null;
    }
    global Map<String,Integer> getConsumedLimits() {
        return null;
    }
    global Map<String,Integer> getCurrentLimits() {
        return null;
    }
    global Integer getElapsedTime() {
        return null;
    }
    global String getElapsedTimeString() {
        return null;
    }
    global String getSavedMeasuresString() {
        return null;
    }
    global List<lib.Stopwatch.SavedMeasure> getSavedMeasures() {
        return null;
    }
    global void reset() {

    }
    global void saveAndReset(String name) {

    }
    global override String toString() {
        return null;
    }
global class SavedMeasure {
    global Map<String,Integer> consumedLimits {
        get;
        set;
    }
    global Integer elapsedTime {
        get;
        set;
    }
    global String name {
        get;
        set;
    }
    global SavedMeasure() {

    }
    global SavedMeasure(String name, Integer elapsedTime, Map<String,Integer> consumedLimits) {

    }
}
}
