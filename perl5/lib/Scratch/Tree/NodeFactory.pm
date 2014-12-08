#!/usr/local/bin/perl
########################################################################
package Scratch::Tree::NodeFactory;

use Scratch::Tree::Role::Node;

with qq/Scratch::Tree::Role::NodeFactory;

sub newNode {
    my $self = shift;
    my $item = shift;

    Scratch::Tree::Role::Node->new( item => $item );
}

1;


