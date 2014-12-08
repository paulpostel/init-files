#!/usr/local/bin/perl

package SkipList::Content;

use Moose::Role;
use overload '""' => 'to_string';

requires 'compare';

has 'value' => (
    is          => 'ro',
    required    => 1,
);

sub to_string {
    my $self = shift;
    $self->value // 'undef';
}

1;
