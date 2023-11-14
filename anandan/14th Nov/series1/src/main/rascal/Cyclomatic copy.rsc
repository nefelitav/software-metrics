module Cyclomatic

import util::Math;
import IO;
import List;
import Set;
import Map;
import String;
import List;
import lang::java::m3::Core;
import lang::java::m3::AST;
import Volume;
import UnitSize;
import ParseTree;

list[Declaration] getASTs(loc projectLocation) {
    M3 model = createM3FromMavenProject(projectLocation);
    list[Declaration] asts = [createAstFromFile(f, true)
    | f <- files(model.containment), isCompilationUnit(f)];
    return asts;
}

int unitComplexity(Declaration ast) {
	int complexity = 1;
	bool firstReturn = true;
	// print(countLOC(ast));
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
	M3 model = createM3FromMavenProject(projectLoc);
    map[loc, int] methodsLoc = ();
	map[loc, int] unitComplexities = ();
    for(method <- methods(model)) {
    	// list[void] mt =  parse(method);
		// methodTree = getMethodASTEclipse(method);
		methodLocation = model.declarations[method];
		// print((methodLocation));
		int complexity = 0;
		visit(methodLocation){
			case \return(_): {
				if (!firstReturn) complexity += 1;
				else firstReturn = false;
				print("Anand");
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
		print(complexity);
		// break;
		// for (l <- methodLocation){
		// 	list[Declaration] asts = getASTs(l);
		// 	for (d <- asts){
		// 		unitComplexities[method] = unitComplexity(d);
		// 	}
		// }
		// unitComplexities[method] = unitComplexities(getASTs(methodLocation));
    }

	// print(unitComplexities);
	// map[loc, int] unitsLOC = LOCUnits(projectLoc);
	// // M3 model = createM3FromMavenProject(projectLoc);
	// list[Declaration] asts = getASTs(projectLoc);
	// map[loc, int] unitComplexities = ();
	// visit(asts) {
	// 	case decl: \method(Type _, _, _, _, _): {print(decl[0]); unitComplexities[decl.src] = unitComplexity(decl);}
	// 	case decl: \method(Type _, _, _, _): {unitComplexities[decl.src] = unitComplexity(decl); print(decl);}
	// }

	// map[loc, int] unit_sizes = LOCUnits(projectLoc);
	// print(unit_sizes);

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
	// println(unit_sizes);

}


int main(int testArgument=0) {
    println("argument: <testArgument>");
    return testArgument;
}
