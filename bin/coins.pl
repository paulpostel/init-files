#!/usr/local/bin/perl

use strict;
use warnings;

use Getopt::Long;
use File::Basename;

my $prg = basename( $0 );

my $coins;
my $sum;

my $usage = <<EOT;
usage: $prg 
    --coins v1,v2,...   # value for the coins
    --sum value         # total value we're trying to achieve
EOT

unless ( GetOptions(
        'coins=s'       => \$coins,
        'sum=i'         => \$sum,
    ) && $coins && defined $sum ) {
    warn $usage;
    exit 1;
}

my @coins = split /\s*,\s*/, $coins;
if ( my @bad_coins = grep { $_ !~ /^\d+$/ } @coins ) {
    warn $usage;
    warn "$prg: coins must be integer-valued, invalid coins: ", join( ", ", @bad_coins ), "\n";
    exit 1;
}
@coins = sort { $a <=> $b } @coins;

unless ( ! $sum || $coins[0] <= $sum ) {
    warn "$prg: there is no solution, lowest coin value $coins[0] > sum $sum\n";
    exit 1;
}

my %counts = compute_counts( $sum, @coins );
printf "sum = %d, coins = %s, count = %s\n", $sum, join( ",", @coins ), $counts{$sum} // 'insoluble';

exit 0;

sub compute_counts {
    my ( $sum, @coins ) = @_;

    # count of coins req'd for sum of key, e.g. $count{sum} => coint count
    # count for sum of 0 is 0 coins
    my %counts = ( 0 => 0 );

    # compute count for each "interim" sum from 1 - sum
    for ( my $interim = 1; $interim <= $sum; $interim++ ) {

        # examine each coin <= interim
        foreach my $coin ( @coins ) {
            # if this coin + coins for interim - this coin is < current count for interim, remember it
            if ( $coin <= $interim
                    && ( exists $counts{$interim - $coin}
                        && ( ! exists $counts{$interim} || $counts{$interim - $coin} + 1 < $counts{$interim} ) ) ) {
                $counts{$interim} = $counts{$interim - $coin} + 1;
            }
        }
    }
    %counts;
}
