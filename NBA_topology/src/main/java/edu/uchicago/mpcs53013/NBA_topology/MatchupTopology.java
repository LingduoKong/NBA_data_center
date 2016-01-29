package edu.uchicago.mpcs53013.NBA_topology;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.hadoop.hbase.HBaseConfiguration;
import org.apache.hadoop.hbase.client.HConnection;
import org.apache.hadoop.hbase.client.HConnectionManager;
import org.apache.hadoop.hbase.client.HTableInterface;
import org.apache.hadoop.hbase.client.Put;
import org.apache.hadoop.hbase.util.Bytes;
import org.apache.storm.hdfs.bolt.HdfsBolt;
import org.apache.storm.hdfs.bolt.format.DefaultFileNameFormat;
import org.apache.storm.hdfs.bolt.format.DelimitedRecordFormat;
import org.apache.storm.hdfs.bolt.rotation.FileSizeRotationPolicy;
import org.apache.storm.hdfs.bolt.rotation.FileSizeRotationPolicy.Units;
import org.apache.storm.hdfs.bolt.sync.CountSyncPolicy;

import backtype.storm.LocalCluster;
import backtype.storm.StormSubmitter;
import backtype.storm.generated.AlreadyAliveException;
import backtype.storm.generated.InvalidTopologyException;
import backtype.storm.spout.SchemeAsMultiScheme;
import backtype.storm.spout.SpoutOutputCollector;
import backtype.storm.task.TopologyContext;
import backtype.storm.topology.BasicOutputCollector;
import backtype.storm.topology.OutputFieldsDeclarer;
import backtype.storm.topology.TopologyBuilder;
import backtype.storm.topology.base.BaseBasicBolt;
import backtype.storm.tuple.Fields;
import backtype.storm.tuple.Tuple;
import backtype.storm.tuple.Values;
import storm.kafka.KafkaSpout;
import storm.kafka.SpoutConfig;
import storm.kafka.StringScheme;
import storm.kafka.ZkHosts;

public class MatchupTopology {

	static class FilterMatchBolt extends BaseBasicBolt {
		@Override
		public void prepare(Map stormConf, TopologyContext context) {
			super.prepare(stormConf, context);
		}

		@Override
		public void execute(Tuple tuple, BasicOutputCollector collector) {
			String report = tuple.getString(0);
			System.out.println(report);
			String[] strs = report.split(",");
			if (strs.length != 7) {
				return;
			}
			String GameId = strs[0];
			String plusMinusHome = strs[1];
			String plusMinusAway = strs[2];
			String offensiveReboundsHome = strs[3];
			String offensiveReboundsAway = strs[4];
			String defensiveReboundsHome = strs[5];
			String defensiveReboundsAway = strs[6];
			
			collector.emit(new Values(GameId, plusMinusHome,plusMinusAway,
					offensiveReboundsHome,offensiveReboundsAway,
					defensiveReboundsHome,defensiveReboundsAway ));
		}

		@Override
		public void declareOutputFields(OutputFieldsDeclarer declarer) {
			declarer.declare(new Fields("GameId","plusMinusHome","plusMinusAway",
					"offensiveReboundsHome","offensiveReboundsAway",
					"defensiveReboundsHome","defensiveReboundsAway" ));
		}
	}


	static class UpdateCurrentMatchBolt extends BaseBasicBolt {
		private org.apache.hadoop.conf.Configuration conf;
		private HConnection hConnection;
		@Override
		public void prepare(Map stormConf, TopologyContext context) {
			try {
				conf = HBaseConfiguration.create();
				conf.set("zookeeper.znode.parent", "/hbase-unsecure");
				hConnection = HConnectionManager.createConnection(conf);
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			super.prepare(stormConf, context);
		}

		@Override
		public void cleanup() {
			try {
				hConnection.close();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			// TODO Auto-generated method stub
			super.cleanup();
		}

		@Override
		public void execute(Tuple input, BasicOutputCollector collector) {
			try {				
				HTableInterface table = hConnection.getTable("lingduokong_matchups_calc_data");
				Put put = new Put(Bytes.toBytes(input.getStringByField("GameId")));
				put.add(Bytes.toBytes("item"), Bytes.toBytes("pmh"), Bytes.toBytes(input.getStringByField("plusMinusHome")));
				put.add(Bytes.toBytes("item"), Bytes.toBytes("pma"), Bytes.toBytes(input.getStringByField("plusMinusAway")));
				put.add(Bytes.toBytes("item"), Bytes.toBytes("orh"), Bytes.toBytes(input.getStringByField("offensiveReboundsHome")));
				put.add(Bytes.toBytes("item"), Bytes.toBytes("ora"), Bytes.toBytes(input.getStringByField("offensiveReboundsAway")));
				put.add(Bytes.toBytes("item"), Bytes.toBytes("drh"), Bytes.toBytes(input.getStringByField("defensiveReboundsHome")));
				put.add(Bytes.toBytes("item"), Bytes.toBytes("dra"), Bytes.toBytes(input.getStringByField("defensiveReboundsAway")));				
				table.put(put);
				table.close();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}

		@Override
		public void declareOutputFields(OutputFieldsDeclarer declarer) {
			// TODO Auto-generated method stub

		}

	}

	public static void main(String[] args) throws AlreadyAliveException, InvalidTopologyException {

		String zkIp = "localhost";

		String zookeeperHost = zkIp +":2181";

		ZkHosts zkHosts = new ZkHosts(zookeeperHost);
		List<String> zkServers = new ArrayList<String>();
		zkServers.add(zkIp);
		SpoutConfig kafkaConfig = new SpoutConfig(zkHosts, "lingduokong_nba_data", "/lingduokong_nba_data","test_id");
		kafkaConfig.scheme = new SchemeAsMultiScheme(new StringScheme());
		kafkaConfig.startOffsetTime = kafka.api.OffsetRequest.EarliestTime();
		kafkaConfig.zkServers = zkServers;
		kafkaConfig.zkRoot = "/lingduokong_nba_data";
		kafkaConfig.zkPort = 2181;
		kafkaConfig.forceFromStart = true;
		KafkaSpout kafkaSpout = new KafkaSpout(kafkaConfig);

		TopologyBuilder builder = new TopologyBuilder();

		builder.setSpout("raw-match-events", kafkaSpout, 1);
		builder.setBolt("filter-match", new FilterMatchBolt(), 1).shuffleGrouping("raw-match-events");
		builder.setBolt("update-current-match", new UpdateCurrentMatchBolt(), 1).fieldsGrouping("filter-match", new Fields("GameId"));


		Map conf = new HashMap();
		conf.put(backtype.storm.Config.TOPOLOGY_WORKERS, 4);
		conf.put(backtype.storm.Config.TOPOLOGY_DEBUG, true);
		if (args != null && args.length > 0) {
			StormSubmitter.submitTopology(args[0], conf, builder.createTopology());
		}   else {
			LocalCluster cluster = new LocalCluster();
			cluster.submitTopology("matchup-topology", conf, builder.createTopology());
		}
	}
}

