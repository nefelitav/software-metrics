module Metrics::UnitTesting

import IO;
import List;
import String;
import lang::java::m3::Core;
import lang::java::m3::AST;

// Unit Testing:
// 1) Unit test coverage, e.g with Clover
// ------------------------------
// rank  |   unit test coverage -
// ------------------------------
// ++    |   95-100%            -
// +     |   80-95%             -
// o     |   60-80%             -
// -     |   20-60%             -
// --    |    0-20%             -
// ------------------------------
// 2) Number of assert statements

int main(int testArgument=0) {
    println("argument: <testArgument>");
    return testArgument;
}

list[Declaration] getASTs(loc projectLoc) {
    M3 model = createM3FromMavenProject(projectLoc);
    list[Declaration] asts = [createAstFromFile(f, true)
    | f <- files(model.containment), isCompilationUnit(f)];
    return asts;
}

// number of assert statements, not in comments
int countAssertStatements(loc methodLoc) {
    int asserts = 0;
    bool insideBlockComment = false;
    for (line <- readFileLines(methodLoc)) {
        // ignore comments
        if (startsWith(trim(line), "/*") || (insideBlockComment == true)) {
            // inside the block comment
            insideBlockComment = true;
            if (endsWith(trim(line), "*/")) {
                // outside the block comment
                insideBlockComment = false; 
            }
        // if there is a line comment inside a block comment we do not add it to the line comments
        } else if (!startsWith(trim(line), "//")) {
            if (contains(line, "assert")) {
                asserts += 1;
            }
        }
    }
    return asserts;
}

// get number of assert statements for every method
map[loc, int] assertsInUnits(loc projectLoc) {
    M3 model = createM3FromMavenProject(projectLoc);
    map[loc, int] methodsAsserts = ();
    int assertStatements = 0;
    for(method <- methods(model)) {
        assertStatements = countAssertStatements(method);
        // check that it is a test method
        if (assertStatements != 0) {
            methodsAsserts[method] = assertStatements;
        }
    }
    return methodsAsserts;
}

// place every method in a "test coverage" category
map[str, int] getUnitsCategories(map[loc, int] methodsAsserts) {
    categories = (
		"low": 0,
		"moderate": 0,
		"high": 0,
		"veryHigh": 0
	);
	for (key <- methodsAsserts) {	
        int methodsAssert = methodsAsserts[key];
		if (methodsAssert <= 2) {
			categories["low"] += 1;								
		} else if (methodsAssert <= 5) {
			categories["moderate"] += 1;
		} else if (methodsAssert <= 10) {
			categories["high"] += 1;			
		} else {
			categories["veryHigh"] += 1;			
		}	
	} 
    return categories;
}

// normalization of results with pecentages
map[str, int] normalizeScores(map[str, int] scores) {
    // get number of methods in each category
    int sumScores = scores["low"] + scores["moderate"] + scores["high"] + scores["veryHigh"];   
	scores["low"] = scores["low"] * 100 / sumScores;
	scores["moderate"] = scores["moderate"] * 100 / sumScores;
	scores["high"] = scores["high"] * 100 / sumScores;
	scores["veryHigh"] = scores["veryHigh"] * 100 / sumScores;
    return scores;
}

// return rank
str unitTestingScore(map[str, int] categories) {
    if (categories["moderate"] <= 25 && categories["high"] == 0 && categories["veryHigh"] == 0) {
        return "--";
    } else if (categories["moderate"] <= 30 && categories["high"] <= 5 && categories["veryHigh"] == 0) {
        return "-";
    } else if (categories["moderate"] <= 40 && categories["high"] <= 10 && categories["veryHigh"] == 0) {
        return "o";
    } else if (categories["moderate"] <= 50 && categories["high"] <= 15 && categories["veryHigh"] <= 5) {
        return "+";
    } else {
        return "++";
    }
}

// Tests on smallsql
test bool tesCountAssertStatements() {
    return countAssertStatements(|project://smallsql0.21_src/src/smallsql/database/Language/Language.java|) == 4;
}
test bool testGetUnitsCategories() {
    return getUnitsCategories(assertsInUnits(|project://smallsql0.21_src|)) == ("high":20,"moderate":64,"low":81,"veryHigh":18);
}
test bool testNormalizeScores() {
    return normalizeScores(getUnitsCategories(assertsInUnits(|project://smallsql0.21_src|))) == ("high":10,"moderate":34,"low":44,"veryHigh":9);
}
test bool testUnitSizeScore() {
    return unitTestingScore(normalizeScores(getUnitsCategories(assertsInUnits(|project://smallsql0.21_src|)))) == "++";
}