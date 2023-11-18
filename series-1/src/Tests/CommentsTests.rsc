module Tests::CommentsTests

import Metrics::Comments;

// Tests on TestProject
test bool testCommentsRiskTestProject() {
    return unitsCommentsRisk(|project://TestProject|) == ("veryHighRisk":492,"lowRisk":0,"highRisk":77,"moderateRisk":11);
}
test bool testNormalizedCommentsRiskTestProject() {
    return commentsRisk(|project://TestProject|) == ("veryHighRisk":85,"lowRisk":0,"highRisk":13,"moderateRisk":2);
}
test bool testCommentsRankingTestProject() {
    return commentsRanking(commentsRisk(|project://TestProject|)) == "--";
}

// Tests on smallsql
test bool testCommentsRiskSmallSQLProject() {
    return unitsCommentsRisk(|project://smallsql0.21_src|) == ("veryHighRisk":14019,"lowRisk":1587,"highRisk":5127,"moderateRisk":2740);
}
test bool testNormalizedCommentsRiskSmallSQLProject() {
    return commentsRisk(|project://smallsql0.21_src|) == ("veryHighRisk":60,"lowRisk":7,"highRisk":22,"moderateRisk":12);
}
test bool testCommentsRankingSmallSQLProject() {
    return commentsRanking(commentsRisk(|project://smallsql0.21_src|)) == "--";
}