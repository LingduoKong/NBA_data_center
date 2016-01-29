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


public abstract class AggregateMatchupsProcessor {
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
			processAggregateMatchups(aggregateMatchupsFromLine(line), file);
		} catch(MissingDataException e) {
			// Just ignore lines with missing data
		}
	}
	
	abstract void processAggregateMatchups(AggregateMatchups aggregateMatchups, File file) throws IOException;
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
	
		
	AggregateMatchups aggregateMatchupsFromLine(String line) throws NumberFormatException, MissingDataException {
		String entries[] = line.split("\\t+");
		AggregateMatchups aggregateMatchups = new AggregateMatchups(
				id,
				entries[0],
				entries[1],
				entries[2].equals("NULL") ? 0 : Double.parseDouble(entries[2]),
				entries[3].equals("NULL") ? 0 : Double.parseDouble(entries[3]),
				entries[4].equals("NULL") ? 0 : Double.parseDouble(entries[4]),
				entries[5].equals("NULL") ? 0 : Double.parseDouble(entries[5]),
				entries[6].equals("NULL") ? 0 : Double.parseDouble(entries[6]),
				entries[7].equals("NULL") ? 0 : Double.parseDouble(entries[7]),
				entries[8].equals("NULL") ? 0 : Double.parseDouble(entries[8]),
				entries[9].equals("NULL") ? 0 : Double.parseDouble(entries[9]),
				entries[10].equals("NULL") ? 0 : Double.parseDouble(entries[10]),
				entries[11].equals("NULL") ? 0 : Double.parseDouble(entries[11]),
				entries[12],
				entries[13],
				entries[14],
				entries[15],
				entries[16],
				entries[17],
				entries[18],
				entries[19],
				entries[20],
				entries[21],
				entries[22].equals("NULL") ? 0 : Double.parseDouble(entries[22]),
				entries[23].equals("NULL") ? 0 : Double.parseDouble(entries[23]),
				entries[24].equals("NULL") ? 0 : Double.parseDouble(entries[24]),
				entries[25].equals("NULL") ? 0 : Double.parseDouble(entries[25]),
				entries[26].equals("NULL") ? 0 : Double.parseDouble(entries[26]),
				entries[27].equals("NULL") ? 0 : Double.parseDouble(entries[27]),
				entries[28].equals("NULL") ? 0 : Double.parseDouble(entries[28]),
				entries[29].equals("NULL") ? 0 : Double.parseDouble(entries[29]),
				entries[30].equals("NULL") ? 0 : Double.parseDouble(entries[30]),
				entries[31].equals("NULL") ? 0 : Double.parseDouble(entries[31]),
				entries[32].equals("NULL") ? 0 : Double.parseDouble(entries[32]),
				entries[33].equals("NULL") ? 0 : Double.parseDouble(entries[33]),
				entries[34].equals("NULL") ? 0 : Double.parseDouble(entries[34]),
				entries[35].equals("NULL") ? 0 : Double.parseDouble(entries[35]),
				entries[36].equals("NULL") ? 0 : Double.parseDouble(entries[36]),
				entries[37].equals("NULL") ? 0 : Double.parseDouble(entries[37]),
				entries[38].equals("NULL") ? 0 : Double.parseDouble(entries[38]),
				entries[39].equals("NULL") ? 0 : Double.parseDouble(entries[39])
				);
			id++;
		return aggregateMatchups;
	}
}
