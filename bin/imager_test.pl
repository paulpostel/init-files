#!/usr/local/bin/perl -w
use strict;
use Imager;
use File::Basename;

my $prg = basename( $0 );

die "Usage: $prg filename\n" if !-f $ARGV[0];
my $file = shift;

my $format;

# see Imager::Files for information on the read() method
my $img = Imager->new( file=>$file )
    or die Imager->errstr();

$file =~ s/\.[^.]*$//;

# Create smaller version
# documented in Imager::Transformations
my $thumb = $img->scale( scalefactor=>.3 );

# Autostretch individual channels
$thumb->filter( type => 'autolevels' );

# try to save in one of these formats
SAVE:

for $format ( qw( png gif jpeg tiff ppm ) ) {
    # Check if given format is supported
    if ( $Imager::formats{$format} ) {
        $file .= "_low.$format";
        print "Storing image as: $file\n";
        # documented in Imager::Files
        $thumb->write( file => $file )
            or die $thumb->errstr;
        last SAVE;
    }
}

exit 0;
