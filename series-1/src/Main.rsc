module Main

import Metrics::Maintainability;
import Metrics::Volume;
import Metrics::UnitTesting;
import Metrics::UnitSize;
import Metrics::Duplication;
import Metrics::UnitComplexity;
import Metrics::Comments;
import Lib::Utilities;

import IO;
import lang::java::m3::Core;
import lang::java::m3::AST;
import DateTime;

void main(loc projectLoc) {
    datetime begin = now();
    println("Calculating score for: <projectLoc>. Please wait...");
    int linesOfCode = LOC(projectLoc);
    str volumeRanking = volumeScore(LOC(projectLoc));
    map[str, int] unitSize = normalizeRisks(getUnitsRisk(LOCUnits(projectLoc)));
    str unitSizeRanking = unitSizeScore(normalizeRisks(getUnitsRisk(LOCUnits(projectLoc))));
    int duplicates = findDuplicates(projectLoc);
    str duplicatesRanking = duplicationScore(findDuplicates(projectLoc));
    map[str, int] UnitComplexityRisk = normalizeRisks(unitsComplexityRisk(projectLoc));
    str unitsComplexityRanking = unitsComplexityScore(normalizeRisks(unitsComplexityRisk(projectLoc)));
    map[str, int] unitTests = normalizeScores(getUnitsCategories(assertsInUnits(projectLoc)));
    str unitTestScore = unitTestingScore(normalizeScores(getUnitsCategories(assertsInUnits(projectLoc))));
    map[str, int] commentsRisk = normalizeRisks(unitsCommentsRisk(projectLoc));
    str commentsRiskRanking = commentsRanking(commentsRisk);
    str analysabilityRanking = analysability(projectLoc);
    str testabilityRanking = testability(projectLoc);
    str stabilityRanking = stability(projectLoc);
    str changeabilityRanking = changeability(projectLoc);
    str maintainabilityRanking = maintainability(projectLoc);

    println("\n------------------------------------------\n");
    println("Maintainability scores for <projectLoc> project");
    println("------------------------------------------\n");

    println("Volume:");
    println("-------");
    println("Lines of Code: <linesOfCode>");
    println("Volume ranking: <volumeRanking>\n");

    println("Unit Size:");
    println("----------");
    println("Unit Size risk profile (in percentage): <unitSize>");
    println("Unit Size ranking: <unitSizeRanking>\n");

    println("Unit Complexity:");
    println("-------");
    println("Unit Complexity risk profile (in percentage): <UnitComplexityRisk>");
    println("Unit Complexity ranking: <unitsComplexityRanking>\n");

    println("Duplication:");
    println("----------");
    println("Duplication profile (in percentage): <duplicates>");
    println("Duplication ranking: <duplicatesRanking>\n");

    println("Unit Testing:");
    println("-------------");
    println("Number of assert statements per method: <unitTests>");
    println("Unit Testing ranking: <unitTestScore>\n");

    println("Comments:");
    println("-------------");
    println("Comments risk (in percentage): <commentsRisk>");
    println("Comments risk ranking: <commentsRiskRanking>\n");

    println("Analysability:");
    println("-------");
    println("Analysability ranking: <analysabilityRanking>\n");

    println("Testability:");
    println("-------");
    println("Testability ranking: <testabilityRanking>\n");

    println("Stability:");
    println("-------");
    println("Stability ranking: <stabilityRanking>\n");

    println("Changeability:");
    println("-------");
    println("Changeability ranking: <changeabilityRanking>\n");

    println("Maintainability:");
    println("-------");
    println("Maintainability ranking: <maintainabilityRanking>\n");

    println("Scalability:");
    datetime end = now();
    interval runTime = createInterval(begin, end);
    print("Duration: \<years, months, days, hours, minutes, seconds, milliseconds\>: ");
    println("<createDuration(runTime)>\n");

    println("------------------------------------------\n");
}