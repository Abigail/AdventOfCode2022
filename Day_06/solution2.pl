#!/opt/perl/bin/perl

use 5.032;

use strict;
use warnings;
no  warnings 'syntax';

use experimental 'signatures';
use experimental 'lexical_subs';

@ARGV = "input" unless @ARGV;

$_ = <>;
 /(.{4})(??{$1 =~ m{(.).*\1} ? "(*FAIL)" : ""})/
                  and say "Solution 1: ", $+ [-1];
/(.{14})(??{$1 =~ m{(.).*\1} ? "(*FAIL)" : ""})/
                  and say "Solution 2: ", $+ [-1];

__END__
