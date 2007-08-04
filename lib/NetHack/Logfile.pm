#!perl
package NetHack::Logfile;
use strict;
use warnings;
use base 'Exporter';
use Carp;

our @EXPORT_OK = qw(read_logfile parse_logline write_logfile make_logline);
our %EXPORT_TAGS = (all => \@EXPORT_OK);

=head1 NAME

NetHack::Logfile - reading and writing NetHack's logfiles

=head1 VERSION

Version 0.01 released 04 Aug 07

=cut

our $VERSION = '0.01';

=head1 SYNOPSIS

    use NetHack::Logfile ':all';

    my @scores = read_logfile("logfile");
    @scores = sort { $b->{points} <=> $a->{points} } @scores;
    $#scores = 1999;
    write_logfile(\@scores, "high-scores");

    my $game = parse_logline($scores[0]);
    $game->{death} = 'ascended';
    print make_logline($game), "\n";

=head1 FUNCTIONS

=head2 read_logfile [FILENAME] => ARRAY OF HASHREFS

Takes a file and parses it as a logfile. If any IO error occurs in reading
the file, an exception is thrown. If any error occurs in parsing a logline,
then an empty hash will be returned in its place.

The default value for the filename is "logfile".

=cut

sub read_logfile
{
    my $filename = @_ ? shift : "logfile";
    my @entries;

    open my $handle, '<', $filename
        or Carp::croak "Unable to read $filename for reading: $!";

    while (<$handle>)
    {
        push @entries, parse_logline($_) || {};
    }

    close $handle
        or Carp::croak "Unable to close filehandle: $!";

    return @entries;
}

=head2 parse_logline STRING => HASHREF

Takes a string and attempts to parse it as a logline. If a parse error occurs,
C<undef> is returned. It's easy to fool this module with bogus role, race,
gender, and alignment names, since these are not checked.

=cut

sub parse_logline
{
    my $input = shift;

    return unless my @captures = $input =~
        m{
            ^                     # start of line
            (3.\d.\d+)        [ ] # version
            ([\d\-]+)         [ ] # points
            ([\d\-]+)         [ ] # deathdnum
            ([\d\-]+)         [ ] # deathlev
            ([\d\-]+)         [ ] # maxlvl
            ([\d\-]+)         [ ] # hp
            ([\d\-]+)         [ ] # maxhp
            (\d+)             [ ] # deaths
            (\d+)             [ ] # deathdate
            (\d+)             [ ] # birthdate
            (\d+)             [ ] # uid
            ([A-Z][a-z][a-z]) [ ] # role
            ([A-Z][a-z][a-z]) [ ] # race
            ([MF][ae][lm])    [ ] # gender
            ([A-Z][a-z][a-z]) [ ] # align
            ([^,]+)               # name
            ,                     # literal comma
            (.*)                  # death
            $                     # end of line
        }x;

    my %output;
    @output{qw/version points deathdnum deathlev maxlvl hp maxhp deaths
               deathdate birthdate uid role race gender align name death/}
        = @captures;

    return \%output;
}

=head2 write_logfile ARRAYREF OF HASHREFS, FILENAME

Writes an logfile to FILENAME. If any IO error occurs, it will throw an
exception. If any game is missing required keys, it will throw an exception.

Returns no useful value.

=cut

sub write_logfile
{
    my $entries = shift;
    my $filename = shift;

    open my $handle, '>', $filename
        or Carp::croak "Unable to open '$filename' for writing: $!";

    for my $entry (@$entries)
    {
        print {$handle} (make_logline($entry) || ''), "\n"
            or Carp::croak "Error occurred during print: $!";
    }

    close $handle
        or Carp::croak "Unable to close filehandle: $!";

    return;
}

=head2 make_logline HASHREF => STRING

Takes a hashref and turns it into a logline. If not all keys are present (they
must simply pass through C<defined>), then an exception will be thrown.

=cut

sub make_logline
{
    my $input = shift;
    

    sprintf '%s %d %d %d %d %d %d %d %d %d %d %s %s %s %s %s,%s',
        map
        {
            defined $input->{$_} ? $input->{$_}
                                : Carp::croak
                                    "Missing key '$_' in logline hash."
        }
        qw/version points deathdnum deathlev maxlvl hp maxhp deaths
           deathdate birthdate uid role race gender align name death/;
}

=head1 Field names

The field names are chosen for compatibility with the xlogfile format. I
personally dislike many of them. C'est la vie.

=over 4

=item version

The version of NetHack. Current version is 3.4.3.

=item points

The score when the game ended.

=item dnum

The dungeon branch number where the game ended.

=over 4

=item 0

The Dungeons of Doom

=item 1

Gehennom

=item 2

The Gnomish Mines

=item 3

The Quest

=item 4

Sokoban

=item 5

Fort Ludios

=item 6

Vlad's Tower

=item 7

Elemental Planes

=back

=item deathlev

The dungeon level the game ended on.

=item maxlvl

The deepest dungeon level the character explored.

=item hp

The character's current HP when the game ended.

=item maxhp

The character's maximum HP when the game ended.

=item deaths

The number of times the character died. Ascension doesn't count as a death.
Using up an amulet of life saving does.

=item deathdate

The day (yyyymmdd) the game ended.

=item birthdate

The day (yyyymmdd) the game began.

=item uid

The user ID of the player.

=item role

The character's role (three-letter form, so Wiz not Wizard).

=item race

The character's race (three-letter form, so Dwa not Dwarf).

=item gender

The character's ending gender (three-letter form, so Fem not Female).

=item align

The character's ending align (three-letter form, so Cha not Chaotic).

=item name

The name of the character.

=item death

The way the character died. One hopes it is "ascension".

=back

=head1 AUTHOR

Shawn M Moore, C<< <sartak at gmail.com> >>

=head1 BUGS

No known bugs.

Please report any bugs through RT: email 
C<bug-nethack-logfile at rt.cpan.org>, or browse to
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=NetHack-Logfile>.

=head1 SUPPORT

You can find this documentation for this module with the perldoc command.

    perldoc NetHack::Logfile

You can also look for information at:

=over 4

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/NetHack-Logfile>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/NetHack-Logfile>

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=NetHack-Logfile>

=item * Search CPAN

L<http://search.cpan.org/dist/NetHack-Logfile>

=back

=head1 ACKNOWLEDGEMENTS

Thanks to the NetHack DevTeam for all their hard work.

Thanks NetHack, for kicking oh-so-much ass. Happy twentieth birthday!

=head1 COPYRIGHT & LICENSE

Copyright 2007 Shawn M Moore.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

1;

