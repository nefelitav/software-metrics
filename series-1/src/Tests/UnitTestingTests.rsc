module Tests::UnitTestingTests

import Metrics::UnitTesting;

// Tests on TestProject
test bool testGetUnitsCategoriesTestProject() {
    return getUnitsCategories(assertsInUnits(|project://TestProject/src/test|)) == ("high":1,"moderate":0,"low":1,"veryHigh":0);
}
test bool testNormalizeScoresTestProject() {
    return normalizeScores(getUnitsCategories(assertsInUnits(|project://TestProject/src/test|))) == ("high":50,"moderate":0,"low":50,"veryHigh":0);
}
test bool testUnitSizeScoreTestProject() {
    return unitTestingScore(normalizeScores(getUnitsCategories(assertsInUnits(|project://TestProject/src/test|)))) == "++";
}

// Tests on smallsql
test bool testGetUnitsCategoriesSmallsql() {
    return getUnitsCategories(assertsInUnits(|project://smallsql0.21_src/src/smallsql/junit|)) == ("high":20,"moderate":62,"low":76,"veryHigh":18);
}
test bool testNormalizeScoresSmallsql() {
    return normalizeScores(getUnitsCategories(assertsInUnits(|project://smallsql0.21_src/src/smallsql/junit|))) == ("high":11,"moderate":35,"low":43,"veryHigh":10);
}
test bool testUnitSizeScoreSmallsql() {
    return unitTestingScore(normalizeScores(getUnitsCategories(assertsInUnits(|project://smallsql0.21_src/src/smallsql/junit|)))) == "++";
}