module Tests::MaintainabilityTests

import Metrics::Maintainability;

// Tests on TestProject
test bool testAnalysabilityTestProject() {
    return analysability(|project://TestProject|) == "o";
}
test bool testChangeabilityTestProject() {
    return changeability(|project://TestProject|) == "--";
}
test bool testStabilityTestProject() {
    return stability(|project://TestProject|) == "++";
}
test bool testTestabilityTestProject() {
    return testability(|project://TestProject|) == "o";
}
test bool testMaintainabilityTestProject() {
    return maintainability(|project://TestProject|) == "o";
}

// Tests on smallsql
test bool testAnalysabilitySmallSQLProject() {
    return analysability(|project://smallsql0.21_src|) == "+";
}
test bool testChangeabilitySmallSQLProject() {
    return changeability(|project://smallsql0.21_src|) == "-";
}
test bool testStabilitySmallSQLProject() {
    return stability(|project://smallsql0.21_src|) == "++";
}
test bool testTestabilitySmallSQLProject() {
    return testability(|project://smallsql0.21_src|) == "o";
}
test bool testMaintainabilitySmallSQLProject() {
    return maintainability(|project://smallsql0.21_src|) == "+";
}