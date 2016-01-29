register /usr/local/elephant-bird/elephant-bird-core-4.10.jar; 
register /usr/local/elephant-bird/elephant-bird-pig-4.10.jar; 
register /usr/local/elephant-bird/elephant-bird-hadoop-compat-4.10.jar
register /usr/hdp/2.2.8.0-3150/pig/lib/piggybank.jar;
register /usr/hdp/2.2.8.0-3150/hive/lib/libthrift-0.9.0.jar;
register /mnt/scratch/lingduokong/jar/insert_data.jar; 
DEFINE SequenceFileLoader org.apache.pig.piggybank.storage.SequenceFileLoader();  
DEFINE ThriftBytesToTupleDef com.twitter.elephantbird.pig.piggybank.ThriftBytesToTuple('edu.uchicago.mpcs53013.NBAstats.GameList');
A = load '/inputs/lingduokong/GameList' using SequenceFileLoader as (key:int, val:bytearray);
B = foreach A generate FLATTEN(ThriftBytesToTupleDef(val));
c = limit B 10;
dump c;
STORE B INTO 'hbase://lingduokong_gamelist_data' USING org.apache.pig.backend.hadoop.hbase.HBaseStorage('item:Year,item:GameDate,item:League,item:BoxScoreURL,item:PlayByPlayURL,item:HomeNameFull,item:HomeName3,item:AwayNameFull,item:AwayName3,item:HaveBoxScore,item:HavePlayByPlay,item:AnalyzedPlayByPlay');
