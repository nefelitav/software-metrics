module Testing

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

void test1(){
    map[str, int] blocks = ("a":3);
    if ( "" in blocks){
        print("5");
    }
    else{
        print("6");
    }
}


int main(int testArgument=0) {
    println("argument: <testArgument>");
    return testArgument;
}
