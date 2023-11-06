module Main

import IO;
import List;
import Set;
import Map;
import String;
import List;
import lang::java::m3::Core;
import lang::java::m3::AST;

// Add block to Maps
map[str, int] addToMap(map[str, int] blocks, str block){
    if (block in blocks) {blocks[block] += 1;}
	else { blocks[block] = 1;}
	return blocks;
}

// create blocks of 6 and add it to map
map[str, int] createBlocks(map[str, int] blocks, loc fileLoc) {
    list[str] lines = [];
    str line = "";
    for (str line <- readFileLines(fileLoc)) {
        if (trim(line) != "") {
            lines += line;
            if (size(lines) == 6){
                // if the lines are 6 it considered as a bloack and added to the map
                str block = lines[0] + lines[1] + lines[2] + lines[3] + lines[4] + lines[5];
                blocks = addToMap(blocks, block);
                lines = lines[1..5]; // Remove the first line and make it ready to form next block
            }
        }
    }
    return blocks;
}

// find duplicate blocks in a map
map[str, int] findDuplicates(map[str, int] Blocks){
    for (str block <- Blocks) {
    if (Blocks[block] == 1){
        Blocks = delete(Blocks, block); // Remove blocks which are not duplicated
    }
}
    return Blocks;
}

// Find Duplicate blocks (6 lines ) of code in a project
map[str, int] duplicateBlocksOfCodeProject(loc projectLoc) {
    map[str, int] blocks = ();
    M3 model = createM3FromMavenProject(projectLoc);
    // iterate over files of project and create blocks
    for (file <- files(model.containment)) {
        blocks = createBlocks(blocks, file.top);
    }

    map[str, int] duplicateBlocks = findDuplicates(blocks);
    return duplicateBlocks;
}

int main(int testArgument=0) {
    println("argument: <testArgument>");
    return testArgument;
}

