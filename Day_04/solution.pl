#!/opt/perl/bin/perl

use 5.028;

use strict;
use warnings;
no  warnings 'syntax';

use experimental 'signatures';
use experimental 'lexical_subs';

@ARGV = "input" unless @ARGV;

my $full    = 0;
my $partial = 0;

while (<>) {
    my ($f_start, $f_end, $s_start, $s_end) = /[0-9]+/g;
    $full    ++ if $f_start <= $s_start && $f_end >= $s_end ||
                   $s_start <= $f_start && $s_end >= $f_end;
    $partial ++ unless $f_end < $s_start ||
                       $s_end < $f_start;
}

say "Solution 1:", $full;
say "Solution 2:", $partial;

__END__
