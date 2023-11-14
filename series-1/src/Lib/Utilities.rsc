module Lib::Utilities

import lang::java::m3::Core;
import lang::java::m3::AST;

list[Declaration] getASTs(loc projectLocation) {
    M3 model = createM3FromMavenProject(projectLocation);
    list[Declaration] asts = [createAstFromFile(f, true)
    | f <- files(model.containment), isCompilationUnit(f)];
    return asts;
}

list[Declaration] getASTsFolder(loc folderLocation) {
    M3 model = createM3FromDirectory(folderLocation);
    list[Declaration] asts = [createAstFromFile(f, true)
    | f <- files(model.containment), isCompilationUnit(f)];
    return asts;
}