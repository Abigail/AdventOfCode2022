#!/opt/perl/bin/perl

use 5.032;

use strict;
use warnings;
no  warnings 'syntax';

use experimental 'signatures';
use experimental 'lexical_subs';

@ARGV = "input" unless @ARGV;

$_ = <>;
    /(.)
     ((??{"[^$1]"}))
     ((??{"[^$1$2]"}))
     ((??{"[^$1$2$3]"}))/x
     and say "Solution 1: ", 1 + $- [-1];
/(.)
 ((??{"[^$1]"}))
 ((??{"[^$1$2]"}))
 ((??{"[^$1$2$3]"}))
 ((??{"[^$1$2$3$4]"}))
 ((??{"[^$1$2$3$4$5]"}))
 ((??{"[^$1$2$3$4$5$6]"}))
 ((??{"[^$1$2$3$4$5$6$7]"}))
 ((??{"[^$1$2$3$4$5$6$7$8]"}))
 ((??{"[^$1$2$3$4$5$6$7$8$9]"}))
 ((??{"[^$1$2$3$4$5$6$7$8$9$10]"}))
 ((??{"[^$1$2$3$4$5$6$7$8$9$10$11]"}))
 ((??{"[^$1$2$3$4$5$6$7$8$9$10$11$12]"}))
 ((??{"[^$1$2$3$4$5$6$7$8$9$10$11$12$13]"}))/x
 and say "Solution 2: ", 1 + $- [-1];
