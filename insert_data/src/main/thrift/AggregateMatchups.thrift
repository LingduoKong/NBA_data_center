namespace java edu.uchicago.mpcs53013.NBAstats

struct AggregateMatchups {
	1: required i32 id;
	2: required string league;
	3: required string year;
	4: required double unitPlayer1ID;
	5: required double unitPlayer2ID;
	6: required double unitPlayer3ID;
	7: required double unitPlayer4ID;
	8: required double unitPlayer5ID;
	9: required double opponentPlayer1ID;
	10: required double opponentPlayer2ID;
	11: required double opponentPlayer3ID;
	12: required double opponentPlayer4ID;
	13: required double opponentPlayer5ID;
	14: required string unitPlayer1Name;
	15: required string unitPlayer2Name;
	16: required string unitPlayer3Name;
	17: required string unitPlayer4Name;
	18: required string unitPlayer5Name;
	19: required string opponentPlayer1Name;
	20: required string opponentPlayer2Name;
	21: required string opponentPlayer3Name;
	22: required string opponentPlayer4Name;
	23: required string opponentPlayer5Name;
	24: required double observations;
	25: required double elapsedSecs;
	26: required double possessionsUnit;
	27: required double possessionsOpponent;
	28: required double pointsScoredUnit;
	29: required double pointsScoredOpponent;
	30: required double offensiveRtgUnit;
	31: required double offensiveRtgOpponent;
	32: required double overallRtgUnitVsOpponent;
	33: required double overallRtgOpponentVsUnit;
	34: required double offensiveReboundsUnit;
	35: required double offensiveReboundsOpponent;
	36: required double defensiveReboundsUnit;
	37: required double defensiveReboundsOpponent;
	38: required double offensiveReboundingRateUnit;
	39: required double offensiveReboundingRateOpponent;
	40: required double defensiveReboundingRateUnit;
	41: required double defensiveReboundingRateOpponent;
}