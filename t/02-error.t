#!perl -T
use strict;
use warnings;
use Test::More tests => 3;
use NetHack::Logfile qw/parse_logline make_logline/;

my $very_bad = '3.4.3 foo bar baz';

is(parse_logline($very_bad), undef, "obviously bad logline parses to undef");

my $bad_hash =
{
    foo => 'oof',
};

eval { make_logline($bad_hash) };
like($@, qr/^Missing key 'version' in logline hash/,
         "obviously crummy logline doesn't parse");

my $overfull_hash =
{
    realtime  => 9883,
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
my $expected = '3.4.3 896462 7 -5 47 107 107 0 20070601 20070601 1031 Wiz Elf Fem Cha Eidolos,ascended';

is(make_logline($overfull_hash), $expected, "extra keys are OK");

