module Metrics::UnitComplexity

import lang::java::m3::Core;
import lang::java::m3::AST;
import Metrics::UnitSize;
import Lib::Utilities;

// Calculating complexity per unit
int unitComplexity(Declaration ast) {
	int complexity = 1;
	bool firstReturn = true;
	
	// Find number of execution branches
	visit(ast) {
		case \if(_, _): complexity += 1;
		case \if(_, _, _): complexity += 1;
		case \foreach(_, _, _): complexity += 1;
		case \for(_, _, _): complexity += 1;
		case \for(_, _, _, _): complexity += 1;
		case \do(_, _): complexity += 1;
		case \while(_, _): complexity += 1;
		case \case(_): complexity += 1;
		case \defaultCase(): complexity += 1;
		case \conditional(_, _, _): complexity += 1;
		case \catch(_, _): complexity += 1;
		case \throw(_): complexity += 1;
		case \infix(_, op, _): {
			if (op == "&&" || op == "||") complexity += 1;
		}
		case \return(_): {
			if (!firstReturn) complexity += 1;
			else firstReturn = false;
		}
	}
	return complexity;
}

// Calculate Cyclomatic Complexity, Identify Risk level of code
// Calculate and return ranking
map[loc, int] unitsComplexity(loc projectLoc) {
	M3 model = createM3FromMavenProject(projectLoc);
	list[Declaration] asts = getASTs(projectLoc);
	map[loc, int] unitsComplexities = ();

	// Visiting each methood/constructor and calling unitComplexity method function
	// to calculate unit complexity for each module/constructor
	visit(asts) {
		case Declaration decl: \method(_, _, _, _, _): {unitsComplexities[decl.src] = unitComplexity(decl);}
		case Declaration decl: \method(_, _, _, _): {unitsComplexities[decl.src] = unitComplexity(decl);}
		case Declaration decl: \constructor(_, _, _, _): unitsComplexities[decl.src] = unitComplexity(decl);
	}
	return unitsComplexities;
}

// Identify risk for each method based on Unit Complexity and normalize results
map[str, int] unitsComplexityRisk(loc projectLoc) {
	map[loc, int] unitSizes = LOCUnits(projectLoc);
	map[loc, int] unitComplexities = unitsComplexity(projectLoc);
    risks = (
		"lowRisk": 0,
		"moderateRisk": 0,
		"highRisk": 0,
		"veryHighRisk": 0
	);
	for (unit <- unitComplexities) {
		if (unitComplexities[unit] <= 10) {
			risks["lowRisk"] += unitSizes[unit];
		} else if (unitComplexities[unit] <= 20) {
			risks["moderateRisk"] += unitSizes[unit];
		} else if (unitComplexities[unit] <= 50) {
			risks["highRisk"] += unitSizes[unit];
		} else {
			risks["veryHighRisk"] += unitSizes[unit];
		}
	}
	return risks;
}

// Normalize Risks
map[str, int] normalizeUnitsComplexityRisk(map[str, int] risks){
	return normalizeRisks(risks);
}

// Calculate rank based on Risk
str unitsComplexityScore(map[str, int] risks) {
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