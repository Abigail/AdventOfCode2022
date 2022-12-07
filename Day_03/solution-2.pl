#!/opt/perl/bin/perl

use 5.032;

use strict;
use warnings;
no  warnings 'syntax';

use experimental 'signatures';
use experimental 'lexical_subs';

@ARGV = "input" unless @ARGV;

my $score1 = 0;
my $score2 = 0;
my $group  = "";
my $elves  = 0;

sub prio ($item) {
    $item =~ /\p{Ll}/ ?  1 + ord ($item) - ord ('a')
                      : 27 + ord ($item) - ord ('A');
}

while (<>) {
    $group .= $_;
    $elves ++;
    my  $ruck = substr ($_, 0, length ($_) / 2) . "\n" .
                substr ($_,    length ($_) / 2);

    my ($c) = $ruck =~ /(.).*\n.*\1/;
    $score1 += prio $c;
    if ($elves == 3) {
        my ($c) = $group =~ /(.).*\n.*\1.*\n.*\1/;
        $score2 += prio $c;
        $elves = 0;
        $group = "";
    }
}

say "Solution 1: ", $score1;
say "Solution 2: ", $score2;
