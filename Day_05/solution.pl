#!/opt/perl/bin/perl

use 5.032;

use strict;
use warnings;
no  warnings 'syntax';

use experimental 'signatures';
use experimental 'lexical_subs';

@ARGV = "input" unless @ARGV;

#
# Initialize the stacks. We use two, initially identical, sets
# so we can solve both parts at once.
#
my @stacks1;
my @stacks2;

while (<>) {
    last if /^\s*1/;
    my $i = 1;
    while (/(?:   |\[([A-Z])\]) ?/g) {
        unshift @{$stacks1 [$i]} => $1 if $1;
        unshift @{$stacks2 [$i]} => $1 if $1;
        $i ++;
    }
}

<>; # Skip blank line

#
# Now we can process the rest of the input
#
while (<>) {
    my ($amount, $from, $to) = /[0-9]+/g;
    push @{$stacks1 [$to]} => pop    @{$stacks1 [$from]} for 1 .. $amount;
    push @{$stacks2 [$to]} => splice @{$stacks2 [$from]},       - $amount;
}

#
# Print the answers
#
say "Solution 1: ", join "" => map {$$_ [-1]} @stacks1 [1 .. $#stacks1];
say "Solution 2: ", join "" => map {$$_ [-1]} @stacks2 [1 .. $#stacks2];

