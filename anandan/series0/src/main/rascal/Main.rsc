module Main

import IO;
import List;
import Set;
import Map;
import String;

import lang::java::m3::Core;
import lang::java::m3::AST;


list[Declaration] getASTs(loc projectLocation) {
    M3 model = createM3FromMavenProject(projectLocation);
    list[Declaration] asts = [createAstFromFile(f, true)
        | f <- files(model.containment), isCompilationUnit(f)];
    return asts;
}

int getNumberOfInterfaces(list[Declaration] asts){
    int interfaces = 0;
    visit(asts){
        case \interface(_, _, _, _): interfaces += 1;
    }
    return interfaces;
}

int getNumberOfForLoops(list[Declaration] asts){
    int forloops = 0;
    visit(asts){
        case \for(_,_,_,_): forloops += 1;
        case \for(_,_,_): forloops += 1;
        case \foreach(_,_,_): forloops += 1;
    }
    return forloops;
}

tuple[int, list[str]] mostOccurrences(map[str, int] variableMap) {

	inverse = invert(variableMap);
	max_occurrence = max(domain(inverse));
	return <max_occurrence, toList(inverse[max_occurrence])>;
}

map[str, int] addToMap(map[str, int] variableMap, str key) {
	if (key in variableMap) {variableMap[key] += 1;}
	else { variableMap[key] = 1;}
	return variableMap;
}

tuple[int, list[str]] mostOccurringVariable(list[Declaration] asts){
    map [str, int] variableMap = ();
    visit(asts){
        case \variable(name,_): variableMap = addToMap(variableMap, name);
        case \variable(name,_,_): variableMap = addToMap(variableMap, name);
    }
    return mostOccurrences(variableMap);
}

tuple[int, list[str]] mostOccurringNumber(list[Declaration] asts) {
	map [str, int] variableMap = ();
	visit(asts){
		case \number(name): variableMap = addToMap(variableMap, name);
	}
	return mostOccurrences(variableMap);
}

list[loc] findNullReturned(list[Declaration] asts) {
	list[loc] locs = [];
	visit(asts){
		case \return(expr): {
			if (expr.typ == \null()) locs += expr.src;
		}
	}

	return locs;
}

//Tests
test bool numberOfInterfaces() {
    return getNumberOfInterfaces(getASTs(|project://smallsql0.21_src|)) == 1;
}

test bool numberOfForLoops() {
    return getNumberOfForLoops(getASTs(|project://smallsql0.21_src|)) == 259;
}

test bool mostOccurringVars() {
    return mostOccurringVariable(getASTs(|project://smallsql0.21_src|)) == <205,["i"]>;
}

test bool mostOccurringNums() {
    return mostOccurringNumber(getASTs(|project://smallsql0.21_src|)) == <1382,["0"]>;
}

int main(int testArgument=0) {
    println("argument: <testArgument>");
    return testArgument;
}

