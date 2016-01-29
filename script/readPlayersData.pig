register /usr/local/elephant-bird/elephant-bird-core-4.10.jar; 
register /usr/local/elephant-bird/elephant-bird-pig-4.10.jar; 
register /usr/local/elephant-bird/elephant-bird-hadoop-compat-4.10.jar
register /usr/hdp/2.2.8.0-3150/pig/lib/piggybank.jar;
register /usr/hdp/2.2.8.0-3150/hive/lib/libthrift-0.9.0.jar;
register /mnt/scratch/lingduokong/jar/insert_data.jar; 
DEFINE SequenceFileLoader org.apache.pig.piggybank.storage.SequenceFileLoader();  
DEFINE ThriftBytesToTupleDef com.twitter.elephantbird.pig.piggybank.ThriftBytesToTuple('edu.uchicago.mpcs53013.NBAstats.Players');
A = load '/inputs/lingduokong/Players' using SequenceFileLoader as (key:int, val:bytearray);
B = foreach A generate FLATTEN(ThriftBytesToTupleDef(val));
c = limit B 10;
dump c;
STORE B INTO 'hbase://lingduokong_players_data' USING org.apache.pig.backend.hadoop.hbase.HBaseStorage('item:PlayerID, item:PlayerName, item:PlayerTrueName, item:League, item:TeamName3, item:Year, item:Position, item:Comment, item:StartDate, item:EndDate');
