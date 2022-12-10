#!/opt/perl/bin/perl

use 5.028;

use strict;
use warnings;
no  warnings 'syntax';

use experimental 'signatures';
use experimental 'lexical_subs';

@ARGV = "input" unless @ARGV;
# @ARGV = "example-1";

#
# Read in the data. We'll store the forest as a 2-d array of heights.
#
# x coordinate goes up to down
# y coordinate goes left to right
#
my @forest = map {[/[0-9]/g]} <>;

my $visible;  # Track trees which are visible from the side

sub mark ($x, $y, $max_height) {
    if ($forest [$x] [$y] > $$max_height) {
        $$visible {$x, $y} = 1;
        $$max_height = $forest [$x] [$y];
    }
}

#
# Mark trees visible from the left and right
#
foreach my $x (keys @forest) {
    my            $max_height = -1;
    mark $x, $_, \$max_height for         keys @{$forest [$x]};
                  $max_height = -1;
    mark $x, $_, \$max_height for reverse keys @{$forest [$x]};
}

#
# Mark trees visible from top and bottom
#
foreach my $y (keys @{$forest [0]}) {
    my            $max_height = -1;
    mark $_, $y, \$max_height for         keys   @forest;
                  $max_height = -1;
    mark $_, $y, \$max_height for reverse keys   @forest;
}


say "Solution 1: ", scalar keys %$visible;

my $best_scenic = 0;

#
# Just iterate over all the trees, and count the number of visible trees
# in the four directions (right, left, down, up).
#
foreach my $X (keys @forest) {
    foreach my $Y (keys @{$forest [$X]}) {
        my ($see_r, $see_l, $see_d, $see_u) = (0) x 4;
        for (my $y = $Y + 1; $y <  @{$forest [$X]}; $y ++) {  # Count right
            $see_r ++;
            last if $forest [$X] [$y] >= $forest [$X] [$Y];
        }
        for (my $y = $Y - 1; $y >= 0;               $y --) {  # Count left
            $see_l ++;
            last if $forest [$X] [$y] >= $forest [$X] [$Y];
        }
        for (my $x = $X + 1; $x <    @forest;       $x ++) {  # Count down
            $see_d ++;
            last if $forest [$x] [$Y] >= $forest [$X] [$Y];
        }
        for (my $x = $X - 1; $x >= 0;               $x --) {  # Count up
            $see_u ++;
            last if $forest [$x] [$Y] >= $forest [$X] [$Y];
        }
        my   $scenic = $see_r * $see_l * $see_d * $see_u;
        $best_scenic = $scenic if $best_scenic < $scenic;
    }
}

say "Solution 2: ", $best_scenic;


__END__
