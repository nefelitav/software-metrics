module Metrics::Comments

import IO;
import List;
import lang::java::m3::Core;
import lang::java::m3::AST;
import Metrics::Volume;

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

// get comments ratio for every method and gather results
map[str, int] getUnitsClarity(map[loc, int] methodsComments, map[loc, int] methodsLines) {
    clarity = (
		"noClarity": 0,
		"moderateClarity": 0,
		"goodClarity": 0,
		"OverComments": 0
	);
    // check risk for every method
	for (key <- methodsLines) {	
        int ratio = (methodsComments[key] * 100) / methodsLines[key];
		if (ratio < 10) {
			clarity["noClarity"] += 1;								
		} else if (ratio <= 20) {
			clarity["moderateClarity"] += 1;	
		} else if (ratio <= 30) {
			clarity["goodClarity"] += 1;		
		} else {
			clarity["OverComments"] += 1;		
		}	
	} 
    return clarity;
}

// normalization of results with pecentages
map[str, int] normalizeScores(map[str, int] clarity) {
    // get number of methods in each category
    int sumScores = clarity["noClarity"] + clarity["moderateClarity"] + clarity["goodClarity"] + clarity["OverComments"];   
	clarity["noClarity"] = clarity["noClarity"] * 100 / sumScores;
	clarity["moderateClarity"] = clarity["moderateClarity"] * 100 / sumScores;
	clarity["goodClarity"] = clarity["goodClarity"] * 100 / sumScores;
	clarity["OverComments"] = clarity["OverComments"] * 100 / sumScores;
    return clarity;
}

// return rank
map[str, int] clarityScore(loc projectLoc) {
    map[loc, int] commentsPerMethod = methodsComments(projectLoc);
    map[loc, int] linesPerMethod = methodsLines(projectLoc);
    map[str, int] getScores = getUnitsClarity(commentsPerMethod, linesPerMethod);
    map[str, int] normalizedScores = normalizeScores(getScores);
    return normalizedScores;
}