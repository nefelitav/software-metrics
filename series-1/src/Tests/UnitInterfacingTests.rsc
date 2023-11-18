module Tests::UnitInterfacingTests

import Metrics::UnitInterfacing;
import Lib::Utilities;

// Tests on TestProject
test bool testUnitParamsTestProject() {
    // return unitsParams(|project://TestProject|) == ;
}
test bool testGetUnitsRiskInterfacingTestProject() {
    // return getUnitsInterfacingRisk(unitsParams(|project://TestProject|), |project://TestProject|) == ;
}
test bool testNormalizeRisksInterfacingTestProject() {
    // return normalizeRisks(getUnitsInterfacingRisk(unitsParams(|project://TestProject|), |project://TestProject|)) == ;
}
test bool testUnitInterfacingScoreTestProject() {
    // return unitInterfacingScore(normalizeRisks(getUnitsInterfacingRisk(unitsParams(|project://TestProject|), |project://TestProject|))) == ;
}

// Tests on smallsql
test bool testUnitParamsSmallsql() {
    // return unitsParams(|project://smallsql0.21_src|) == ;
}
test bool testGetUnitsRiskInterfacingSmallsql() {
    // return getUnitsInterfacingRisk(unitsParams(|project://smallsql0.21_src|), |project://smallsql0.21_src|) == ;
}
test bool testNormalizeRisksInterfacingSmallsql() {
    // return normalizeRisks(getUnitsInterfacingRisk(unitsParams(|project://smallsql0.21_src|), |project://smallsql0.21_src|)) == ;
}
test bool testUnitInterfacingScoreSmallsql() {
    // return unitInterfacingScore(normalizeRisks(getUnitsInterfacingRisk(unitsParams(|project://smallsql0.21_src|), |project://smallsql0.21_src|))) == ;
}