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

print header, start_html(-title=>'search for player stats',-head=>Link({-rel=>'stylesheet',-href=>'https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css',-type=>'text/css'}));

my $records = $hbase->get({
  table => 'lingduokong_player_names_data',
  where => {
    key_begins_with => $player_name
  },
});


print '<div class="container">';
print '<table class="table table-condensed">';
foreach my $record (@$records) {
	print Tr({-class=>"success"},td(cellValue($record, 'item:PlayerTrueName')));
}

print '</table>';
print '</div>';
print end_html;
