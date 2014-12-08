#!/usr/local/bin/perl

package SkipList::Content::String;

use Moose;
use MooseX::StrictConstructor;

with qq/SkipList::Content/;

sub compare {
    my $self = shift;
    my $other = shift;

    $self->value cmp $other->value;
}


__PACKAGE__->meta->make_immutable;
