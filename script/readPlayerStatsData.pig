register /usr/local/elephant-bird/elephant-bird-core-4.10.jar; 
register /usr/local/elephant-bird/elephant-bird-pig-4.10.jar; 
register /usr/local/elephant-bird/elephant-bird-hadoop-compat-4.10.jar
register /usr/hdp/2.2.8.0-3150/pig/lib/piggybank.jar;
register /usr/hdp/2.2.8.0-3150/hive/lib/libthrift-0.9.0.jar;
register /mnt/scratch/lingduokong/jar/insert_data.jar; 
DEFINE SequenceFileLoader org.apache.pig.piggybank.storage.SequenceFileLoader();  
DEFINE ThriftBytesToTupleDef com.twitter.elephantbird.pig.piggybank.ThriftBytesToTuple('edu.uchicago.mpcs53013.NBAstats.PlayerStats');
loadPlayerStats = load '/inputs/lingduokong/PlayerStats' using SequenceFileLoader as (key:int, val:bytearray);
Raw_player_stats = foreach loadPlayerStats generate FLATTEN(ThriftBytesToTupleDef(val));

Player_names = foreach Raw_player_stats generate 
	PlayerStats::PlayerTrueName as PlayerTrueName,
	PlayerStats::PlayerTrueName as PlayerName;

store Player_names into 'hbase://lingduokong_player_names_data' using org.apache.pig.backend.hadoop.hbase.HBaseStorage('item:PlayerTrueName');



Before_calc = foreach Raw_player_stats generate
        PlayerStats::PlayerID as PlayerID,
        PlayerStats::PlayerTrueName as PlayerTrueName,
        PlayerStats::SimplePossFor as SimplePossFor,
        PlayerStats::SimplePossOpp as SimplePossOpp,
        PlayerStats::SimplePointsFor as SimplePointsFor,
        PlayerStats::SimplePointsOpp as SimplePointsOpp,
        PlayerStats::SimpleORebFor as SimpleORebFor,
        PlayerStats::SimpleORebOpp as SimpleORebOpp,
        PlayerStats::SimpleDRebFor as SimpleDRebFor,
        PlayerStats::SimpleDRebOpp as SimpleDRebOpp,
        PlayerStats::WeightedPossForOffCourt as WeightedPossForOffCourt,
        PlayerStats::WeightedPossOppOffCourt as WeightedPossOppOffCourt,
        PlayerStats::WeightedPointsForOffCourt as WeightedPointsForOffCourt,
        PlayerStats::WeightedPointsOppOffCourt as WeightedPointsOppOffCourt,
        PlayerStats::WeightedORebForOffCourt as WeightedORebForOffCourt,
        PlayerStats::WeightedORebOppOffCourt as WeightedORebOppOffCourt,
        PlayerStats::WeightedDRebForOffCourt as WeightedDRebForOffCourt,
        PlayerStats::WeightedDRebOppOffCourt as WeightedDRebOppOffCourt;


Player_stats_by_name = GROUP Before_calc BY PlayerTrueName;

avg_player_stats = foreach Player_stats_by_name generate
	group as name,
	AVG($1.SimplePossFor) as SimplePossFor, 
	AVG($1.SimplePossOpp) as SimplePossOpp, 
	AVG($1.SimplePointsFor) as SimplePointsFor, 
	AVG($1.SimplePointsOpp) as SimplePointsOpp, 
	AVG($1.SimpleORebFor) as SimpleORebFor, 
	AVG($1.SimpleORebOpp) as SimpleORebOpp, 
	AVG($1.SimpleDRebFor) as SimpleDRebFor, 
	AVG($1.SimpleDRebOpp) as SimpleDRebOpp, 
	AVG($1.WeightedPossForOffCourt) as WeightedPossForOffCourt, 
	AVG($1.WeightedPossOppOffCourt) as WeightedPossOppOffCourt, 
	AVG($1.WeightedPointsForOffCourt) as WeightedPointsForOffCourt, 
	AVG($1.WeightedPointsOppOffCourt) as WeightedPointsOppOffCourt, 
	AVG($1.WeightedORebForOffCourt) as WeightedORebForOffCourt, 
	AVG($1.WeightedORebOppOffCourt) as WeightedORebOppOffCourt, 
	AVG($1.WeightedDRebForOffCourt) as WeightedDRebForOffCourt, 
	AVG($1.WeightedDRebOppOffCourt) as WeightedDRebOppOffCourt;

store avg_player_stats into 'hbase://lingduokong_player_avg_stats_data' using org.apache.pig.backend.hadoop.hbase.HBaseStorage(
	'item:SimplePossFor, item:SimplePossOpp, item:SimplePointsFor, item:SimplePointsOpp, 
	item:SimpleORebFor, item:SimpleORebOpp, item:SimpleDRebFor, item:SimpleDRebOpp, 
	item:WeightedPossForOffCourt, item:WeightedPossOppOffCourt, item:WeightedPointsForOffCourt, 
	item:WeightedPointsOppOffCourt, item:WeightedORebForOffCourt, item:WeightedORebOppOffCourt, 
	item:WeightedDRebForOffCourt, item:WeightedDRebOppOffCourt');



