#!perl -T
use strict;
use warnings;
use Test::More tests => 4;
use NetHack::Logfile ':all';

my $logline = '3.4.3 896462 7 -5 47 107 107 0 20070601 20070601 1031 Wiz Elf Fem Cha Eidolos,ascended';

my $hash =
{
    align     => 'Cha',
    birthdate => 20070601,
    death     => 'ascended',
    deathdate => 20070601,
    deathdnum => 7,
    deathlev  => -5,
    deaths    => 0,
    gender    => 'Fem',
    hp        => 107,
    maxhp     => 107,
    maxlvl    => 47,
    name      => 'Eidolos',
    points    => 896462,
    race      => 'Elf',
    role      => 'Wiz',
    uid       => 1031,
    version   => '3.4.3',
};

my $h2l =  make_logline($hash);
my $l2h = parse_logline($logline);

my $l2h2l =  make_logline($l2h);
my $h2l2h = parse_logline($h2l);

is($h2l,   $logline, "make_logline works");
is($l2h2l, $logline, "make_logline parse_logline make_logline works");

is_deeply($l2h,   $hash, "parse_logline works");
is_deeply($h2l2h, $hash, "parse_logline make_logline parse_logline works");

