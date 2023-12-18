module Metrics::Comments

import lang::java::m3::Core;
import lang::java::m3::AST;
import Metrics::Volume;
import Lib::Utilities;

map[loc, int] methodsComments(loc projectLoc) {
    M3 model = createM3FromMavenProject(projectLoc);
    map[loc, int] comments = ();
    for(method <- methods(model)) {
        comments[method] = commentsFile(method);
    }
    return comments;
}

map[loc, int] methodsLines(loc projectLoc) {
    M3 model = createM3FromMavenProject(projectLoc);
    map[loc, int] methodsLines = ();
    for(method <- methods(model)) {
        methodsLines[method] = linesOfCodeFile(method) - blankLinesFile(method);
    }
    return methodsLines;
}

// Get comments ratio for every method and calculate risks
map[str, int] unitsCommentsRisk(loc projectLoc) {
    map[loc, int] unitComments = methodsComments(projectLoc);
    map[loc, int] unitLOC = methodsLines(projectLoc);
    risks = (
		"lowRisk": 0,
		"moderateRisk": 0,
		"highRisk": 0,
		"veryHighRisk": 0
	);
	for (unit <- unitLOC) {
		if (unitComments[unit] * 100 / unitLOC[unit] <= 1) {
			risks["veryHighRisk"] += unitLOC[unit];
		} else if (unitComments[unit] * 100 / unitLOC[unit] <= 5) {
			risks["highRisk"] += unitLOC[unit];
		} else if (unitComments[unit] * 100 / unitLOC[unit] < 10) {
			risks["moderateRisk"] += unitLOC[unit];
		} else {
			risks["lowRisk"] += unitLOC[unit];
		}
	}
	return risks;
}

// Return normalized Score
map[str, int] commentsRisk(loc projectLoc) {
    return normalizeRisks(unitsCommentsRisk(projectLoc));
}

// Calculate rank based on Risk
str commentsRanking(map[str, int] risks) {
    if (risks["moderateRisk"] <= 25 && risks["highRisk"] == 0 && risks["veryHighRisk"] == 0) {
        return "++";
    } else if (risks["moderateRisk"] <= 30 && risks["highRisk"] <= 5 && risks["veryHighRisk"] == 0) {
        return "+";
    } else if (risks["moderateRisk"] <= 40 && risks["highRisk"] <= 10 && risks["veryHighRisk"] == 0) {
        return "o";
    } else if (risks["moderateRisk"] <= 50 && risks["highRisk"] <= 15 && risks["veryHighRisk"] <= 5) {
        return "-";
    } else {
        return "--";
    }
}