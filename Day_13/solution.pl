#!/opt/perl/bin/perl

use 5.032;

use strict;
use warnings;
no  warnings 'syntax';

use experimental 'signatures';
use experimental 'lexical_subs';

use List::Util qw [sum product];

@ARGV = "input" unless @ARGV;

#
# Read in the data, eval it to make it nested lists.
#
my @packets = map {eval} grep {/^[][0-9,]+$/} <>;

sub compare ($first, $second) {
    return $first <=> $second            if !ref ($first) && !ref ($second);
    return compare ([$first],  $second)  if !ref ($first);
    return compare ( $first , [$second]) if                  !ref ($second);
    return  0                            if !@$first      && !@$second;
    return -1                            if !@$first;
    return  1                            if !@$second;
    return compare ( $$first [0],               $$second [0]) ||
           compare ([@$first [1 .. $#$first]], [@$second [1 .. $#$second]]);
}


say "Solution 1: ", sum map  {1 + $_ / 2}
                    grep {compare ($packets [$_], $packets [$_ + 1]) < 0}
                    grep {$_ % 2 == 0}
                    keys @packets;


my @sorted = sort {compare ($$a [1], $$b [1])} [1, [[2]]], [1, [[6]]], 
                                               map {[0 => $_]} @packets;

say "Solution 2: ", product map  {$_ + 1} 
                            grep {$sorted [$_] [0]} keys @sorted;


__END__
