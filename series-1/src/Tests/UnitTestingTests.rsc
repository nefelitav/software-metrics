module Tests::UnitTestingTests

import Metrics::UnitTesting;

// Tests on TestProject
test bool testCountAssertStatementsTestProject() {
    return countAssertStatements(|project://TestProject/src/main/java/com/example/App.java|) == 13;
}
test bool testGetUnitsCategoriesTestProject() {
    return getUnitsCategories(assertsInUnits(|project://TestProject|)) == ("high":0,"moderate":0,"low":1,"veryHigh":1);
}
test bool testNormalizeScoresTestProject() {
    return normalizeScores(getUnitsCategories(assertsInUnits(|project://TestProject|))) == ("high":0,"moderate":0,"low":50,"veryHigh":50);
}
test bool testUnitSizeScoreTestProject() {
    return unitTestingScore(normalizeScores(getUnitsCategories(assertsInUnits(|project://TestProject|)))) == "++";
}

// Tests on smallsql
test bool tesCountAssertStatementsSmallsql() {
    return countAssertStatements(|project://smallsql0.21_src/src/smallsql/database/Language/Language.java|) == 4;
}
test bool testGetUnitsCategoriesSmallsql() {
    return getUnitsCategories(assertsInUnits(|project://smallsql0.21_src|)) == ("high":20,"moderate":64,"low":81,"veryHigh":18);
}
test bool testNormalizeScoresSmallsql() {
    return normalizeScores(getUnitsCategories(assertsInUnits(|project://smallsql0.21_src|))) == ("high":10,"moderate":34,"low":44,"veryHigh":9);
}
test bool testUnitSizeScoreSmallsql() {
    return unitTestingScore(normalizeScores(getUnitsCategories(assertsInUnits(|project://smallsql0.21_src|)))) == "++";
}