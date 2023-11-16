module Tests::DuplicationTests

import Metrics::Duplication;

// Tests on TestProject
test bool testFindDuplicateLOCTestProject() {
    return findDuplicateLOC(|project://TestProject|) == 480;
}
test bool testFindDuplicatesTestProject() {
    return findDuplicates(|project://TestProject|) == 84;
}
test bool testFindDuplicateScoreTestProject() {
    return duplicationScore(findDuplicates(|project://TestProject|)) == "--";
}

// Tests on smallsql
test bool testFindDuplicateLOCSmallSQLProject() {
    return findDuplicateLOC(|project://smallsql0.21_src|) == 1510;
}
test bool testFindDuplicatesSmallSQLProject() {
    return findDuplicates(|project://smallsql0.21_src|) == 6;
}
test bool testFindDuplicateScoreSmallSQLProject() {
    return duplicationScore(findDuplicates(|project://smallsql0.21_src|)) == "o";
}