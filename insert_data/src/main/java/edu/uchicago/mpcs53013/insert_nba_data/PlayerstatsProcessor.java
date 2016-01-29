package edu.uchicago.mpcs53013.insert_nba_data;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.HashMap;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.zip.GZIPInputStream;

import edu.uchicago.mpcs53013.NBAstats.*;


public abstract class PlayerstatsProcessor {
	int id = 0;
	static class MissingDataException extends Exception {

	    public MissingDataException(String message) {
	        super(message);
	    }

	    public MissingDataException(String message, Throwable throwable) {
	        super(message, throwable);
	    }

	}
	
	static double tryToReadMeasurement(String name, String s, String missing) throws MissingDataException {
		if(s.equals(missing))
			throw new MissingDataException(name + ": " + s);
		return Double.parseDouble(s.trim());
	}

	void processLine(String line, File file) throws IOException {
		try {
			processPlayerstats(playerstatsFromline(line), file);
		} catch(MissingDataException e) {
			// Just ignore lines with missing data
		}
	}
	
	abstract void processPlayerstats(PlayerStats player_stats, File file) throws IOException;
	BufferedReader getFileReader(File file) throws FileNotFoundException, IOException {
		return new BufferedReader(new InputStreamReader(new FileInputStream(file)));
	}

	
	void processNoaaFile(File file) throws IOException {		
		BufferedReader br = getFileReader(file);
		br.readLine(); // Discard header
		String line;
		while((line = br.readLine()) != null) {
			processLine(line, file);
		}
	}

	void processNoaaDirectory(String directoryName) throws IOException {
		File directory = new File(directoryName);
		File[] directoryListing = directory.listFiles();
		for(File noaaFile : directoryListing)
			processNoaaFile(noaaFile);
	}
	
	
	PlayerStats player_stats;
	
	PlayerStats playerstatsFromline(String line) throws NumberFormatException, MissingDataException {
		id++;
		String[] strs = line.split("\\t+");
//		for (String str : strs) {
//			System.out.println(str);
//		}
		if (strs.length != 39) {
			System.out.println(line);
			return player_stats;
		} else {
//			for (String str : strs) {
//				System.out.println(str);
//			}	
		}
		player_stats
			= new PlayerStats(
					id,
					Double.parseDouble(strs[0]),
					strs[1],
					strs[2],
					strs[3].equals("NULL") ? 0 : Double.parseDouble(strs[3]),
					strs[4].equals("NULL") ? 0 : Double.parseDouble(strs[4]),
					strs[5].equals("NULL") ? 0 : Double.parseDouble(strs[5]),
					strs[6].equals("NULL") ? 0 : Double.parseDouble(strs[6]),
					strs[7].equals("NULL") ? 0 : Double.parseDouble(strs[7]),
					strs[8].equals("NULL") ? 0 : Double.parseDouble(strs[8]),
					strs[9].equals("NULL") ? 0 : Double.parseDouble(strs[9]),
					strs[10].equals("NULL") ? 0 : Double.parseDouble(strs[10]),
					strs[11].equals("NULL") ? 0 : Double.parseDouble(strs[11]),
					strs[12].equals("NULL") ? 0 : Double.parseDouble(strs[12]),
					strs[13].equals("NULL") ? 0 : Double.parseDouble(strs[13]),
					strs[14].equals("NULL") ? 0 : Double.parseDouble(strs[14]),
					strs[15].equals("NULL") ? 0 : Double.parseDouble(strs[15]),
					strs[16].equals("NULL") ? 0 : Double.parseDouble(strs[16]),
					strs[17].equals("NULL") ? 0 : Double.parseDouble(strs[17]),
					strs[18].equals("NULL") ? 0 : Double.parseDouble(strs[18]),
					strs[19].equals("NULL") ? 0 : Double.parseDouble(strs[19]),
					strs[20].equals("NULL") ? 0 : Double.parseDouble(strs[20]),
					strs[21].equals("NULL") ? 0 : Double.parseDouble(strs[21]),
					strs[22].equals("NULL") ? 0 : Double.parseDouble(strs[22]),
					strs[23].equals("NULL") ? 0 : Double.parseDouble(strs[23]),
					strs[24].equals("NULL") ? 0 : Double.parseDouble(strs[24]),
					strs[25].equals("NULL") ? 0 : Double.parseDouble(strs[25]),
					strs[26].equals("NULL") ? 0 : Double.parseDouble(strs[26]),
					strs[27].equals("NULL") ? 0 : Double.parseDouble(strs[27]),
					strs[28].equals("NULL") ? 0 : Double.parseDouble(strs[28]),
					strs[29].equals("NULL") ? 0 : Double.parseDouble(strs[29]),
					strs[30].equals("NULL") ? 0 : Double.parseDouble(strs[30]),
					strs[31].equals("NULL") ? 0 : Double.parseDouble(strs[31]),
					strs[32].equals("NULL") ? 0 : Double.parseDouble(strs[32]),
					strs[33].equals("NULL") ? 0 : Double.parseDouble(strs[33]),
					strs[34].equals("NULL") ? 0 : Double.parseDouble(strs[34]),
					strs[35].equals("NULL") ? 0 : Double.parseDouble(strs[35]),
					strs[36].equals("NULL") ? 0 : Double.parseDouble(strs[36]),
					strs[37].equals("NULL") ? 0 : Double.parseDouble(strs[37]),
					strs[38].equals("NULL") ? 0 : Double.parseDouble(strs[38])
							);
		return player_stats;
	}
}
