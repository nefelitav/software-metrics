module UnitSize

import Volume;
import IO;
import List;
import Set;
import Map;
import String;
import lang::java::m3::Core;
import lang::java::m3::AST;

// Unit size: The size of units influences their analysability and testability and therefore the system as a whole.
// A unit is the smallest piece of code that can be executed and tested individually eg a method for java
// 1) LOC per unit

int main(int testArgument=0) {
    println("argument: <testArgument>");
    return testArgument;
}

map[loc, int] LOCUnits(loc projectLoc) {
    M3 model = createM3FromMavenProject(projectLoc);
    map[loc, int] methodsLoc = ();
    for(method <- methods(model)) {
        methodsLoc[method] = (linesOfCodeFile(method) - blankLinesFile(method) - commentsFile(method));
    }
    return methodsLoc;
}

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

// normalization
map[str, int] normalizeRisks(map[str, int] risks) {
    // get sum of risks, basically number of methods
    int sumRisks = risks["noRisk"] + risks["moderateRisk"] + risks["highRisk"] + risks["veryHighRisk"];   
	risks["noRisk"] = risks["noRisk"] * 100 / sumRisks;
	risks["moderateRisk"] = risks["moderateRisk"] * 100 / sumRisks;
	risks["highRisk"] = risks["highRisk"] * 100 / sumRisks;
	risks["veryHighRisk"] = risks["veryHighRisk"] * 100 / sumRisks;
    return risks;
}

// return rating
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