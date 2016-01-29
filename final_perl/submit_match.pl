#!/usr/bin/perl -w

# Needed includes
use strict;
use warnings;
use 5.10.0;
use HBase::JSONRest;

use FindBin;

use Scalar::Util qw(blessed);
use Try::Tiny;

use Kafka::Connection;
use Kafka::Producer;

use Data::Dumper;
use CGI qw/:standard/, 'Vars';

my $year_input = param('year');
my $rating_input = param('rating');
my $id_input = param('id');

my $Year = param('Year');
my $Month = param('Month');
my $Day = param('Day');
my $HomeName = param('HomeName');
my $AwayName = param('AwayName');
my $plusMinusHome = param('plusMinusHome');
my $plusMinusAway = param('plusMinusAway');
my $offensiveReboundsHome = param('offensiveReboundsHome');
my $offensiveReboundsAway = param('offensiveReboundsAway');
my $defensiveReboundsHome = param('defensiveReboundsHome');
my $defensiveReboundsAway = param('defensiveReboundsAway');

my ( $connection, $producer );
try {
    #-- Connection
	$connection = Kafka::Connection->new( host => 'hadoop-m.c.mpcs53013-2015.internal', port => 6667 );
	#-- Producer
	$producer = Kafka::Producer->new( Connection => $connection );
	
	my $message = $Year.$Month.$Day.$HomeName.$AwayName.','.$plusMinusHome.','.$plusMinusAway.','.$offensiveReboundsHome.','.$offensiveReboundsAway.','.$defensiveReboundsHome.','.$defensiveReboundsAway;
	my $response = $producer->send(
		'lingduokong_nba_data',
		0,
		$message
	);
} catch {
	if ( blessed( $_ ) && $_->isa( 'Kafka::Exception' ) ) {
		warn 'Error: (', $_->code, ') ',  $_->message, "\n";
		exit;
	} else {
		die $_;
	}
};



print header, start_html(-title=>'Add A Match',-head=>Link({-rel=>'stylesheet',-href=>'https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css',-type=>'text/css'}));
print '<div class="container">';
print '<div class="row">';
print '</div>';

print '<div class="row well">';
print '<p>Match updated</p>';
print '<a href="http://104.197.20.219/kkklllddd/submit_match.html"><p>return to home </p></a>';
print '</div>';

print '</div>';
print end_html;



