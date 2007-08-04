#!perl -T
use strict;
use warnings;
use Test::More tests => 2;
use NetHack::Logfile ':all';
use File::Temp qw/tempfile/;

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
        deathlev  => -5,
        points    => 106150,
        race      => 'Gno',
        deathdnum => 7,
        death     => 'ascended',
        gender    => 'Mal',
        maxhp     => 1083,
        hp        => 997,
        uid       => 1031,
        align     => 'Neu',
        version   => '3.4.3',
        deaths    => 0,
        birthdate => 20070414,
        name      => 'Conducty1',
        deathdate => 20070414,
        maxlvl    => 50,
        role      => 'Hea',
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

# just need a temp filename
my ($fh, $filename) = tempfile(UNLINK => 1);
close $fh;

write_logfile(\@logfile, $filename);

{
    open my $handle, '<', $filename
        or BAIL_OUT("Unable to open '$filename' for reading: $!");

    my @people;
    while (<$handle>)
    {
        push @people, parse_logline($_);
    }

    is_deeply(\@people, \@logfile, "write_logfile appears to work 1/2");
}

{
    my @people = read_logfile($filename);
    is_deeply(\@people, \@logfile, "write_logfile appears to work 2/2");
}

