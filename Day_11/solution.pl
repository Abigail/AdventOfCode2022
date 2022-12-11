#!/opt/perl/bin/perl

use 5.028;

use strict;
use warnings;
no  warnings 'syntax';

use experimental 'signatures';
use experimental 'lexical_subs';

@ARGV = "input" unless @ARGV;

use List::Util qw [product];

#
# Read in the input, split by paragraph (each paragraph describes a monkey)
#
$/ = "";
my @input = <>;

my $ITEMS      = "items";
my $OPERATION  = "operation";
my $TEST       = "test";
my $TRUE       = "true";
my $FALSE      = "false";
my $INSPECTS   = "inspects";

sub parse_monkey ($input, $modulo = undef) {
    my $monkey = {};
    foreach my $line (split /\n/ => $input) {
        next if $line =~ /^Monkey/;
        my ($key, $value) = $line =~ /^\s*([^:]+):\s*(.*)/;
        if ($key =~ /Starting/) {
            $$monkey {$ITEMS} = [$value =~ /[0-9]+/g] or die;
            next;
        }
        if ($key =~ /Operation/) {
            if ($value =~ /^new \s+ = \s+
                            old \s+ (?<op>[+*]) \s+ (?<arg>[0-9]+|old)/x) {
                my $op  = $+ {op};
                my $arg = $+ {arg};
                if ($modulo) {
                    $$monkey {$OPERATION} = sub ($old) {
                        my $val = $arg eq "old" ? $old : $arg;
                        ($op eq "+" ? $old + $val : $old * $val) % $modulo;
                    }
                }
                else {
                    $$monkey {$OPERATION} = sub ($old) {
                        use integer;
                        my $val = $arg eq "old" ? $old : $arg;
                        ($op eq "+" ? $old + $val : $old * $val) / 3;
                    };
                }
            }
            else {
                die "Failed to parse |$value|\n";
            }
            next;
        }
    if ($key =~ /Test/) {
       ($$monkey {$TEST}) = $value =~ /divisible by ([0-9]+)/ or die;
       next;
    }
    if ($key =~ /If \s+ (true|false)/x) {
       my $key = $1 eq "true" ? $TRUE : $FALSE;
       ($$monkey {$key}) = $value =~ /throw to monkey ([0-9]+)/ or die;
       next;
    }
        die "Failed to parse $line";
    }
    $$monkey {$INSPECTS} = 0;
    $monkey;
}

#
# Parse the input -- twice.
#
my $monkeys1;   # The set of monkeys for part 1.
my $monkeys2;   # The set of monkeys for part 2.
push @$monkeys1 => parse_monkey $_ for @input;

#
# Get the least common multiply of the "divisible by" tests. They're all
# prime numbers, so we can just multiply them. We need this for our second
# parse.
#
my $lcm  = product map {$$_ {$TEST}} @$monkeys1;
push @$monkeys2 => parse_monkey $_, $lcm for @input;


#
# Play a single round. In each round, each monkey inspects all its
# items in turn, then throws each of them.
#
sub play_a_round ($monkeys) {
    foreach my $monkey (@$monkeys) {
        foreach my $item (@{$$monkey {$ITEMS}}) {
            $item = $$monkey {$OPERATION} -> ($item);
            my $target = $item % $$monkey {$TEST} == 0 ? $$monkey {$TRUE}
                                                       : $$monkey {$FALSE};
            push @{$$monkeys [$target] {$ITEMS}} => $item;
            $$monkey {$INSPECTS} ++;
        }
        #
        # Monkey has thrown all items, so clear its set
        #
        $$monkey {$ITEMS} = [];
    }
}

play_a_round $monkeys1 for 1 ..     20;
say "Solution 1: ",
     product +(sort {$b <=> $a} map {$$_ {$INSPECTS}} @$monkeys1) [0, 1];

play_a_round $monkeys2 for 1 .. 10_000;
say "Solution 2: ",
     product +(sort {$b <=> $a} map {$$_ {$INSPECTS}} @$monkeys2) [0, 1];


__END__
