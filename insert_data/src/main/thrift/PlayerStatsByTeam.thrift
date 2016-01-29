namespace java edu.uchicago.mpcs53013.NBAstats

struct PlayerStatsByTeam {
	1: required i32 id;
	2: required i32 playerID;
	3: required string playerTrueName;
	4: required string team;
	5: required double minOnCourt;
	6: required double possForOnCourt;
	7: required double possOppOnCourt;
	8: required double pointsForOnCourt;
	9: required double pointsOppOnCourt;
	10: required double offRtgOnCourt;
	11: required double defRtgOnCourt;
	12: required double overallRtgOnCourt;
	13: required double oRebForOnCourt;
	14: required double oRebOppOnCourt;
	15: required double dRebForOnCourt;
	16: required double dRebOppOnCourt;
	17: required double oRebRateOnCourt;
	18: required double dRebRateOnCourt;
	19: required double minOffCourt;
	20: required double possForOffCourt;
	21: required double possOppOffCourt;
	22: required double pointsForOffCourt;
	23: required double pointsOppOffCourt;
	24: required double offRtgOffCourt;
	25: required double defRtgOffCourt;
	26: required double overallRtgOffCourt;
	27: required double oRebForOffCourt;
	28: required double oRebOppOffCourt;
	29: required double dRebForOffCourt;
	30: required double dRebOppOffCourt;
	31: required double oRebRateOffCourt;
	32: required double dRebRateOffCourt;
	33: required double overallRtgOnCourtMinusOffCourt;
	34: required double oRebRateOnCourtMinusOffCourt;
	35: required double dRebRateOnCourtMinusOffCourt;
}