#!perl -T
use strict;
use warnings;
use Test::More tests => 1;
use NetHack::Logfile ':all';
use File::Temp qw/tempfile/;

my $logfile = << "LOGFILE";
3.4.3 3821910 7 -5 47 311 437 0 20051117 20051115 1031 Mon Hum Mal Cha Eidolos,ascended
3.4.3 106150 7 -5 50 997 1083 0 20070414 AAAHHH!! 20070414 1031 Hea Gno Mal Neu Conducty1,ascended
3.4.3 1210734 7 -5 49 117 143 0 20070704 20070704 1031 Val Dwa Fem Law Eidolos,ascended
LOGFILE

my @logfile = map { parse_logline($_) } split /\n/, $logfile;
delete $logfile[1]{uid};

# just need a temp filename
my ($fh, $filename) = tempfile(UNLINK => 1);
close $fh;

eval { write_logfile(\@logfile, $filename) };
like($@, qr/^Missing key 'uid' in logline hash/, "write_logfile reports missing information");

