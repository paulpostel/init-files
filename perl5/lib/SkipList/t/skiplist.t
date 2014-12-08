#!/usr/local/bin/perl
##############################################################################
# exercise the skiplist a bit
##############################################################################

use warnings;
use strict;
use Test::More;

use SkipList;

# test add/find/remove with numeric values
my $sl = SkipList->new( content_class => 'SkipList::Content::Num' );
my @on_list = ( qw/1 5 3 7/ );
for ( @on_list ) {
    $sl->add( $_ );
}

my %on_list = map { $_ => 1 } @on_list;
my @check_list = ( @on_list, 0, 2, 4, 6, 8 );
for ( @check_list ) {
    exists $on_list{$_}
        ? ok( $sl->find( $_ ), qq/find "$_"/ )
        : ok( ! $sl->find( $_ ), qq/can't find "$_"/ );
}

for ( @on_list ) {
    ok( $sl->find( $_ ), qq/find "$_"/ );
    ok( $sl->remove( $_ ), qq/remove "$_"/ );
    ok( ! $sl->find( $_ ), qq/can't find "$_"/ );
}

# add them back on to emptied list
for ( @on_list ) {
    $sl->add( $_ );
}
for ( @check_list ) {
    exists $on_list{$_}
        ? ok( $sl->find( $_ ), qq/find "$_"/ )
        : ok( ! $sl->find( $_ ), qq/can't find "$_"/ );
}


# ditto for string list
$sl = SkipList->new( content_class => 'SkipList::Content::String' );

@on_list = ( qw/01 05 03 abc/, "" );
for ( @on_list ) {
    $sl->add( $_ );
}

@check_list = ( @on_list, 1, 3, 5 );
%on_list = map { $_ => 1 } @on_list;
for ( @check_list ) {
    exists $on_list{$_}
        ? ok( $sl->find( $_ ), qq/find "$_"/ )
        : ok( ! $sl->find( $_ ), qq/can't find "$_"/ );
}

for ( @on_list ) {
    ok( $sl->find( $_ ), qq/find "$_"/ );
    ok( $sl->remove( $_ ), qq/remove "$_"/ );
    ok( ! $sl->find( $_ ), qq/can't find "$_"/ );
}

done_testing;

exit 0;
