module UnitSize

import Volume;
import IO;
import List;
import lang::java::m3::Core;
import lang::java::m3::AST;

// Unit size: The size of units influences their analysability and testability and therefore the system as a whole.
// A unit is the smallest piece of code that can be executed and tested individually eg a method for java
// 1) LOC per unit

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

// get lines of code of a unit/method, subtracting blank lines and comments
map[loc, int] LOCUnits(loc projectLoc) {
    // M3 model = createM3FromMavenProject(projectLoc);
    map[loc, int] methodsLoc = ();
    // for(method <- methods(model)) {
    //     methodsLoc[method] = (linesOfCodeFile(method) - blankLinesFile(method) - commentsFile(method));
    // }

	list[Declaration] asts = getASTs(projectLoc);
	visit(asts) {
		case Declaration decl: \method(_, _, _, _, _): methodsLoc[decl.src] = (linesOfCodeFile(decl.src) - blankLinesFile(decl.src) - commentsFile(decl.src));
		case Declaration decl: \method(_, _, _, _): methodsLoc[decl.src] = (linesOfCodeFile(decl.src) - blankLinesFile(decl.src) - commentsFile(decl.src));
		case Declaration decl: \constructor(_, _, _, _): methodsLoc[decl.src] = (linesOfCodeFile(decl.src) - blankLinesFile(decl.src) - commentsFile(decl.src));
	}
    return methodsLoc;
}

// get risk profile for every method and gather results
map[str, int] getUnitsRisk(map[loc, int] methodsLoc) {
    risks = (
		"noRisk": 0,
		"moderateRisk": 0,
		"highRisk": 0,
		"veryHighRisk": 0
	);
    // check risk for every method
	for (key <- methodsLoc) {	
        int methodLoc = methodsLoc[key];
		if (methodLoc <= 10) {
			risks["noRisk"] += 1;								
		} else if (methodLoc <= 20) {
			risks["moderateRisk"] += 1;
		} else if (methodLoc <= 50) {
			risks["highRisk"] += 1;			
		} else {
			risks["veryHighRisk"] += 1;			
		}	
	} 
    return risks;
}

// normalization of results with pecentages
map[str, int] normalizeRisks(map[str, int] risks) {
    // get number of methods in each category
    int sumRisks = risks["noRisk"] + risks["moderateRisk"] + risks["highRisk"] + risks["veryHighRisk"];   
	risks["noRisk"] = risks["noRisk"] * 100 / sumRisks;
	risks["moderateRisk"] = risks["moderateRisk"] * 100 / sumRisks;
	risks["highRisk"] = risks["highRisk"] * 100 / sumRisks;
	risks["veryHighRisk"] = risks["veryHighRisk"] * 100 / sumRisks;
    return risks;
}

// return rank
str unitSizeScore(map[str, int] risks) {
    if (risks["moderateRisk"] <= 25 && risks["highRisk"] == 0 && risks["veryHighRisk"] == 0) {
        return "++";
    } else if (risks["moderateRisk"] <= 30 && risks["highRisk"] <= 5 && risks["veryHighRisk"] == 0) {
        return "+";
    } else if (risks["moderateRisk"] <= 40 && risks["highRisk"] <= 10 && risks["veryHighRisk"] == 0) {
        return "o";
    } else if (risks["moderateRisk"] <= 50 && risks["highRisk"] <= 15 && risks["veryHighRisk"] <= 5) {
        return "-";
    } else {
        return "--";
    }
}

// Tests on smallsql
test bool testGetUnitsRisk() {
    return getUnitsRisk(LOCUnits(|project://smallsql0.21_src|)) == ("veryHighRisk":51,"noRisk":1957,"highRisk":184,"moderateRisk":223);
}
test bool testNormalizeRisks() {
    return normalizeRisks(getUnitsRisk(LOCUnits(|project://smallsql0.21_src|))) == ("veryHighRisk":2,"noRisk":81,"highRisk":7,"moderateRisk":9);
}
test bool testUnitSizeScore() {
    return unitSizeScore(normalizeRisks(getUnitsRisk(LOCUnits(|project://smallsql0.21_src|)))) == "-";
}

// Scalability tests on hsqldb
// test bool testGetUnitsRiskHsqldb() {
//     return getUnitsRisk(LOCUnits(|project://hsqldb-2.3.1|)) == ;
// }

test bool testUnitSizeScoreHsqldb() {
    return unitSizeScore(normalizeRisks(getUnitsRisk(LOCUnits(|project://hsqldb-2.3.1|)))) == "-";
}