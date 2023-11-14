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
	
	map[loc, int] unit_sizes = LOCUnits(projectLoc);

	M3 model = createM3FromMavenProject(projectLoc);
	list[Declaration] asts = getASTs(projectLoc);
	map[loc, int] unitComplexities = ();
	visit(asts) {
		case decl: \method(_, _, _, _, _): {unitComplexities[decl.src] = unitComplexity(decl);}
		case Declaration decl: \method(_, _, _, _): {unitComplexities[decl.src] = unitComplexity(decl);}
		case decl: \constructor(_, _, _, _): unitComplexities[decl.src] = unitComplexity(decl);
	}
	// print(unitComplexities);

	// print(unit_sizes);

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

	print(risks);
	normalizedrisks = normalizeRisks(risks);
	print(normalizedrisks);
	print(unitSizeScore(normalizedrisks));

}

int main(int testArgument=0) {
    println("argument: <testArgument>");
    return testArgument;
}
