module Main
import Metrics::Maintainability;
import Metrics::Volume;
import Metrics::UnitTesting;
import Metrics::UnitSize;
import Metrics::UnitComplexity;

import IO;
import List;
import Set;
import Map;
import String;
import lang::java::m3::Core;
import lang::java::m3::AST;

void main() {
    println("Maintainability scores for smallsql project");
    println("------------------------------------------\n");

    println("Volume:");
    println("-------");
    println("LOC: <linesOfCodeProject(|project://smallsql0.21_src|)>");
    println("Volume ranking: <volumeScore(LOC(|project://smallsql0.21_src|))>\n");

    println("Unit Size:");
    println("----------");
    println("Unit Size risk profile: <getUnitsRisk(LOCUnits(|project://smallsql0.21_src|))>");
    println("Unit Size ranking: <unitSizeScore(normalizeRisks(getUnitsRisk(LOCUnits(|project://smallsql0.21_src|))))>\n");

    println("Unit Complexity:");
    println("-------");
    println("Unit Complexity: <cyclomaticComplexity(|project://smallsql0.21_src|)>");
    println("Unit Complexity ranking: <unitComplexityScore(cyclomaticComplexity(|project://smallsql0.21_src|))>\n");

    // println("Duplication:");
    // println("----------");
    // println("Duplication profile: <getDuplication(|project://smallsql0.21_src))>");
    // println("Duplication ranking: <duplicationScore(getDuplication(|project://smallsql0.21_src|))>\n");


    println("Unit Testing:");
    println("-------------");
    println("Number of assert statements per method: <getUnitsCategories(assertsInUnits(|project://smallsql0.21_src|))>");
    println("Unit Testing ranking: <unitTestingScore(normalizeScores(getUnitsCategories(assertsInUnits(|project://smallsql0.21_src|))))>\n");

    println("Analysability:");
    println("-------");
    println("Analysability ranking: <analysability(|project://smallsql0.21_src|)>\n");

    println("Testability:");
    println("-------");
    println("Testability ranking: <testability(|project://smallsql0.21_src|)>\n");

    println("Stability:");
    println("-------");
    println("Stability ranking: <stability(|project://smallsql0.21_src|)>\n");

    println("Changeability:");
    println("-------");
    println("Changeability ranking: <changeability(|project://smallsql0.21_src|)>\n");

    println("Maintainability:");
    println("-------");
    println("Maintainability ranking: <maintainability(|project://smallsql0.21_src|)>\n");

}