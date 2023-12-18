module Tests::UnitInterfacingTests

import Metrics::UnitInterfacing;
import Lib::Utilities;

// Tests on TestProject
test bool testUnitParamsTestProject() {
    return unitsParams(|project://TestProject|) == (
  |java+compilationUnit:///src/test/java/com/example/AppTest.java|(379,207,<23,4>,<31,5>):0,
  |java+compilationUnit:///src/main/java/com/example/App.java|(1994,1609,<67,4>,<132,5>):0,
  |java+compilationUnit:///src/main/java/com/example/App.java|(6771,7798,<262,4>,<575,5>):0,
  |java+compilationUnit:///src/main/java/com/example/App.java|(3609,3157,<134,4>,<261,5>):0,
  |java+compilationUnit:///src/test/java/com/example/AppTest.java|(205,168,<13,4>,<21,5>):1,
  |java+compilationUnit:///src/test/java/com/example/AppTest.java|(592,307,<33,4>,<46,5>):0,
  |java+compilationUnit:///src/main/java/com/example/App.java|(355,1633,<21,4>,<65,5>):0,
  |java+compilationUnit:///src/main/java/com/example/App.java|(73,276,<9,4>,<19,5>):1
);
}
test bool testGetUnitsRiskInterfacingTestProject() {
    return getUnitsInterfacingRisk(unitsParams(|project://TestProject|), |project://TestProject|) == ("lowRisk":557,"veryHighRisk":0,"highRisk":0,"moderateRisk":0);
}
test bool testNormalizeRisksInterfacingTestProject() {
    return normalizeRisks(getUnitsInterfacingRisk(unitsParams(|project://TestProject|), |project://TestProject|)) == ("lowRisk":100,"veryHighRisk":0,"highRisk":0,"moderateRisk":0);
}
test bool testUnitInterfacingScoreTestProject() {
    return unitInterfacingScore(normalizeRisks(getUnitsInterfacingRisk(unitsParams(|project://TestProject|), |project://TestProject|))) == "++";
}

// Tests on smallsql
test bool testGetUnitsRiskInterfacingSmallsql() {
    return getUnitsInterfacingRisk(unitsParams(|project://smallsql0.21_src|), |project://smallsql0.21_src|) == ("lowRisk":18819,"veryHighRisk":35,"highRisk":162,"moderateRisk":2069);
}
test bool testNormalizeRisksInterfacingSmallsql() {
    return normalizeRisks(getUnitsInterfacingRisk(unitsParams(|project://smallsql0.21_src|), |project://smallsql0.21_src|)) == ("lowRisk":89,"veryHighRisk":0,"highRisk":1,"moderateRisk":10);
}
test bool testUnitInterfacingScoreSmallsql() {
    return unitInterfacingScore(normalizeRisks(getUnitsInterfacingRisk(unitsParams(|project://smallsql0.21_src|), |project://smallsql0.21_src|))) == "+";
}