module Tests::UnitComplexityTests

import Metrics::UnitComplexity;
import Metrics::UnitSize;

// Tests on TestProject
test bool testUnitRiskTestProject() {
    return unitsComplexityRisk(|project://TestProject|) == ("veryHighRisk":304,"noRisk":65,"highRisk":124,"moderateRisk":64);
}
test bool testNormalizedUnitRiskTestProject() {
    return normalizeRisks(unitsComplexityRisk(|project://TestProject|)) == ("veryHighRisk":55,"noRisk":12,"highRisk":22,"moderateRisk":11);
}
test bool testCyclomaticScoreTestProject() {
    return unitsComplexityScore(normalizeRisks(unitsComplexityRisk(|project://TestProject|))) == "--";
}

// Tests on smallsql
test bool testUnitRiskSmallSQLProject() {
    return unitsComplexityRisk(|project://smallsql0.21_src|) == ("veryHighRisk":2500,"noRisk":14821,"highRisk":1930,"moderateRisk":1834);
}
test bool testNormalizedUnitRiskSmallSQLProject() {
    return normalizeRisks(unitsComplexityRisk(|project://smallsql0.21_src|)) == ("veryHighRisk":12,"noRisk":70,"highRisk":9,"moderateRisk":9);
}
test bool testCyclomaticScoreSmallSQLProject() {
    return unitsComplexityScore(normalizeRisks(unitsComplexityRisk(|project://smallsql0.21_src|))) == "--";
}