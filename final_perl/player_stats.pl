#!/usr/bin/perl -w
# Creates an html table of flight delays by weather for the given route

# Needed includes
use strict;
use warnings;
use 5.10.0;
use HBase::JSONRest;
use CGI qw/:standard/;

# Read the origin and destination airports as CGI parameters

my $player_name = param('player_name');

# Define a connection template to access the HBase REST server
# If you are on out cluster, hadoop-m will resolve to our Hadoop master
# node, which is running the HBase REST server
my $hbase = HBase::JSONRest->new(host => "hadoop-m:2056");

# This function takes a row and gives you the value of the given column
# E.g., cellValue($row, 'delay:rain_delay') gives the value of the
# rain_delay column in the delay family.
# It uses somewhat tricky perl, so you can treat it as a black box
sub cellValue {
    my $row = $_[0];
    my $field_name = $_[1];
    my $row_cells = ${$row}{'columns'};
    foreach my $cell (@$row_cells) {
	if ($$cell{'name'} eq $field_name) {
	    return $$cell{'value'};
	}
    }
    return 'missing';
}

my $records = $hbase->get({
  table => 'lingduokong_player_avg_stats_data',
  where => {
    key_begins_with => $player_name
  },
});


print header, start_html(-title=>'search for player stats',-head=>Link({-rel=>'stylesheet',-href=>'https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css',-type=>'text/css'}));

print '<table class="table table-striped">';
print '<thead>
      <tr>
	<th>SimplePossFor</th>
	<th>SimplePossOpp</th>
	<th>SimplePointsFor</th>
	<th>SimplePointsOpp</th>
      </tr>
    </thead>';
print '<tbody><tr>';
foreach my $record (@$records) {
	print td(cellValue($record, 'item:SimplePossFor'));
	print td(cellValue($record, 'item:SimplePossOpp'));
	print td(cellValue($record, 'item:SimplePointsFor'));
	print td(cellValue($record, 'item:SimplePointsOpp'));
}
print '</tbody></tr>';

print '<thead>
      <tr>
        <th>SimpleORebFor</th>
        <th>SimpleORebOpp</th>
        <th>SimpleDRebFor</th>
        <th>SimpleDRebOpp</th>
      </tr>
    </thead>';
print '<tbody><tr>';
foreach my $record (@$records) {
        print td(cellValue($record, 'item:SimpleORebFor'));
        print td(cellValue($record, 'item:SimpleORebOpp'));
        print td(cellValue($record, 'item:SimpleDRebFor'));
        print td(cellValue($record, 'item:SimpleDRebOpp'));
}
print '</tbody></tr>';


print '<thead>
      <tr>
        <th>WeightedPossForOffCourt</th>
        <th>WeightedPossOppOffCourt</th>
        <th>WeightedPointsForOffCourt</th>
        <th>WeightedPointsOppOffCourt</th>
      </tr>
    </thead>';
print '<tbody><tr>'; 
foreach my $record (@$records) {  
        print td(cellValue($record, 'item:WeightedPossForOffCourt'));
        print td(cellValue($record, 'item:WeightedPossOppOffCourt'));
        print td(cellValue($record, 'item:WeightedPointsForOffCourt'));
        print td(cellValue($record, 'item:WeightedPointsOppOffCourt'));
}
print '</tbody></tr>';

print '<thead>
      <tr>
        <th>WeightedORebForOffCourt</th>
        <th>WeightedORebOppOffCourt</th>
        <th>WeightedDRebForOffCourt</th>
        <th>WeightedDRebOppOffCourt</th>
      </tr>
    </thead>';
print '<tbody><tr>';
foreach my $record (@$records) {
        print td(cellValue($record, 'item:WeightedORebForOffCourt'));
        print td(cellValue($record, 'item:WeightedORebOppOffCourt'));
        print td(cellValue($record, 'item:WeightedDRebForOffCourt'));
        print td(cellValue($record, 'item:WeightedDRebOppOffCourt'));
}
print '</tbody></tr>';

print end_html;
