module Main

import IO;
import List;
import Set;
import Map;
import lang::java::m3::Core;
import lang::java::m3::AST;

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

int getNumberOfInterfaces(list[Declaration] asts){
    int interfaces = 0;
    visit(asts){
        case \interface(_, _, _, _): interfaces += 1;
    }
    return interfaces;
}

// Problem 1
int getNumberOfForLoops(list[Declaration] asts){
    int loops = 0;
    visit(asts){
        case \foreach(_, _, _): loops += 1;
        case \for(_, _, _, _): loops += 1;
        case \for(_, _, _): loops += 1;
    }
    return loops;
}

// Problem 2
// find the most occurring variables
tuple[int, list[str]] mostOccurringVariables(list[Declaration] asts){
    map[str varName, int counts] counter = ();
    visit(asts){
        case \variable(str name, _): counter[name] ? 0 += 1;
        case \variable(str name, _, _): counter[name] ? 0 += 1;
        case \fieldAccess(_, _, str name): counter[name] ? 0 += 1;
        case \fieldAccess(_, str name): counter[name] ? 0 += 1;
        case \parameter(_, str name, _): counter[name] ? 0 += 1;
        case \vararg(_, str name): counter[name] ? 0 += 1;
    }
    int maximum = max(counter.counts);
    return <maximum, toList(invert(counter)[maximum])>;
}

// Problem 3
// find the most occurring numbers
tuple[int, list[str]] mostOccurringNumbers(list[Declaration] asts){
    map[str numS, int counts] counter = ();
    visit(asts){
        case \number(str n): counter[n] ? 0 += 1;
        case \stringLiteral(n:/^\"\d+\"$/): counter[n] ? 0 += 1;
    }
    int maximum = max(counter.counts);
    return <maximum, toList(invert(counter)[maximum])>;
}

// Problem 4
list[loc] findNullReturned(list[Declaration] asts){
	list[loc] locs = [];
	visit(asts){
		case \return(expr): {
			if (expr.typ == \null()) {
                locs += expr.src;
            }
		}
	}
	return locs;
}

// Tests on smallsql
test bool numberOfInterfaces() {
    return getNumberOfInterfaces(getASTs(|project://smallsql0.21_src|)) == 1;
}

test bool numberOfForLoops() {
    return getNumberOfForLoops(getASTs(|project://smallsql0.21_src|)) == 259;
}

test bool mostOccurringVars() {
    return mostOccurringVariables(getASTs(|project://smallsql0.21_src|)) == <272,["con"]>;
}

test bool mostOccurringNums() {
    return mostOccurringNumbers(getASTs(|project://smallsql0.21_src|)) == <1382,["0"]>;
}