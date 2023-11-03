module UnitSize

import IO;
import List;
import Set;
import Map;
import String;
import lang::java::m3::Core;
import lang::java::m3::AST;

// Unit size: The size of units influences their analysability and testability and therefore of the system as a whole.
// A unit is the smallest piece of code that can be executed and tested individually eg a method for java
// 1) LOC per unit

int main(int testArgument=0) {
    println("argument: <testArgument>");
    return testArgument;
}

