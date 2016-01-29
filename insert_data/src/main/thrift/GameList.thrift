namespace java edu.uchicago.mpcs53013.NBAstats

struct GameList {
	1: required string GameID;
	2: required string Year;
	3: required string GameDate;
	4: required string League;
	5: required string BoxScoreURL;
	6: required string PlayByPlayURL;
	7: required string HomeNameFull;
	8: required string HomeName3;
	9: required string AwayNameFull;
	10: required string AwayName3;
	11: required string HaveBoxScore;
	12: required string HavePlayByPlay;
	13: required string AnalyzedPlayByPlay;
}