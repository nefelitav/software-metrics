module Tests::VolumeTests

import Metrics::Volume;

// Tests on TestProject
test bool testLinesOfCodeFileTestProject() {
    return linesOfCodeFile(|project://TestProject/src/main/java/com/example/App.java|) == 576;
}
test bool testBlankLinesFileTestProject() {
    return blankLinesFile(|project://TestProject/src/main/java/com/example/App.java|) == 20;
}
test bool testCommentsFileTestProject() {
    return commentsFile(|project://TestProject/src/main/java/com/example/App.java|) == 15;
}
test bool testLOCProjectTestProject() {
    return LOC(|project://TestProject|) == 569;
}
test bool testLinesOfCodeProjectTestProject() {
    return linesOfCodeProject(|project://TestProject|) == 623;
}
test bool testBlankLinesProjectTestProject() {
    return blankLinesProject(|project://TestProject|) == 24;
}
test bool testCommentsProjectTestProject() {
    return commentsProject(|project://TestProject|) == 30;
}
test bool testVolumeScoreTestProject() {
    return volumeScore(LOC(|project://TestProject|)) == "++";
}

// Tests on smallsql
test bool testLinesOfCodeFileSmallsql() {
    return linesOfCodeFile(|project://smallsql0.21_src/src/smallsql/database/Column.java|) == 182;
}
test bool testBlankLinesFileSmallsql() {
    return blankLinesFile(|project://smallsql0.21_src/src/smallsql/database/Column.java|) == 35;
}
test bool testCommentsFileSmallsql() {
    return commentsFile(|project://smallsql0.21_src/src/smallsql/database/Column.java|) == 37;
}
test bool testLOCProjectSmallsql() {
    return LOC(|project://smallsql0.21_src|) == 24004;
}
test bool testLinesOfCodeProjectSmallsql() {
    return linesOfCodeProject(|project://smallsql0.21_src|) == 38423;
}
test bool testBlankLinesProjectSmallsql() {
    return blankLinesProject(|project://smallsql0.21_src|) == 5394;
}
test bool testCommentsProjectSmallsql() {
    return commentsProject(|project://smallsql0.21_src|) == 9025;
}
test bool testVolumeScoreSmallsql() {
    return volumeScore(LOC(|project://smallsql0.21_src|)) == "++";
}