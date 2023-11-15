module Tests::UnitComplexityTests

import Metrics::UnitComplexity;
import Metrics::UnitSize;

// Tests on TestProject
test bool testCyclomaticComplexityTestProject() {
    return cyclomaticComplexity(|project://TestProject|) == ("veryHighRisk":0,"noRisk":45,"highRisk":0,"moderateRisk":0);
}
test bool testNormalizedCyclomaticComplexityTestProject() {
    return normalizeRisks(cyclomaticComplexity(|project://TestProject|)) == ("veryHighRisk":0,"noRisk":100,"highRisk":0,"moderateRisk":0);
}
test bool testCyclomaticScoreTestProject() {
    return unitComplexityScore(normalizeRisks(cyclomaticComplexity(|project://TestProject|))) == "++";
}

// Tests on smallsql
test bool testCyclomaticComplexitySmallSQL() {
    return cyclomaticComplexity(|project://smallsql0.21_src|) == ("veryHighRisk":2500,"noRisk":14821,"highRisk":1930,"moderateRisk":1834);
}
test bool testNormalizedCyclomaticComplexitySmallSQL() {
    return normalizeRisks(cyclomaticComplexity(|project://smallsql0.21_src|)) == ("veryHighRisk":11,"noRisk":70,"highRisk":9,"moderateRisk":8);
}
test bool testCyclomaticScoreSmallSQL() {
    return unitComplexityScore(normalizeRisks(cyclomaticComplexity(|project://smallsql0.21_src|))) == "--";
}