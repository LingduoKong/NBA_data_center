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
my $year = param('Year');
my $month = param('Month');
my $day = param('Day');
my $homeName = param('HomeName');
my $awayName = param('AwayName');

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
  table => 'lingduokong_matchups_calc_data',
  where => {
    key_begins_with => $year.$month.$day.$homeName.$awayName
  },
});


print header, start_html(-title=>'search for player stats',-head=>Link({-rel=>'stylesheet',-href=>'https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css',-type=>'text/css'}));

print '<table class="table table-striped">';
print '<thread>
        <tr>
        <th>HomeName</th>
        <th>plusMinusHome</th>
        <th>offensiveReboundsHome</th>
        <th>defensiveReboundsHome</th>
        </tr>
      </thread>';
print '<tbody><tr>';
print td($homeName);
foreach my $record (@$records) {
	print td(cellValue($record,'item:drh'));
	print td(cellValue($record,'item:orh'));
	print td(cellValue($record,'item:pmh'));
}
print '<table class="table table-striped">';
print '<thread>
        <tr>
        <th>AwayName</th>
        <th>plusMinusAway</th>
        <th>offensiveReboundsAway</th>
        <th>defensiveReboundsAway</th>
        </tr>
      </thread>';
print '<tbody><tr>';
print td($awayName);
foreach my $record (@$records) {
        print td(cellValue($record,'item:dra'));
        print td(cellValue($record,'item:ora'));
        print td(cellValue($record,'item:pma'));
}

print '</tr></tbody>';
print end_html;
