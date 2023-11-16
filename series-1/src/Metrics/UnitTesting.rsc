module Metrics::UnitTesting

import String;
import lang::java::m3::Core;
import lang::java::m3::AST;
import Lib::Utilities;
import util::Math;

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

// number of assert statements, check method calls' names have the substring "assert"
int countAssertStatements(Declaration ast) {
    int asserts = 0;
	visit(ast) {
        case \methodCall(_, name, _): {
            if (contains(name, "assert")) {
                asserts += 1;
            }
        }
        case \methodCall(_, _, name, _): {
            if (contains(name, "assert")) {
                asserts += 1;
            }
        }
    }
    return asserts;
}

// get number of assert statements for every method in a folder
map[loc, int] assertsInUnits(loc folderLoc) {
    // look in a specific folder, eg junit, test, so that we do not spoil our results with files that arent for testing purposes.
	list[Declaration] asts = getASTsFolder(folderLoc);
    map[loc, int] methodsAsserts = ();
    int assertStatements = 0;
    visit(asts) {
        // iterate over all methods
		case Declaration decl: \method(_, _, _, _, _): {
            assertStatements = countAssertStatements(decl);
            // check that it is a test method
            if (assertStatements != 0) {
                methodsAsserts[decl.src] = assertStatements;
            }
        }
		case Declaration decl: \method(_, _, _, _): {
            assertStatements = countAssertStatements(decl);
            if (assertStatements != 0) {
                methodsAsserts[decl.src] = assertStatements;
            }
        }
		case Declaration decl: \constructor(_, _, _, _): {
            assertStatements = countAssertStatements(decl);
            if (assertStatements != 0) {
                methodsAsserts[decl.src] = assertStatements;
            }
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
	scores["low"] = round(toReal(scores["low"]) * 100.0 / toReal(sumScores));
	scores["moderate"] = round(toReal(scores["moderate"]) * 100 / toReal(sumScores));
	scores["high"] = round(toReal(scores["high"]) * 100 / toReal(sumScores));
	scores["veryHigh"] = round(toReal(scores["veryHigh"]) * 100 / toReal(sumScores));
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