module Tests::UnitSizeTests

import Metrics::UnitSize;

// Tests on TestProject
test bool testLocUnitsTestProject() {
    return LOCUnits(|project://TestProject|) == (|java+compilationUnit:///src/main/java/com/example/App.java|(355,1633,<21,4>,<65,5>):40,|java+compilationUnit:///src/main/java/com/example/App.java|(73,276,<9,4>,<19,5>):5);
}
test bool testGetUnitsRiskTestProject() {
    return getUnitsRisk(LOCUnits(|project://TestProject|)) == ("veryHighRisk":0,"noRisk":1,"highRisk":1,"moderateRisk":0);
}
test bool testNormalizeRisksTestProject() {
    return normalizeRisks(getUnitsRisk(LOCUnits(|project://TestProject|))) == ("veryHighRisk":0,"noRisk":50,"highRisk":50,"moderateRisk":0);
}
test bool testUnitSizeScoreTestProject() {
    return unitSizeScore(normalizeRisks(getUnitsRisk(LOCUnits(|project://TestProject|)))) == "--";
}

// Tests on smallsql
test bool testGetUnitsRiskSmallsql() {
    return getUnitsRisk(LOCUnits(|project://smallsql0.21_src|)) == ("veryHighRisk":50,"noRisk":1950,"highRisk":179,"moderateRisk":221);
}
test bool testNormalizeRisksSmallsql() {
    return normalizeRisks(getUnitsRisk(LOCUnits(|project://smallsql0.21_src|))) == ("veryHighRisk":2,"noRisk":81,"highRisk":7,"moderateRisk":9);
}
test bool testUnitSizeScoreSmallsql() {
    return unitSizeScore(normalizeRisks(getUnitsRisk(LOCUnits(|project://smallsql0.21_src|)))) == "-";
}