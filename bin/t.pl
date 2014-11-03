#!/usr/bin/perl

use strict;
use warnings;

my @values = ( 1, 2, 3 );
my %h = map { +1 => $_ } @values;

exit 0;
