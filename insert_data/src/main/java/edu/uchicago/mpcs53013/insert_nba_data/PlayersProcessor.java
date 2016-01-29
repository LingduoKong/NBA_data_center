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

public abstract class PlayersProcessor {
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
			processPlayers(playerFromline(line), file);
		} catch(MissingDataException e) {
			// Just ignore lines with missing data
		}
	}
	
	abstract void processPlayers(Players player, File file) throws IOException;
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
	
	
	Players player;
	
	Players playerFromline(String line) throws NumberFormatException, MissingDataException {
		id++;
		String[] strs = line.split("\\t+");
//		for (String str : strs) {
//			System.out.println(str);
//		}
		if (strs.length < 9) {
			return player;
		}
		if (strs.length == 9) {
			player
			= new Players(
					id,
				  Integer.parseInt(strs[0]),
				  strs[1],
				  strs[2].replace(",", ""),
				  strs[3],
				  strs[4],
				  strs[5],
				  0,
				  strs[6],
				  strs[7],
				  strs[8]);
			return player;
		}
		player
			= new Players(
					id,
				  Integer.parseInt(strs[0]),
				  strs[1],
				  strs[2].replace(",", ""),
				  strs[3],
				  strs[4],
				  strs[5],
				  strs[6].equals("NULL") ? 0 : Double.parseDouble(strs[6]),
				  strs[7],
				  strs[8],
				  strs[9]
		);
		return player;
	}
}
