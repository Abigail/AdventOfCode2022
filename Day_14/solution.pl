#!/opt/perl/bin/perl

use 5.032;

use strict;
use warnings;
no  warnings 'syntax';

use experimental 'signatures';
use experimental 'lexical_subs';

use List::Util qw [min max];

@ARGV = "input" unless @ARGV;

my ($X, $Y) = (0, 1);
my $DROP    = [500, 0];
my $map     = {};   # Track rocks and sand

#
# Mark the map with rock, given the endpoints of a line segment
#
sub map_rock ($from, $to, $map) {
    $$map {$$from [$X]} {$_} = 1 for min ($$from [$Y], $$to [$Y]) .. 
                                     max ($$from [$Y], $$to [$Y]);
    $$map {$_} {$$from [$Y]} = 1 for min ($$from [$X], $$to [$X]) .. 
                                     max ($$from [$X], $$to [$X]);
}

#
# Drop a unit of sand from a given location, and mark it on
# the map. We cannot go through the floor. Return the y coordinate
# of the place the unit comes to rest.
#
sub drop ($drop, $map, $FLOOR) {
    my ($x, $y) = @$drop;
    DROP: {
        last if $y >= $FLOOR - 1;
        $$map {$x + $_} {$y + 1} or ($x, $y) = ($x + $_, $y + 1) and redo DROP
            for 0, -1, 1;
    }
    $$map {$x} {$y} = 1;
    $y;
}


#
# Read in the data, drop the rocks on the map
#
while (<>) {
    my @points = map {[split /,/]} split /\s*->\s*/;
    $_ and map_rock $points [$_ - 1], $points [$_], $map for keys @points;
}

#
# The "ABYSS" is the lowest level for which there is rock.
# The "FLOOR" is two levels below that.
#
my $ABYSS = max map {keys %{$$map {$_}}} keys %$map;
my $FLOOR = $ABYSS + 2;

my $score_1;
my $score_2;

for (my $units = 0;; $units ++) {
    my $y = drop $DROP, $map, $FLOOR;
    $score_1 ||= $units              if $y >= $ABYSS;
    $score_2   = $units + 1 and last if $$map {$$DROP [$X]} {$$DROP [$Y]};
}


say "Solution 1: ", $score_1;
say "Solution 2: ", $score_2;

__END__
