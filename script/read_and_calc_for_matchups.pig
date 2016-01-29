register /usr/local/elephant-bird/elephant-bird-core-4.10.jar; 
register /usr/local/elephant-bird/elephant-bird-pig-4.10.jar; 
register /usr/local/elephant-bird/elephant-bird-hadoop-compat-4.10.jar
register /usr/hdp/2.2.8.0-3150/pig/lib/piggybank.jar;
register /usr/hdp/2.2.8.0-3150/hive/lib/libthrift-0.9.0.jar;
register /mnt/scratch/lingduokong/jar/insert_data.jar; 
DEFINE SequenceFileLoader org.apache.pig.piggybank.storage.SequenceFileLoader();  
DEFINE ThriftBytesToTupleDef com.twitter.elephantbird.pig.piggybank.ThriftBytesToTuple('edu.uchicago.mpcs53013.NBAstats.Matchups');
Matchups = load '/inputs/lingduokong/Matchups' using SequenceFileLoader as (key:int, val:bytearray);
Raw_Matchups = foreach Matchups generate FLATTEN(ThriftBytesToTupleDef(val));

DEFINE ThriftBytesToTupleDef com.twitter.elephantbird.pig.piggybank.ThriftBytesToTuple('edu.uchicago.mpcs53013.NBAstats.GameList');
GameList = load '/inputs/lingduokong/GameList' using SequenceFileLoader as (key:int, val:bytearray);
Raw_GameList = foreach GameList generate FLATTEN(ThriftBytesToTupleDef(val));

Raw_Matchups_with_GameDetail = JOIN Raw_GameList BY GameList::GameID, Raw_Matchups BY Matchups::gameID;
Count_Raw_matchups = FOREACH Raw_Matchups_with_GameDetail GENERATE 
	GameList::GameID as GameID,
	GameList::HomeNameFull as hnf,
	GameList::AwayNameFull as anf,
	Matchups::plusMinusHome as pmh,
	Matchups::plusMinusAway as pma,
        Matchups::offensiveReboundsHome as orh,
	Matchups::offensiveReboundsAway as ora,
	Matchups::defensiveReboundsHome as drh,
	Matchups::defensiveReboundsAway as dra;

Matchups_group_by_Game = GROUP Count_Raw_matchups BY GameID;

Count_Matchups_group_by_Game = FOREACH Matchups_group_by_Game GENERATE group as GameID, AVG($1.pmh) as pmh, AVG($1.pma) as pma, AVG($1.orh) as orh, AVG($1.ora) as ora, AVG($1.drh) as drh, AVG($1.dra) as dra;

STORE Count_Matchups_group_by_Game INTO 'hbase://lingduokong_matchups_calc_data' USING org.apache.pig.backend.hadoop.hbase.HBaseStorage('item:pmh,item:pma,item:orh,item:ora,item:drh,item:dra');
