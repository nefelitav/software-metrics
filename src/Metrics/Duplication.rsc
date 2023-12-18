module Metrics::Duplication

import util::Math;
import IO;
import List;
import Set;
import String;
import List;
import lang::java::m3::Core;
import lang::java::m3::AST;
import Metrics::Volume;
import Metrics::UnitSize;

// if block is not in map -> add it
//                        -> consecutive flag to false
// if block is in map -> increment the number of occurences
//                    -> if this block is following consecutively the original -> increment duplicate lines by 1
//                    -> if this block is not following consecutively the original -> increment duplicate lines by 6
//                    -> consecutive flag to true
tuple[map[str, int], bool, int] addToMap(map[str, int] blocks, str block, bool consecutive, int duplicateLOC) { 
    if (block in blocks) {
        // if consecutive
        if (consecutive) {
            duplicateLOC += 1;
        } else {
            // if not consecutive
            duplicateLOC += 6;
        }
        consecutive = true;
        blocks[block] += 1;
    } else {
        // if new block
        blocks[block] = 1;
        consecutive = false;
    }
    return <blocks, consecutive, duplicateLOC>;
}


// create blocks of 6, add it to map and count duplicate lines
tuple [map[str, int], int] createBlocks(tuple [map[str, int], int] result, loc fileLoc) {
    map[str, int] blocks = result[0];
    int duplicateLOC = result[1];
    list[str] lines = [];
    bool insideBlockComment = false;
    bool consecutive = false;
    // iterate over units
    for (str line <- readFileLines(fileLoc)) {
        // clean line
        line = trim(line);
        if (line != "" && !startsWith(line, "//")) {
            if (startsWith(line, "/*") || (insideBlockComment == true)) {
                // inside the block comment
                insideBlockComment = true;
                if (endsWith(line, "*/")) {
                    // outside the block comment
                    insideBlockComment = false; 
                }
            } else {
                lines += line;
                // if the lines are 6 it considered as a block and added to the map
                if (size(lines) == 6) {
                    // clean lines
                    str block = trim(lines[0]) + trim(lines[1]) + trim(lines[2]) + trim(lines[3]) + trim(lines[4]) + trim(lines[5]);
                    updatedVars = addToMap(blocks, block, consecutive, duplicateLOC);
                    blocks = updatedVars[0];
                    consecutive = updatedVars[1];
                    duplicateLOC = updatedVars[2];
                    lines = lines[1..6]; // remove the first line and make it ready to form next block
                }
            }
        }
    }
    return <blocks, duplicateLOC>;
}

// Find number of duplicated lines in a project
int findDuplicateLOC(loc projectLoc) {
    M3 model = createM3FromMavenProject(projectLoc);
    tuple [map[str, int], int] result = <(), 0>;
    // Iterate over files of project and create blocks
    for (file <- files(model.containment)) {
        result = createBlocks(result, file.top);
    }
    numberOfDuplicateLines = result[1];
    return numberOfDuplicateLines;
}

// find number of duplicated lines in a project
int findDuplicates(loc projectLoc) {
    int totalLines = LOC(projectLoc);
    int numberOfDuplicateLines = findDuplicateLOC(projectLoc);
    int percentageOfDuplicates = round ((toReal (numberOfDuplicateLines)) / (toReal (totalLines)) * 100.0);
    return percentageOfDuplicates;
}

// calculate ranking based on duplicateLOC
str duplicationScore(int percentageOfDuplicates) {
    return 	((percentageOfDuplicates >= 0 && percentageOfDuplicates < 3) ? "++" : "") +
  			((percentageOfDuplicates >= 3 && percentageOfDuplicates < 5) ? "+" : "") +
  			((percentageOfDuplicates >= 5 && percentageOfDuplicates < 10) ? "o" : "") + 
  			((percentageOfDuplicates >= 10 && percentageOfDuplicates < 20) ? "-" : "") + 
  			((percentageOfDuplicates >= 20) ? "--" : "");
}
