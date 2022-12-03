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
my %group;
my $elves  = 0;

sub prio ($item) {
    $item =~ /\p{Ll}/ ?  1 + ord ($item) - ord ('a')
                      : 27 + ord ($item) - ord ('A');
}

while (<>) {
    chomp;
    my %first    = map  {$_ => 1}     split // => substr $_, 0, length ($_) / 2;
    #
    # There may be more than one item in the second rucksack which appears
    # in the first, but they will be the same. So, it's safe to take the
    # first match.
    #
    my ($common) = grep {$first {$_}} split // => substr $_,    length ($_) / 2;
    $score1 += prio ($common);

    #
    # For each group, calculate how often an item appears in each
    # off the rucksacks. Do *not* count an item which appear multiple
    # times in the same rucksack more than once. There are such cases,
    # even in the example.
    #
    my %seen;
    $group {$_} ++ for grep {!$seen {$_} ++} split //;

    if (++ $elves == 3) {
        #
        # Processed three elves, find the common item. This is the
        # item with value 3 in %group. Add its priority to the score.
        #
        $score2 += prio grep {$group {$_} == 3} keys %group;
        #
        # Reset for next group.
        #
        %group = ();
        $elves = 0;
    }
}

say "Solution 1: ", $score1;
say "Solution 2: ", $score2;
