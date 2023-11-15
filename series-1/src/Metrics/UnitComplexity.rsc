module Metrics::UnitComplexity

import IO;
import List;
import List;
import lang::java::m3::Core;
import lang::java::m3::AST;
import Metrics::Volume;
import Metrics::UnitSize;

//method to get ASTs from the provided location
list[Declaration] getASTs(loc projectLocation) {
    M3 model = createM3FromMavenProject(projectLocation);
    list[Declaration] asts = [createAstFromFile(f, true)
    | f <- files(model.containment), isCompilationUnit(f)];
    return asts;
}

// Calculating complexy per unit
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
map[str, int] cyclomaticComplexity(loc projectLoc) {
	map[loc, int] unit_sizes = LOCUnits(projectLoc);
	M3 model = createM3FromMavenProject(projectLoc);
	list[Declaration] asts = getASTs(projectLoc);
	map[loc, int] unitComplexities = ();

	// Visiting each methood/constructor and calling unitComplexity method function
	// to calculate unit complexity for each module/constructor
	visit(asts) {
		case Declaration decl: \method(_, _, _, _, _): {unitComplexities[decl.src] = unitComplexity(decl);}
		case Declaration decl: \method(_, _, _, _): {unitComplexities[decl.src] = unitComplexity(decl);}
		case Declaration decl: \constructor(_, _, _, _): unitComplexities[decl.src] = unitComplexity(decl);
	}

	// Identify risk for each method based on Unit Complexity
	map[str, int] risks =  ("noRisk": 0, "moderateRisk": 0, "highRisk": 0, "veryHighRisk": 0);
	for (unit <- unitComplexities) {
		if (unitComplexities[unit] <= 10) {
			risks["noRisk"] += unit_sizes[unit];
		} else if (unitComplexities[unit] <= 20) {
			risks["moderateRisk"] += unit_sizes[unit];
		} else if (unitComplexities[unit] <= 50) {
			risks["highRisk"] += unit_sizes[unit];
		} else {
			risks["veryHighRisk"] += unit_sizes[unit];
		}
	}

	//Calculat Risks Percentage
	return normalizeRisks(risks);
}

// Calculate rank based on Risk
str unitComplexityScore(map[str, int] risks) {
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

int main(int testArgument=0) {
    println("argument: <testArgument>");
    return testArgument;
}
