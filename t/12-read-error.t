#!perl -T
use strict;
use warnings;
use Test::More tests => 1;
use NetHack::Logfile qw(read_logfile write_logfile);
use File::Temp qw/tempfile/;

my $logfile = << "LOGFILE";
3.4.3 3821910 7 -5 47 311 437 0 20051117 20051115 1031 Mon Hum Mal Cha Eidolos,ascended
3.4.3 106150 7 -5 50 997 1083 0 20070414 AAAHHH!! 20070414 1031 Hea Gno Mal Neu Conducty1,ascended
3.4.3 1210734 7 -5 49 117 143 0 20070704 20070704 1031 Val Dwa Fem Law Eidolos,ascended
LOGFILE

my @logfile =
(
    {
        deathlev  => '-5',
        points    => 3821910,
        race      => 'Hum',
        deathdnum => 7,
        death     => 'ascended',
        gender    => 'Mal',
        maxhp     => 437,
        hp        => 311,
        uid       => 1031,
        align     => 'Cha',
        version   => '3.4.3',
        deaths    => 0,
        birthdate => 20051115,
        name      => 'Eidolos',
        deathdate => 20051117,
        maxlvl    => 47,
        role      => 'Mon',
    },
    {
    },
    {
        deathlev  => -5,
        points    => 1210734,
        race      => 'Dwa',
        deathdnum => 7,
        death     => 'ascended',
        gender    => 'Fem',
        maxhp     => 143,
        hp        => 117,
        uid       => 1031,
        align     => 'Law',
        version   => '3.4.3',
        deaths    => 0,
        birthdate => 20070704,
        name      => 'Eidolos',
        deathdate => 20070704,
        maxlvl    => 49,
        role      => 'Val',
    },
);

my ($fh, $filename) = tempfile(UNLINK => 1);

print {$fh} $logfile;
close $fh;

my @games = read_logfile($filename);
is_deeply(\@games, \@logfile, "read_logfile appears to work, even with a misparsed entry");

