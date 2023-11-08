module UnitTesting

import IO;
import List;
import Set;
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

list[Declaration] getASTs(loc projectLocation) {
    M3 model = createM3FromMavenProject(projectLocation);
    list[Declaration] asts = [createAstFromFile(f, true)
    | f <- files(model.containment), isCompilationUnit(f)];
    return asts;
}

// number of assert statements, not in comments
int countAssertStatements(loc projectLoc) {
    list[Declaration] asts = getASTs(projectLoc);
    int asserts = 0;
    visit(asts) {
        case \methodCall(_, name, _): {
            if (startsWith(name, "assert")) {
                asserts += 1;
            }
        }
        case \methodCall(_, _, name, _): {
            if (startsWith(name, "assert")) {
                asserts += 1;
            }
        }
    }
    return asserts;
}

map[loc, int] assertsInUnits(loc projectLoc) {
    M3 model = createM3FromMavenProject(projectLoc);
    map[loc, int] methodsAsserts = ();
    for(method <- methods(model)) {
        int assertStatements = countAssertStatements(method);
        // check that it is a test method
        if (assertStatements != 0) {
            methodsAsserts[method] = assertStatements;
        }
    }
    return methodsAsserts;
}

map[str, int] getUnitsCategories(map[loc, int] methodsAsserts) {
    categories = (
		"low": 0,
		"moderate": 0,
		"high": 0,
		"veryHigh": 0
	);
    // place every method in a category
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

// normalization
map[str, int] normalizeScores(map[str, int] scores) {
    // get sum of scores, basically number of methods
    int sumScores = scores["low"] + scores["moderate"] + scores["high"] + scores["veryHigh"];   
	scores["low"] = scores["low"] * 100 / sumScores;
	scores["moderate"] = scores["moderate"] * 100 / sumScores;
	scores["high"] = scores["high"] * 100 / sumScores;
	scores["veryHigh"] = scores["veryHigh"] * 100 / sumScores;
    return scores;
}

// return rating
str unitTestingScore(map[str, int] categories) {
    if (categories["moderate"] <= 25 && categories["high"] == 0 && categories["veryHigh"] == 0) {
        return "++";
    } else if (categories["moderate"] <= 30 && categories["high"] <= 5 && categories["veryHigh"] == 0) {
        return "+";
    } else if (categories["moderate"] <= 40 && categories["high"] <= 10 && categories["veryHigh"] == 0) {
        return "o";
    } else if (categories["moderate"] <= 50 && categories["high"] <= 15 && categories["veryHigh"] <= 5) {
        return "-";
    } else {
        return "--";
    }
}