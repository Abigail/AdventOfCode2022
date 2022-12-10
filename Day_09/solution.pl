#!/opt/perl/bin/perl

use 5.028;

use strict;
use warnings;
no  warnings 'syntax';

use experimental 'signatures';
use experimental 'lexical_subs';

@ARGV = "input" unless @ARGV;

my $STRING_LENGTH = 9;
my @string = map {[0, 0]} 0 .. $STRING_LENGTH;

my %visited_1;
my %visited_t;

my $X = 0;
my $Y = 1;

while (<>) {
    my ($direction, $distance) = split;
    #
    # Move the head
    #
    foreach my $d (1 .. $distance) {
        #
        # Update the head
        #
        $string [0] [$X] ++ if $direction eq "R";
        $string [0] [$X] -- if $direction eq "L";
        $string [0] [$Y] ++ if $direction eq "U";
        $string [0] [$Y] -- if $direction eq "D";

        #
        # Update the rest of the string
        #
        foreach my $piece (1 .. $STRING_LENGTH) {
            #
            # Case 1: If the current piece is still touching the previous piece
            #         after, it moves the current piece will not move
            #
            if (abs ($string [$piece - 1] [$X] - $string [$piece] [$X]) <= 1 &&
                abs ($string [$piece - 1] [$Y] - $string [$piece] [$Y]) <= 1) {
                next;
            }

            #
            # Case 2: If, after moving, the previous piece is as far away
            #         from the current piece in both the row and column,
            #         move the current one diagonally away from the previous
            #         piece.
            #
            if (abs ($string [$piece - 1] [$X] - $string [$piece] [$X]) ==
                abs ($string [$piece - 1] [$Y] - $string [$piece] [$Y])) {
                $string [$piece] [$X] =
                         $string [$piece] [$X] < $string [$piece - 1] [$X]
                                               ? $string [$piece - 1] [$X] - 1 
                                               : $string [$piece - 1] [$X] + 1;
                $string [$piece] [$Y] =
                         $string [$piece] [$Y] < $string [$piece - 1] [$Y]
                                               ? $string [$piece - 1] [$Y] - 1
                                               : $string [$piece - 1] [$Y] + 1;
                next;
            }

            #
            # Case 3: The previous piece moved away to a place further
            #         away one axis than the other. In that case move
            #         the current piece to the axis as the axis for which
            #         the distance is minimal, and one away in the other.
            #
            if (abs ($string [$piece - 1] [$X] - $string [$piece] [$X]) >
                abs ($string [$piece - 1] [$Y] - $string [$piece] [$Y])) {
                $string [$piece] [$X] =
                         $string [$piece] [$X] < $string [$piece - 1] [$X]
                                               ? $string [$piece - 1] [$X] - 1 
                                               : $string [$piece - 1] [$X] + 1;
                $string [$piece] [$Y] =          $string [$piece - 1] [$Y];
            }
            else {
                $string [$piece] [$Y] =
                         $string [$piece] [$Y] < $string [$piece - 1] [$Y]
                                               ? $string [$piece - 1] [$Y] - 1
                                               : $string [$piece - 1] [$Y] + 1;
                $string [$piece] [$X] =          $string [$piece - 1] [$X];
            }
        }

        $visited_1 {$string [ 1] [$X], $string [ 1] [$Y]} ++;
        $visited_t {$string [-1] [$X], $string [-1] [$Y]} ++;
    }
}

say "Solution 1: ", scalar keys %visited_1;
say "Solution 2: ", scalar keys %visited_t;
