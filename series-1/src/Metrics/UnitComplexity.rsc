module Metrics::UnitComplexity

import util::Math;
import IO;
import List;
import Set;
import Map;
import String;
import List;
import lang::java::m3::Core;
import lang::java::m3::AST;
import Metrics::UnitSize;
import Lib::Utilities;

int unitComplexity(Declaration ast) {
	int complexity = 1;
	bool firstReturn = true;
	visit(ast) {
		case \return(_): {
			if (!firstReturn) complexity += 1;
			else firstReturn = false;
		}
		case \if(_, _): complexity += 1;
		case \if(_, _, _): complexity += 1;
		case \case(_): complexity += 1;
		case \defaultCase(): complexity += 1;
		case \foreach(_, _, _): complexity += 1;
		case \for(_, _, _): complexity += 1;
		case \for(_, _, _, _): complexity += 1;
		case \while(_, _): complexity += 1;
		case \do(_, _): complexity += 1;
		case \infix(_, op, _): {
			if (op == "&&" || op == "||") complexity += 1;
		}
		case \conditional(_, _, _): complexity += 1;
		case \catch(_, _): complexity += 1;
		case \throw(_): complexity += 1;
	}
	// println(complexity);
	return complexity;
}

void calculateCyclomaticComplexity(loc projectLoc) {
	// map[loc, int] unitsLOC = LOCUnits(projectLoc);
	// M3 model = createM3FromMavenProject(projectLoc);
	list[Declaration] asts = getASTs(projectLoc);
	map[loc, int] unitComplexities = ();
	visit(asts) {
		case decl: \method(_, _, _, _, _): {
				println(decl);
			// unitComplexities[decl.src] = unitComplexity(decl);
		}
		// case decl: \method(_, _, _, _): unitComplexities[decl.src] = unitComplexity(decl);
	}

	map[loc, int] unit_sizes = LOCUnits(projectLoc);

	// map[str, int] risks =  ("low": 0, "moderate": 0, "high": 0, "very_high": 0);
	// for (unit <- unitComplexities) {
	// 	if (unitComplexities[unit] <= 10) {
	// 		risks["low"] += unit_sizes[unit];
	// 	} else if (unitComplexities[unit] <= 20) {
	// 		risks["moderate"] += unit_sizes[unit];
	// 	} else if (unitComplexities[unit] <= 50) {
	// 		risks["high"] += unit_sizes[unit];
	// 	} else {
	// 		risks["very_high"] += unit_sizes[unit];
	// 	}
	// }

	// print(unitComplexities);
}
