#!/usr/local/bin/perl

use strict;
use warnings;
use Getopt::Long;
use File::Basename;
use Data::Dumper;

use Rent::Service::Endeca;


my $prg = basename( $0 );

my $usage = <<EOT;
usage: $prg
    --property_id id
    [--verbose|--terse]
EOT

my $property_id;
my $verbose;
my $terse;

unless ( GetOptions(
        'property_id=i' => \$property_id,
        'verbose'       => \$verbose,
        'terse'         => \$terse,
        ) && @ARGV == 0 && defined $property_id ) {
    warn $usage;
    exit 1;
}

my $endeca = Rent::Service::Endeca->connect();

my $res = $endeca->search_listings( 
    { 
        select  => [ qw( property_id ) ],               # not sure what effect this has
        where   => { propertyid => $property_id },
        order   => [ [ 'propertyid', 'ASC' ] ],
    }
);

if ( ! @{$res->records()} ) {
    warn "$prg: no records found.\n";
}
else {
    foreach my $listing ( @{$res->records()} ) {
        $terse 
            ? showTerse( $listing )
            : $verbose
            ? showVerbose( $listing )
            : showStandard( $listing );
    }
}

sub showTerse {
    my $listing = shift;
    printf "%d: %s\n",
        $listing->listing_id,
        $listing->listing_name
    ;
}

sub showStandard {
    my $listing = shift;
    printf "%s, City: %s, %s, Type: %s, Price Range: \$%.02f - \$%.02f, %d image%s\n",
        $listing->listing_name,
        $listing->city,
        $listing->state_code,
        $listing->listing_type,
        $listing->price_low,
        $listing->price_high,
        scalar @{$listing->listing_images},
        @{$listing->listing_images} == 1 ? '' : 's'
    ;
}

sub showVerbose {
    my $listing = shift;
    print "******\n", Dumper( $listing ), "\n";
}


exit 0;

