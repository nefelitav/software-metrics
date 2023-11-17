module Metrics::UnitSize

import Metrics::Volume;
import IO;
import List;
import lang::java::m3::Core;
import lang::java::m3::AST;
import Lib::Utilities;
import util::Math;

// Unit size: The size of units influences their analysability and testability and therefore the system as a whole.
// A unit is the smallest piece of code that can be executed and tested individually eg a method for java
// 1) LOC per unit

// get lines of code of a unit/method, subtracting blank lines and comments
map[loc, int] LOCUnits(loc projectLoc) {
    map[loc, int] methodsLoc = ();
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
		if (methodLoc <= 15) {
			risks["noRisk"] += 1;								
		} else if (methodLoc <= 30) {
			risks["moderateRisk"] += 1;
		} else if (methodLoc <= 60) {
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
	risks["noRisk"] = round(toReal(risks["noRisk"]) * 100.0 / toReal(sumRisks));
	risks["moderateRisk"] = round(toReal(risks["moderateRisk"]) * 100.0 / toReal(sumRisks));
	risks["highRisk"] = round(toReal(risks["highRisk"]) * 100.0 / toReal(sumRisks));
	risks["veryHighRisk"] = round(toReal(risks["veryHighRisk"]) * 100.0 / toReal(sumRisks));
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
