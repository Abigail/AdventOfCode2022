#!/opt/perl/bin/perl

use 5.028;

use strict;
use warnings;
no  warnings 'syntax';

use experimental 'signatures';
use experimental 'lexical_subs';

@ARGV = "input" unless @ARGV;
# @ARGV = "example-1";

my $STRING_LENGTH = 2;
my @string = map {[0, 0]} 1 .. $STRING_LENGTH;

my ($head_x, $head_y, $tail_x, $tail_y) = (0) x 4;
my %visited1;

my $X = 0;
my $Y = 1;

sub show {
    foreach my $y (reverse 0 .. 4) {
        foreach my $x (0 .. 5) {
            my $field = ".";
            foreach my $i (keys @string) {
                if ($string [$i] [$X] == $x && $string [$i] [$Y] == $y) {
                    $field = $i || "H";
                    last;
                }
            }
            print $field;
        }
        print "\n";
    }
    print "\n";
}

while (<>) {
    my ($direction, $distance) = split;
    #
    # Move the head
    #
    # say "== $direction $distance ==";
    foreach (1 .. $distance) {
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
        foreach my $piece (1 .. $STRING_LENGTH - 1) {
            #
            # If the piece is touching the previous piece after it moves
            # the piece will not move
            #
            if (abs ($string [$piece - 1] [$X] - $string [$piece] [$X]) <= 1 &&
                abs ($string [$piece - 1] [$Y] - $string [$piece] [$Y]) <= 1) {
                next;
            }
            #
            # Otherwise, the previous piece is a knights move away from the
            # current piece.
            # Move the current piece in the same row/column where the
            # distance is 1 and next to the current piece in the
            # row/column where the distance is 2.
            #
            if (abs ($string [$piece - 1] [$X] - $string [$piece] [$X]) == 2) {
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
        # show ();

        $visited1 {$string [1] [$X], $string [1] [$Y]} ++;
    }
}

=pod

foreach my $y (reverse (($min_y - 1) .. ($max_y + 1))) {
    foreach my $x (($min_x - 1) .. ($max_x + 1)) {
        print $visited {$x, $y} ? "#" : ".";
    }
    print "\n";
}

=cut

say "Solution 1: ", scalar keys %visited1;
