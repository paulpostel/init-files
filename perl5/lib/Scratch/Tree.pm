#!/usr/local/bin/perl

package Scratch::Tree;

use Moose;

has 'root' => (
    is          => 'rw',
    isa         => 'Node',
    required    => 0,
);

has 'comparitor' => (
    is          => 'rw',
    isa         => 'Scratch::Tree::Role::Comparitor',
    required    => 0,
);

has 'nodeFactory' => (
    is          => 'ro',
    isa         => 'Scratch::Tree::Role::NodeFactory',
    required    => 1,
);

sub addItem {
    my $self = shift;
    my $item = shift;

    if ( ! $self->root ) {
        $self->root( $self->nodeFactory->newNode( $item ) );
    }
    else {
        $self->_addTo( $self->root, $item );
    }
}

sub _addTo {
    my $self = shift;
    my $node = shift;
    my $item = shift;

    if ( self->comparitor->compare( $item, $node->item ) < 0 ) {
        if ( ! $node->left ) {
            $node->left( $self->nodeFactory->newNode( $item ) );
        }
        else {
            $self->_addTo( $node->left, $item );
        }
    }
    else {
        if ( ! $node->right ) {
            $node->right( $self->nodeFactory->newNode( $item ) );
        }
        else {
            $self->_addTo( $node->right, $item );
        }
    }
}

sub traverseLeft {
    my $self = shift;
    _traverseLeftFromNode( $self->root );
}

sub _traverseLeftFromNode {
    my $node = shift;
    if ( $node->left ) {
        _traverseLeftFromNode( $node->left );
    }
    print $node->item, "\n";
    if ( $node->right ) {
        _traverseLeftFromNode( $node->right );
    }
}

sub traverseRight {
    my $self = shift;
    _traverseRightFromNode( $self->root );
}

sub _traverseRightFromNode {
    my $node = shift;
    if ( $node->right ) {
        _traverseRightFromNode( $node->right );
    }
    print $node->item, "\n";
    if ( $node->left ) {
        _traverseRightFromNode( $node->left );
    }
}

1;

