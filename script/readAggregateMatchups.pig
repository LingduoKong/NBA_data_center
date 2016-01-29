register /usr/local/elephant-bird/elephant-bird-core-4.10.jar; 
register /usr/local/elephant-bird/elephant-bird-pig-4.10.jar; 
register /usr/local/elephant-bird/elephant-bird-hadoop-compat-4.10.jar
register /usr/hdp/2.2.8.0-3150/pig/lib/piggybank.jar;
register /usr/hdp/2.2.8.0-3150/hive/lib/libthrift-0.9.0.jar;
register /mnt/scratch/lingduokong/jar/insert_data.jar; 
DEFINE SequenceFileLoader org.apache.pig.piggybank.storage.SequenceFileLoader();  
DEFINE ThriftBytesToTupleDef com.twitter.elephantbird.pig.piggybank.ThriftBytesToTuple('edu.uchicago.mpcs53013.NBAstats.AggregateMatchups');
A = load '/inputs/lingduokong/AggregateMathchups' using SequenceFileLoader as (key:int, val:bytearray);
B = foreach A generate FLATTEN(ThriftBytesToTupleDef(val));
c = limit B 10;
dump c;
STORE B INTO 'hbase://lingduokong_aggregatematchups_data' USING org.apache.pig.backend.hadoop.hbase.HBaseStorage('item:league,item:year,item:unitPlayer1ID,item:unitPlayer2ID,item:unitPlayer3ID,item:unitPlayer4ID,item:unitPlayer5ID,item:opponentPlayer1ID,item:opponentPlayer2ID,item:opponentPlayer3ID,item:opponentPlayer4ID,item:opponentPlayer5ID,item:unitPlayer1Name,item:unitPlayer2Name,item:unitPlayer3Name,item:unitPlayer4Name,item:unitPlayer5Name,item:opponentPlayer1Name,item:opponentPlayer2Name,item:opponentPlayer3Name,item:opponentPlayer4Name,item:opponentPlayer5Name,item:observations,item:elapsedSecs,item:possessionsUnit,item:possessionsOpponent,item:pointsScoredUnit,item:pointsScoredOpponent,item:offensiveRtgUnit,item:offensiveRtgOpponent,item:overallRtgUnitVsOpponent,item:overallRtgOpponentVsUnit,item:offensiveReboundsUnit,item:offensiveReboundsOpponent,item:defensiveReboundsUnit,item:defensiveReboundsOpponent,item:offensiveReboundingRateUnit,item:offensiveReboundingRateOpponent,item:defensiveReboundingRateUnit,item:defensiveReboundingRateOpponent');
