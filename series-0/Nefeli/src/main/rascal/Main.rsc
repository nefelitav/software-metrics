module Main

import IO;
import List;
import Set;
import String;
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

int getNumberOfForLoops(list[Declaration] asts){
    int loops = 0;
    visit(asts){
        case \foreach(_, _, _): loops += 1;
        case \for(_, _, _, _): loops += 1;
        case \for(_, _, _): loops += 1;
    }
    return loops;
}


// Helper function to count the occurrences of variables
map[str, int] countOccurrences(list[Declaration] declarations) {
    map[str, int] occurrences = ();
    for (decl <- declarations) {
        switch (decl) {
            case \variable(name, _): 
                occurrences += (name : occurrences[name] + 1);
        }
    }
    return occurrences;
}

// Function to find the most occurring variable(s)
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



// Helper function to count the occurrences of variables
map[str, int] countNumberOccurrences(list[Declaration] declarations) {
    map[str, int] occurrences = ();
    for (decl <- declarations) {
        switch (decl) {
            case \number(number):
                occurrences += (number : occurrences[number] + 1);
        }
    }
    return occurrences;
}

// Function to find the most occurring variable(s)
tuple[int, list[str]] mostOccurringNumbers(list[Declaration] asts) {
    map[str, int] occurrences = countNumberOccurrences(asts);
    int maxCount = 0;
    list[str] mostOccurring = [];
    for (str number <- occurrences) {
        count = occurrences[number];
        if (count > maxCount) {
            maxCount = count;
            mostOccurring = [number];
        } else if (count == maxCount) {
            mostOccurring += number;
        }
    }
    return <maxCount, mostOccurring>;
}

list[loc] findNullReturned(list[Declaration] asts){
// TODO: Create this function
}

test bool numberOfInterfaces() {
    return getNumberOfInterfaces(getASTs(|project://smallsql0.21_src|)) == 1;
}

test bool numberOfForLoops() {
    return getNumberOfForLoops(getASTs(|project://smallsql0.21_src|)) == 259;
}