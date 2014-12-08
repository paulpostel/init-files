#!/usr/local/bin/perl

package SkipList::Content::Num;

use Moose;
use MooseX::StrictConstructor;

with qq/SkipList::Content/;

sub compare {
    my $self = shift;
    my $other = shift;

    $self->value <=> $other->value;
}


__PACKAGE__->meta->make_immutable;
