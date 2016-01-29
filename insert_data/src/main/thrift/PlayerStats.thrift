namespace java edu.uchicago.mpcs53013.NBAstats

struct PlayerStats {
	1: required i32 id;
	2: required double PlayerID;
	3: required string PlayerTrueName;
	4: required string PlayerTeams;
	5: required double SimpleMin;
	6: required double SimplePossFor;
	7: required double SimplePossOpp;
	8: required double SimplePointsFor;
	9: required double SimplePointsOpp;
	10: required double SimpleOffRtg;
	11: required double SimpleDefRtg;
	12: required double SimpleOverallRtg;
	13: required double SimpleORebFor;
	14: required double SimpleORebOpp;
	15: required double SimpleDRebFor;
	16: required double SimpleDRebOpp;
	17: required double SimpleORebRate;
	18: required double SimpleDRebRate;
	19: required double WeightedMinOffCourt;
	20: required double WeightedPossForOffCourt;
	21: required double WeightedPossOppOffCourt;
	22: required double WeightedPointsForOffCourt;
	23: required double WeightedPointsOppOffCourt;
	24: required double WeightedOffRtgOffCourt;
	25: required double WeightedDefRtgOffCourt;
	26: required double WeightedOverallRtgOffCourt;
	27: required double WeightedORebForOffCourt;
	28: required double WeightedORebOppOffCourt;
	29: required double WeightedDRebForOffCourt;
	30: required double WeightedDRebOppOffCourt;
	31: required double WeightedORebRateOffCourt;
	32: required double WeightedDRebRateOffCourt;
	33: required double WeightedOverallRtgOnCourt;
	34: required double WeightedORebRateOnCourt;
	35: required double WeightedDRebRateOnCourt;
	36: required double WeightedOverallRtgOnCourtMinusOffCourt;
	37: required double WeightedORebRateOnCourtMinusOffCourt;
	38: required double WeightedDRebRateOnCourtMinusOffCourt;
	39: required double AdjustedPM;
	40: required double AdjustedPMStdErr;

}