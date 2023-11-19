module Tests::UnitSizeTests

import Metrics::UnitSize;
import Lib::Utilities;

// Tests on TestProject
test bool testLocUnitsTestProject() {
    return LOCUnits(|project://TestProject|) == (
  |java+compilationUnit:///src/test/java/com/example/AppTest.java|(379,207,<23,4>,<31,5>):5,
  |java+compilationUnit:///src/main/java/com/example/App.java|(1994,1609,<67,4>,<132,5>):64,
  |java+compilationUnit:///src/main/java/com/example/App.java|(6771,7798,<262,4>,<575,5>):304,
  |java+compilationUnit:///src/main/java/com/example/App.java|(3609,3157,<134,4>,<261,5>):124,
  |java+compilationUnit:///src/test/java/com/example/AppTest.java|(205,168,<13,4>,<21,5>):4,
  |java+compilationUnit:///src/test/java/com/example/AppTest.java|(592,307,<33,4>,<46,5>):11,
  |java+compilationUnit:///src/main/java/com/example/App.java|(355,1633,<21,4>,<65,5>):40,
  |java+compilationUnit:///src/main/java/com/example/App.java|(73,276,<9,4>,<19,5>):5
);
}
test bool testGetUnitsRiskTestProject() {
    return getUnitsRisk(LOCUnits(|project://TestProject|)) == ("lowRisk":4,"veryHighRisk":3,"highRisk":1,"moderateRisk":0);
}
test bool testNormalizeRisksTestProject() {
    return normalizeRisks(getUnitsRisk(LOCUnits(|project://TestProject|))) == ("lowRisk":50,"veryHighRisk":38,"highRisk":13,"moderateRisk":0);
}
test bool testUnitSizeScoreTestProject() {
    return unitSizeScore(normalizeRisks(getUnitsRisk(LOCUnits(|project://TestProject|)))) == "--";
}

// Tests on smallsql
test bool testGetUnitsRiskSmallsql() {
    return getUnitsRisk(LOCUnits(|project://smallsql0.21_src|)) == ("lowRisk":2080,"veryHighRisk":29,"highRisk":80,"moderateRisk":211);
}
test bool testNormalizeRisksSmallsql() {
    return normalizeRisks(getUnitsRisk(LOCUnits(|project://smallsql0.21_src|))) == ("lowRisk":87,"veryHighRisk":1,"highRisk":3,"moderateRisk":9);
}
test bool testUnitSizeScoreSmallsql() {
    return unitSizeScore(normalizeRisks(getUnitsRisk(LOCUnits(|project://smallsql0.21_src|)))) == "-";
}