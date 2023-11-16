module Main
import Metrics::Maintainability;
import Metrics::Volume;
import Metrics::UnitTesting;
import Metrics::UnitSize;
import Metrics::Duplication;
import Metrics::UnitComplexity;

import IO;
import lang::java::m3::Core;
import lang::java::m3::AST;
// import DateTime;

void main(loc projectLoc) {
    // DateTime start = now();
    println("Maintainability scores for smallsql project");
    println("------------------------------------------\n");

    println("Volume:");
    println("-------");
    println("LOC: <LOC(projectLoc)>");
    println("Volume ranking: <volumeScore(LOC(projectLoc))>\n");

    println("Unit Size:");
    println("----------");
    println("Unit Size risk profile: <normalizeRisks(getUnitsRisk(LOCUnits(projectLoc)))>");
    println("Unit Size ranking: <unitSizeScore(normalizeRisks(getUnitsRisk(LOCUnits(projectLoc))))>\n");

    println("Unit Complexity:");
    println("-------");
    println("Unit Complexity risk profile: <normalizeRisks(unitsComplexityRisk(projectLoc))>");
    println("Unit Complexity ranking: <unitsComplexityScore(normalizeRisks(unitsComplexityRisk(projectLoc)))>\n");

    println("Duplication:");
    println("----------");
    println("Duplication profile: <findDuplicates(projectLoc)>");
    println("Duplication ranking: <duplicationScore(findDuplicates(projectLoc))>\n");

    println("Unit Testing:");
    println("-------------");
    println("Number of assert statements per method: <getUnitsCategories(assertsInUnits(projectLoc))>");
    println("Unit Testing ranking: <unitTestingScore(normalizeScores(getUnitsCategories(assertsInUnits(projectLoc))))>\n");

    println("Analysability:");
    println("-------");
    println("Analysability ranking: <analysability(projectLoc)>\n");

    println("Testability:");
    println("-------");
    println("Testability ranking: <testability(projectLoc)>\n");

    println("Stability:");
    println("-------");
    println("Stability ranking: <stability(projectLoc)>\n");

    println("Changeability:");
    println("-------");
    println("Changeability ranking: <changeability(projectLoc)>\n");

    println("Maintainability:");
    println("-------");
    println("Maintainability ranking: <maintainability(projectLoc)>\n");

    // end := now();
    // elapsed := end - start;
    // println("Runtime: ", elapsed);
}