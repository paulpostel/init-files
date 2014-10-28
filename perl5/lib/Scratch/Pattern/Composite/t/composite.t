#!/usr/local/bin/perl -w

use strict;

use aliased qw/Scratch::Pattern::Composite/;
use aliased qw/Scratch::Pattern::Composite::Aggregate/;
use Test::More;

my ( $c1, $c2, $c3 );
ok( $c1 = Composite->new( name => 'c1' ), "construct c1" );
ok( $c2 = Composite->new( name => 'c2' ), "construct c2" );
ok( $c3 = Composite->new( name => 'c3' ), "construct c3" );

my ( $c4, $c5, $c6 );
ok( $c4 = Composite->new( name => 'c4' ), "construct c4" );
ok( $c5 = Composite->new( name => 'c5' ), "construct c5" );
ok( $c6 = Composite->new( name => 'c6' ), "construct c6" );

my $a1;
ok( $a1 = Aggregate->new( name => 'a1', aggregates => [ $c4, $c5, $c6 ] ), "construct a1" );
$a1->process();

done_testing();

exit 0;
