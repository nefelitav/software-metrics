module Lib::Utilities
import util::Math;
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

// normalization of results with pecentages
map[str, int] normalizeRisks(map[str, int] risks) {
    // get number of methods in each category
    int sumRisks = risks["lowRisk"] + risks["moderateRisk"] + risks["highRisk"] + risks["veryHighRisk"];   
	risks["lowRisk"] = round(toReal(risks["lowRisk"]) * 100.0 / toReal(sumRisks));
	risks["moderateRisk"] = round(toReal(risks["moderateRisk"]) * 100.0 / toReal(sumRisks));
	risks["highRisk"] = round(toReal(risks["highRisk"]) * 100.0 / toReal(sumRisks));
	risks["veryHighRisk"] = round(toReal(risks["veryHighRisk"]) * 100.0 / toReal(sumRisks));
    return risks;
}