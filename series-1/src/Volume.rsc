module Volume

import IO;
import List;
import Set;
import Map;
import String;
import lang::java::m3::Core;
import lang::java::m3::AST;

// Volume: The overall volume of the source code influences the analysability of the system
// 1) LOC: which counts all lines of source code that are not line/block comments or blank lines.
// 2) Man years via backfiring function points: to make it language independent
//---------------------------------
// rank     MY        Java (KLOC) -
//---------------------------------
// ++       0 − 8     0-66        -
// +        8 − 30    66-246      -
// o        30 − 80   246-665     -
// -        80 − 160  655-1,310   -
// --       > 160     > 1,310     -
//---------------------------------

int main(int testArgument=0) {
    println("argument: <testArgument>");
    return testArgument;
}

int volume(int testArgument=0) {
    println("argument: <testArgument>");
    return testArgument;
}
