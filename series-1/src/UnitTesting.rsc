module UnitTesting

import IO;
import List;
import Set;
import String;
import lang::java::m3::Core;
import lang::java::m3::AST;

// Unit Testing:
// 1) Unit test coverage, e.g with Clover
// ------------------------------
// rank  |   unit test coverage -
// ------------------------------
// ++    |   95-100%            -
// +     |   80-95%             -
// o     |   60-80%             -
// -     |   20-60%             -
// --    |    0-20%             -
// ------------------------------
// 2) Number of assert statements

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

// number of assert statements, not in comments
int countAssertStatements(loc projectLoc) {
    list[Declaration] asts = getASTs(projectLoc);
    int asserts = 0;
    visit(asts) {
        case \methodCall(_, name, _): {
            if (startsWith(name, "assert")) {
                asserts += 1;
            }
        }
        case \methodCall(_, _, name, _): {
            if (startsWith(name, "assert")) {
                asserts += 1;
            }
        }
    }
    return asserts;
}