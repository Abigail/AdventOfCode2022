#!/opt/perl/bin/perl

use 5.032;

use strict;
use warnings;
no  warnings 'syntax';

use experimental 'signatures';
use experimental 'lexical_subs';

@ARGV = "input" unless @ARGV;
# @ARGV = "example-1";

my @dirs;  # List of directories from top to current directory
my %size;  # Size of each directory.

use List::Util qw [sum];

#
# We are making a few assumptions (which seem to be hold true):
#  - No directory is listed more than once
#  - There are no 'cd' statements going more one than directory up or down
#    (so, no "/" in the argument to cd, other than "/" itself).
#  - We don't cd into a directory which isn't listed in the 'ls' output.
#  - There are no unknown commands, or unexpected outputs of ls.
#  - There is exactly one space between the '$' and the command.
#

while (<>) {
    #
    # We can skip any lines starting with '$ ls' and 'dir', as we
    # do not need to do anything.
    #
    next if /^\$ ls/ || /^dir/;

    #
    # Handle changing directories. We use a stack to keep track of
    # which directory we are currently in, with parent directories
    # deeper down in the stack.
    #
    if (my ($dir) = /^\$ cd\s+(.*)/) {
        if    ($dir eq "/")  {     @dirs  = ("/")}
        elsif ($dir eq "..") {pop  @dirs}
        else                 {push @dirs => $dirs [-1] . "/" . $dir}
    }

    if (my ($size, $file) = /^([0-9]+)\s+(.*)/) {
        #
        # Add the file size to the directory total, and all its
        # parent directories.
        #
        $size {$_} += $size foreach @dirs;
    }
}

#
# For part one, just sum up the values not exceeding 100_000:
#
say "Solution 1: ", sum grep {$_ <= 100_000} values %size;

#
# For part two, find the smallest directory $d such that
# 70_000_000 - $size {"/"} + $size {$d} >= 30_000_000;
#
say "Solution 2: ", $size {(sort {$size {$a} <=> $size {$b}}
                            grep {40_000_000 - $size {"/"} + $size {$_} >= 0}
                            keys %size) [0]};


