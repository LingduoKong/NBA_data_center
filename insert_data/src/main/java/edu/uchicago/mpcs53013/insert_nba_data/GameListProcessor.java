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

public abstract class GameListProcessor {
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
			processGameList(gameListFromLine(line), file);
		} catch(MissingDataException e) {
			// Just ignore lines with missing data
		}
	}
	
	abstract void processGameList(GameList gameList, File file) throws IOException;
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
	
	GameList gameListFromLine(String line) throws NumberFormatException, MissingDataException {
		String entries[] = line.split("\\t+");
		GameList gameList = new GameList(
				entries[3], 
				entries[1], 
				entries[2], 
				entries[0],
				entries[4],
				entries[5],
				entries[6],
				entries[7],
				entries[8],
				entries[9],
				entries[10],
				entries[11],
				entries[12]);
		return gameList;
	}

}

