module Metrics::Volume

import IO;
import List;
import Set;
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

// number of lines of code without block and line comments and blank lines
int LOC(loc projectLoc) {
    return (linesOfCodeProject(projectLoc) - blankLinesProject(projectLoc) - commentsProject(projectLoc));
}

// number of lines of code of a file
int linesOfCodeFile(loc fileLoc) {
    int fileSize = size(readFileLines(fileLoc));
    return fileSize;
}

// number of lines of code of a project
int linesOfCodeProject(loc projectLoc) {
    M3 model = createM3FromMavenProject(projectLoc);
    int sumSize = 0;
    // iterate over files of project
    for (file <- files(model.containment)) {
        sumSize += linesOfCodeFile(file.top);
    }
    return sumSize;
}

// number of blank lines of a file
int blankLinesFile(loc fileLoc) {
    int blankLines = 0;
    for (line <- readFileLines(fileLoc)) {
        if (trim(line) == "") {
            blankLines += 1;   
        }
    }
    return blankLines;
}

// number of blank lines of a project
int blankLinesProject(loc projectLoc) {
    M3 model = createM3FromMavenProject(projectLoc);
    int sumBlankLines = 0;
    // iterate over files of a project
    for (file <- files(model.containment)) {
        sumBlankLines += blankLinesFile(file.top);
    }
    return sumBlankLines;
}

// number of line and block comments of a file
int commentsFile(loc fileLoc) {
    int lineComments = 0;
    int blockComments = 0;
    bool insideBlockComment = false;
    // iterate over lines of file
    for (line <- readFileLines(fileLoc)) {
        if (startsWith(trim(line), "/*") || (insideBlockComment == true)) {
            // inside the block comment
            insideBlockComment = true;
            blockComments += 1;  
            if (endsWith(trim(line), "*/")) {
                // outside the block comment
                insideBlockComment = false; 
            }
        // if there is a line comment inside a block comment we do not add it to the line comments
        } else if (startsWith(trim(line), "//")) {
            lineComments += 1;   
        }
    }
    // sum up line comments and block comments
    return lineComments + blockComments;
}

// number of line and block comments of a project
int commentsProject(loc projectLoc) {
    M3 model = createM3FromMavenProject(projectLoc);
    int sumComments = 0;
    // iterate over files of a project
    for (file <- files(model.containment)) {
        sumComments += commentsFile(file.top);
    }
    return sumComments;
}

// calculate rating based on LOC
str volumeScore(int LOC) {
    return 	((LOC >= 0 && LOC < 66000) ? "++" : "") +
  			((LOC >= 66000 && LOC < 246000) ? "+" : "") +
  			((LOC >= 246000 && LOC < 665000) ? "o" : "") + 
  			((LOC >= 665000 && LOC < 1310000) ? "-" : "") + 
  			((LOC > 1310000) ? "--" : "");
}