module Maintainability

import IO;
import List;
import Set;
import Map;
import String;
import lang::java::m3::Core;
import lang::java::m3::AST;


// Halstead Volume (HV)
// Cyclomatic Complexity (CC) 
// the average number of lines of code per module (LOC)
// and optionally the percentage of comment lines per module (COM)
// 171−5.2ln(HV)−0.23CC−16.2ln(LOC)+50.0sin√(2.46 ∗ COM)
// hte higher the score, the more maintainable 

// a unit, we mean the smallest piece of code that can be executed and tested individually
// eg a method for java


int main(int testArgument=0) {
    println("argument: <testArgument>");
    return testArgument;
}

