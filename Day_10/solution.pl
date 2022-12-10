#!/opt/perl/bin/perl

use 5.028;

use strict;
use warnings;
no  warnings 'syntax';

use experimental 'signatures';
use experimental 'lexical_subs';

@ARGV = "input" unless @ARGV;

my $cycle    = 1;
my $register = 1;
my $signal   = 0;

my @instructions = map {chomp; /noop/ ? $_ : ("noop", $_)} <>;
my $display  = "";

foreach (@instructions) {
    #
    # Update the display.
    #
    my $ctr = ($cycle - 1) % 40;  # Position of the CTR.
    $display  .= abs ($ctr - $register) <= 1 ? "#" : " ";
    $display  .= "\n" if $ctr == 39;
    $register += $1 if /^addx\s+(-?[0-9]+)/;
    $signal   += $cycle * $register if ++ $cycle % 40 == 20;
}

say "Solution 1: ",  $signal;
say "Solution 2:\n", $display;

__END__
