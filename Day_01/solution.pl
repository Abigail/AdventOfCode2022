#!/opt/perl/bin/perl

use 5.032;

use strict;
use warnings;
no  warnings 'syntax';

use experimental 'signatures';
use experimental 'lexical_subs';

use List::Util qw [sum];

@ARGV = "input" unless @ARGV;

$/ = "";
my @calories = sort {$b <=> $a} map {sum split} <>;

say "Solution 1: ",     $calories [0];
say "Solution 2: ", sum @calories [0 .. 2];


__END__
