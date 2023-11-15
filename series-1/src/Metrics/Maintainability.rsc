module Metrics::Maintainability

import IO;
import List;
import Set;
import Map;
import String;
import util::Math;
import lang::java::m3::Core;
import lang::java::m3::AST;

import Metrics::Volume;
import Metrics::UnitSize;
import Metrics::UnitComplexity;
import Metrics::Duplication;
import Metrics::UnitTesting;

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
        numerize(duplicationScore(findDuplicates(projectLoc))) +
        numerize(unitSizeScore(normalizeRisks(getUnitsRisk(LOCUnits(projectLoc)))));
    return stringify(floor(score/4));
}
str changeability(loc projectLoc) {
    int score = 
        numerize(unitComplexityScore(getUnitsRisk(cyclomaticComplexity(projectLoc), projectLoc))) +
        numerize(duplicationScore(findDuplicates(projectLoc)));
    return stringify(floor(score/2));
}
str stability(loc projectLoc) {
    return unitTestingScore(normalizeScores(getUnitsCategories(assertsInUnits(projectLoc))));
}
str testability(loc projectLoc) {
    int score = 
        numerize(unitComplexityScore(getUnitsRisk(cyclomaticComplexity(projectLoc), projectLoc))) +
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
