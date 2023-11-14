module Tests::UnitSizeTests

import Metrics::UnitSize;

// Tests on TestProject
test bool testLocUnitsTestProject() {
    return LOCUnits(|project://TestProject|) == (|java+compilationUnit:///src/test/java/com/example/AppTest.java|(379,207,<23,4>,<31,5>):5,|java+compilationUnit:///src/test/java/com/example/AppTest.java|(205,168,<13,4>,<21,5>):4,|java+compilationUnit:///src/test/java/com/example/AppTest.java|(592,307,<33,4>,<46,5>):11,|java+compilationUnit:///src/main/java/com/example/App.java|(355,1633,<21,4>,<65,5>):40,|java+compilationUnit:///src/main/java/com/example/App.java|(73,276,<9,4>,<19,5>):5);
}
test bool testGetUnitsRiskTestProject() {
    return getUnitsRisk(LOCUnits(|project://TestProject|)) == ("veryHighRisk":0,"noRisk":3,"highRisk":1,"moderateRisk":1);
}
test bool testNormalizeRisksTestProject() {
    return normalizeRisks(getUnitsRisk(LOCUnits(|project://TestProject|))) == ("veryHighRisk":0,"noRisk":60,"highRisk":20,"moderateRisk":20);
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