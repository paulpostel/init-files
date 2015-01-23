#!/usr/local/bin/perl

use strict;
use warnings;
use Getopt::Long;
use File::Basename;
use Memoize;
memoize( 'split_list' );

my $prg = basename( $0 );
my $values_str;
my $generate;

my $usage = <<EOT;
usage: $prg 
    [--values "v1,v2,..."]      # split the given list of values
    [--generate n]              # generate a list of n items to split
EOT

unless ( GetOptions( 
        "values=s" => \$values_str,
        "generate=i" => \$generate 
    ) && @ARGV == 0 ) {
    warn $usage;
    exit 1;
}

if ( $values_str && defined $generate ) {
    warn $usage;
    warn "$prg: --values and --generate options are mutually exclusive\n";
    exit 1;
}



my @values = $generate 
    ? generate_values( $generate )
    : split( /\s*,\s*/, $values_str );

if ( my @bad_values = grep { ! /^\d+$/ } @values ) {
    warn $usage;
    warn qq/$prg: all values must be integers, received invalid values:\n/;
    warn join( "\n\t", @bad_values ), "\n";
    exit 1;
}

my $sum = 0;
map { $sum += $_ } @values;

my $split = split_list( $sum / 2, @values );
unless ( @$split ) {
    warn "$prg: could not split " . join( ", ", @values ) . "\n";
    exit 1;
}

print "$prg: split list\n  ", join( ", ", @values ), "\nto:\n  ", join( ", ", @$split ), "\n";

exit 0;

sub split_list {
    my $sum = shift;

    return [] if $sum == 0;
    return undef unless $sum > 0 && @_;

    my ( $v, @sublist ) = @_;
    return [ $v ] if $v == $sum;
    my $list = split_list( $sum - $v, @sublist );
    if ( $list ) {
        return [ $v, @$list ];
    }
    else {
        return split_list( $sum, @sublist );
    }
}

sub generate_values {
    my $n = shift;
    my @n = ( 1..$n );
    my $sum = 0;
    map { $sum += $_ } @n;
    if ( $sum % 2 ) {
        $n[-1] += 1;
    }
    @n;
}
