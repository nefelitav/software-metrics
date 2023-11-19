module Tests::CommentsTests

import Metrics::Comments;

// Tests on TestProject
test bool testCommentsRiskTestProject() {
    return unitsCommentsRisk(|project://TestProject|) == ("veryHighRisk":492,"lowRisk":88,"highRisk":0,"moderateRisk":0);
}
test bool testNormalizedCommentsRiskTestProject() {
    return commentsRisk(|project://TestProject|) == ("veryHighRisk":85,"lowRisk":15,"highRisk":0,"moderateRisk":0);
}
test bool testCommentsRankingTestProject() {
    return commentsRanking(commentsRisk(|project://TestProject|)) == "--";
}

// Tests on smallsql
test bool testCommentsRiskSmallSQLProject() {
    return unitsCommentsRisk(|project://smallsql0.21_src|) == ("veryHighRisk":13375,"lowRisk":6470,"highRisk":2233,"moderateRisk":1395);
}
test bool testNormalizedCommentsRiskSmallSQLProject() {
    return commentsRisk(|project://smallsql0.21_src|) == ("lowRisk":28,"veryHighRisk":57,"highRisk":10,"moderateRisk":6);
}
test bool testCommentsRankingSmallSQLProject() {
    return commentsRanking(commentsRisk(|project://smallsql0.21_src|)) == "--";
}