module Main

import IO;
import List;
// import Set;
// import Map;
// import String;
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
// count the occurrences of variables
map[str, int] countOccurrences(list[Declaration] asts) {
    map[str, int] occurrences = ();
    visit(asts){
        case \variable(name, _): 
            if (name in occurrences) {
                occurrences[name] += 1;
            } else {
                occurrences[name] = 1;
            }
        case \variable(name, _, _): 
            if (name in occurrences) {
                occurrences[name] += 1;
            } else {
                occurrences[name] = 1;
            }
    }
    return occurrences;
}

// find the most occurring variable(s)
tuple[int, list[str]] mostOccurringVariables(list[Declaration] asts) {
    map[str, int] occurrences = countOccurrences(asts);
    int maxCount = 0;
    list[str] mostOccurring = [];
    for (str name <- occurrences) {
        count = occurrences[name];
        if (count > maxCount) {
            maxCount = count;
            mostOccurring = [name];
        } else if (count == maxCount) {
            mostOccurring += name;
        }
    }
    return <maxCount, mostOccurring>;
}

// Problem 3
// count the occurrences of numbers
map[str, int] countNumberOccurrences(list[Declaration] asts) {
    map[str, int] occurrences = ();
    visit(asts){
        case \number(name): 
            if (name in occurrences) {
                occurrences[name] += 1;
            } else {
                occurrences[name] = 1;
            }
    }
    return occurrences;
}

// find the most occurring number(s)
tuple[int, list[str]] mostOccurringNumbers(list[Declaration] asts) {
    map[str, int] occurrences = countNumberOccurrences(asts);
    int maxCount = 0;
    list[str] mostOccurring = [];
    for (str name <- occurrences) {
        count = occurrences[name];
        if (count > maxCount) {
            maxCount = count;
            mostOccurring = [name];
        } else if (count == maxCount) {
            mostOccurring += name;
        }
    }
    return <maxCount, mostOccurring>;
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
    return mostOccurringVariables(getASTs(|project://smallsql0.21_src|)) == <205,["i"]>;
}

test bool mostOccurringNums() {
    return mostOccurringNumbers(getASTs(|project://smallsql0.21_src|)) == <1382,["0"]>;
}