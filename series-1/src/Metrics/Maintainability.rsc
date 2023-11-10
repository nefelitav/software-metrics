module Metrics::Maintainability

import IO;
import List;
import Set;
import Map;
import String;
import lang::java::m3::Core;
import lang::java::m3::AST;

import Metrics::Volume;
import Metrics::UnitSize;
// import Metrics::UnitComplexity;
// import Metrics::Duplication;
import Metrics::UnitTesting;

// Halstead Volume (HV)
// Cyclomatic Complexity (CC) 
// the average number of lines of code per module (LOC)
// and optionally the percentage of comment lines per module (COM)
// 171−5.2ln(HV)−0.23CC−16.2ln(LOC)+50.0sin√(2.46 ∗ COM)
// the higher the score, the more maintainable 


int main(int testArgument=0) {
    println("argument: <testArgument>");
    return testArgument;
}

int numerize(str ranking) {
    switch(ranking) {
        case "++": return 0;
        case "+": return 1;
        case "o": return 2;
        case "-": return 3;
        case "--": return 4;
    }
    return 4;
}

str stringify(int ranking) {
    switch(ranking) {
        case 0: return "++";
        case 1: return "+";
        case 2: return "o";
        case 3: return "-";
        case 4: return "--";
    }
    return "--";
}

str analysability(loc projectLoc) {
    int score = 
        numerize(volumeScore(LOC(projectLoc))) +
        numerize(unitTestingScore(normalizeScores(getUnitsCategories(assertsInUnits(projectLoc))))) +
        numerize(duplicationScore()) +
        numerize(unitSizeScore(normalizeRisks(getUnitsRisk(LOCUnits(projectLoc)))));
    return stringify(floor(score/4));
}
str changeability(loc projectLoc) {
    int score = 
        numerize(unitComplexityScore()) +
        numerize(duplicationScore());
    return stringify(floor(score/2));
}
str stability(loc projectLoc) {
    return unitTestingScore();
}
str testability(loc projectLoc) {
    int score = 
        numerize(unitComplexityScore()) +
        numerize(unitTestingScore(normalizeScores(getUnitsCategories(assertsInUnits(projectLoc))))) +
        numerize(unitSizeScore(normalizeRisks(getUnitsRisk(LOCUnits(projectLoc)))));
    return stringify(floor(score/3));
}
str maintainability(loc projectLoc) {
    int score = 
        numerize(analysability(projectLoc)) +
        numerize(changeability(projectLoc)) +
        numerize(stability(projectLoc)) +
        numerize(testability(projectLoc));
    return stringify(floor(score/4));
}
