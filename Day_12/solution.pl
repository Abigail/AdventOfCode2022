#!/opt/perl/bin/perl

use 5.032;

use strict;
use warnings;
no  warnings 'syntax';

use experimental 'signatures';
use experimental 'lexical_subs';

use List::Util qw [min];

@ARGV = "input" unless @ARGV;


#
# Read in the map. Put the elevation into a 2-d array, and add
# boundary of a really high elevation to the right and bottom.
# Find also the start and finish location.
#
sub read_map () {
    my $area;
    my $y        = 0;
    my $start    = [];
    my $finish   = [];
    my $lowest   = [];
    my $BOUNDARY = ' ';  # ord (' ') == 32 < ord ('a') - 2
    while (<>) {
        my @chars = split //;
        while (my ($x, $char) = each @chars) {
            my $point = [$x, $y];
            if ($char eq 'S') {
                $start  = $point;
                $char   = 'a';
            }
            if ($char eq 'E') {
                $finish = $point;
                $char   = 'z';
            }
            if ($char eq "\n") {
                $char   = $BOUNDARY;
            }
            if ($char eq 'a') {
                push @$lowest => $point;
            }
            $$area [$x] [$y] = ord $char;
        }
        $y ++;
    }
    $$area [$_] [$y] = ord $BOUNDARY for keys @$area;

    return ($area, $start, $finish, $lowest);
}


#
# Given a finish, calculate the length of the shortest path to
# it for all possible starting locations.
#
sub all_distances ($area, $finish) {
    my ($fx, $fy) = @$finish;
    my %seen;  # Tracks places we have been before.
    $seen {$fx, $fy} = 0;

    my @todo = ($finish);
  TODO:
    while (@todo) {
        my ($x, $y) = @{shift @todo};
        for my $d ([1, 0], [-1, 0], [0, 1], [0, -1]) {
            my $cx = $x + $$d [0];
            my $cy = $y + $$d [1];
            #
            # We can only step up 1 in elevation. For the reverse, this
            # means we can only step *down* 1 in elevation.
            #
            next unless $$area [$cx] [$cy] >= $$area [$x] [$y] - 1;
            next if exists $seen {$cx, $cy};  # Already found a path to here.
            $seen {$cx, $cy} = $seen {$x, $y} + 1;
            push @todo => [$cx, $cy];
        }
    }
    return \%seen;
}



my ($area, $start, $finish, $lowest) = read_map;

my $distances = all_distances $area, $finish;

say "Solution 1: ", $$distances {$$start [0], $$start [1]};
say "Solution 2: ", min grep {defined}
                        map  {$$distances {$$_ [0], $$_ [1]}} @$lowest;

__END__
