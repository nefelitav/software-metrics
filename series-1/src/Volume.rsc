module Volume

import IO;
import List;
import Set;
// import Map;
import String;
import lang::java::m3::Core;
import lang::java::m3::AST;

// Volume: The overall volume of the source code influences the analysability of the system
// 1) LOC: which counts all lines of source code that are not line/block comments or blank lines.
// 2) Man years via backfiring function points: to make it language independent
//---------------------------------
// rank     MY        Java (KLOC) -
//---------------------------------
// ++       0 − 8     0-66        -
// +        8 − 30    66-246      -
// o        30 − 80   246-665     -
// -        80 − 160  655-1,310   -
// --       > 160     > 1,310     -
//---------------------------------

int main(int testArgument=0) {
    println("argument: <testArgument>");
    return testArgument;
}

int LOC(loc projectLoc) {
    return (linesOfCodeProject(projectLoc) - countBlankLinesProject(projectLoc) - countCommentsProject(projectLoc));
}

int linesOfCodeFile(loc fileLoc) {
    int fileSize = size(readFileLines(fileLoc));
    return fileSize;
}

int linesOfCodeProject(loc projectLoc) {
    M3 model = createM3FromMavenProject(projectLoc);
    int sumSize = 0;
    for (file <- files(model.containment)) {
        sumSize += linesOfCodeFile(file.top);
    }
    return sumSize;
}

public int countBlankLinesFile(loc fileLoc) {
    int blankLines = 0;
    for (line <- readFileLines(fileLoc)) {
        if (trim(line) == "") {
            blankLines += 1;   
        }
    }
    return blankLines;
}

int countBlankLinesProject(loc projectLoc) {
    M3 model = createM3FromMavenProject(projectLoc);
    int sumBlankLines = 0;
    for (file <- files(model.containment)) {
        sumBlankLines += countBlankLinesFile(file.top);
    }
    return sumBlankLines;
}

public int countCommentsFile(loc fileLoc) {
    int lineComments = 0;
    int blockComments = 0;
    bool insideBlockComment = false;
    for (line <- readFileLines(fileLoc)) {
        if (startsWith(trim(line), "/*") || (insideBlockComment == true)) {
            insideBlockComment = true;
            blockComments += 1;  
            if (endsWith(trim(line), "*/")) {
                insideBlockComment = false; 
            }
        } else if (startsWith(trim(line), "//")) {
            lineComments += 1;   
        }
    }
    return lineComments + blockComments;
}

int countCommentsProject(loc projectLoc) {
    M3 model = createM3FromMavenProject(projectLoc);
    int sumComments = 0;
    for (file <- files(model.containment)) {
        sumComments += countCommentsFile(file.top);
    }
    return sumComments;
}

public str manYears(int LOC) {
    return 	((LOC >= 0 && LOC < 66000) ? "++" : "") +
  			((LOC >= 66000 && LOC < 246000) ? "+" : "") +
  			((LOC >= 246000 && LOC < 665000) ? "o" : "") + 
  			((LOC >= 665000 && LOC < 1310000) ? "-" : "") + 
  			((LOC > 1310000) ? "--" : "");
}