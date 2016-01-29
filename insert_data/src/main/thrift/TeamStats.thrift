namespace java edu.uchicago.mpcs53013.NBAstats

struct TeamStats {
	1: required i32 id;
	2: required string teamID;
	3: required string team;
	4: required double min;
	5: required double possFor;
	6: required double possOpp;
	7: required double pointsFor;
	8: required double pointsOpp;
	9: required double offRtg;
	10: required double defRtg;
	11: required double overallRtg;
	12: required double oRebFor;
	13: required double oRebOpp;
	14: required double dRebFor;
	15: required double dRebOpp;
	16: required double oRebRate;
	17: required double dRebRate;
}
