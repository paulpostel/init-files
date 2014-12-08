#!/usr/local/bin/perl
##############################################################################
# Node for a SkipList
##############################################################################

package SkipList::Node;

use warnings;
use strict;

use Moose;
use MooseX::StrictConstructor;
use namespace::autoclean;
use SkipList::Content;

has 'content' => (
    is          => 'ro',
    isa         => 'Maybe[SkipList::Content]',
    required    => 1,
);

has 'next' => (
    is          => 'rw',
    isa         => 'Maybe[SkipList::Node]',
    required    => 0,
);

has 'prior' => (
    is          => 'rw',
    isa         => 'Maybe[SkipList::Node]',
    required    => 0,
);

has 'lower' => (
    is          => 'rw',
    isa         => 'Maybe[SkipList::Node]',
    required    => 0,
);


__PACKAGE__->meta->make_immutable;

1;
