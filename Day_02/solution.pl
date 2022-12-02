#!/opt/perl/bin/perl

use 5.032;

use strict;
use warnings;
no  warnings 'syntax';

use experimental 'signatures';
use experimental 'lexical_subs';

use List::Util qw [sum];

@ARGV = "input" unless @ARGV;

#
# There are only 9 different combinations of both players
# throwing either rock, paper, or scissors. So, we just
# precalculate the score of each outcome. We can then 
# calculate the total by looking up each "hand", and 
# summing the total.
#

my ($ELF_ROCK, $ELF_PAPER, $ELF_SCISSORS) = qw [A B C];
my ( $ME_ROCK,  $ME_PAPER,  $ME_SCISSORS) = qw [X Y Z];
my ( $TO_LOSE,  $TO_DRAW,        $TO_WIN) = qw [X Y Z];
my ( $SH_ROCK,  $SH_PAPER,  $SH_SCISSORS) = qw [1 2 3];
my (     $WIN,      $DRAW,         $LOSS) = qw [6 3 0];

#
# Hand scores for part 1.
#
my %score1 = (
    "$ELF_ROCK $ME_ROCK"          => $DRAW + $SH_ROCK,
    "$ELF_ROCK $ME_PAPER"         => $WIN  + $SH_PAPER,
    "$ELF_ROCK $ME_SCISSORS"      => $LOSS + $SH_SCISSORS,
    "$ELF_PAPER $ME_ROCK"         => $LOSS + $SH_ROCK,
    "$ELF_PAPER $ME_PAPER"        => $DRAW + $SH_PAPER,
    "$ELF_PAPER $ME_SCISSORS"     => $WIN  + $SH_SCISSORS,
    "$ELF_SCISSORS $ME_ROCK"      => $WIN  + $SH_ROCK,
    "$ELF_SCISSORS $ME_PAPER"     => $LOSS + $SH_PAPER,
    "$ELF_SCISSORS $ME_SCISSORS"  => $DRAW + $SH_SCISSORS,
);

#
# Hand scores for part 2.
#
my %score2 = (
    "$ELF_ROCK $TO_DRAW"          => $DRAW + $SH_ROCK,
    "$ELF_ROCK $TO_WIN"           => $WIN  + $SH_PAPER,
    "$ELF_ROCK $TO_LOSE"          => $LOSS + $SH_SCISSORS,
    "$ELF_PAPER $TO_LOSE"         => $LOSS + $SH_ROCK,
    "$ELF_PAPER $TO_DRAW"         => $DRAW + $SH_PAPER,
    "$ELF_PAPER $TO_WIN"          => $WIN  + $SH_SCISSORS,
    "$ELF_SCISSORS $TO_WIN"       => $WIN  + $SH_ROCK,
    "$ELF_SCISSORS $TO_LOSE"      => $LOSS + $SH_PAPER,
    "$ELF_SCISSORS $TO_DRAW"      => $DRAW + $SH_SCISSORS,
);

#
# Processing the input
#
chomp (my @input = <>);

say "Solution 1: ", sum map {$score1 {$_}} @input;
say "Solution 2: ", sum map {$score2 {$_}} @input;


__END__
