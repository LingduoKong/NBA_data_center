package edu.uchicago.mpcs53013.insert_nba_data;

import java.io.File;
import java.io.IOException;

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.BytesWritable;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.SequenceFile;
import org.apache.hadoop.io.SequenceFile.CompressionType;
import org.apache.hadoop.io.SequenceFile.Writer;
import org.apache.thrift.TException;
import org.apache.thrift.TSerializer;
import org.apache.thrift.protocol.TBinaryProtocol;
import org.apache.thrift.protocol.TProtocol;

import edu.uchicago.mpcs53013.NBAstats.*;

public class SerializeGameList {
	static TProtocol protocol;
	public static void main(String[] args) {
		try {
			Configuration conf = new Configuration();
			conf.addResource(new Path("/etc/hadoop/conf/core-site.xml"));
			conf.addResource(new Path("/etc/hadoop/conf/hdfs-site.xml"));
			final Configuration finalConf = new Configuration(conf);
			final TSerializer ser = new TSerializer(new TBinaryProtocol.Factory());
			GameListProcessor gameListProcessor = new GameListProcessor() {
				Writer writer;
				Writer getWriter(File file) throws IOException {
					if (writer != null) {
						return writer;
					}
					writer = SequenceFile.createWriter(finalConf,
							SequenceFile.Writer.file(
									new Path("/inputs/lingduokong/GameList")),
							SequenceFile.Writer.keyClass(IntWritable.class),
							SequenceFile.Writer.valueClass(BytesWritable.class),
							SequenceFile.Writer.compression(CompressionType.NONE));
					return writer;
				}

				@Override
				void processGameList(GameList gameList, File file) throws IOException {
					// TODO Auto-generated method stub
					try {
						getWriter(file).append(new IntWritable(1), new BytesWritable(ser.serialize(gameList)));;
					} catch (TException e) {
						throw new IOException(e);
					}					
				}
			};
					
			gameListProcessor.processNoaaDirectory(args[0]);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}

