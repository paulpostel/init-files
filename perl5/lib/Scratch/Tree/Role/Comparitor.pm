#!/usr/local/bin/perl

my $tree = Scratch::Tree->new( nodeFactory => , comparitor => );
foreach my $item ( @{getItems()} ) {
    $tree->addItem( $item );
}

print "Left:\n";
$tree->traverseLeft();
print "Right:\n";
$tree->traverseRight();

exit 0;

sub getItems {
    my @items = @ARGV;
    \@items;
}

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



########################################################################
package Scratch::Tree::Role::NodeFactory;

use Moose::Role;

requires qq/newNode/;

1;

########################################################################
package Scratch::Tree::Role::Comparitor;

use Moose::Role;

requires qq/compare/;

1;

########################################################################
package Scratch::Tree::Role::Node;

use Moose::Role;

has 'item' => (
    is          => 'ro',
    isa         => 'Item',
    required    => 1,
);

has 'left' => (
    is          => 'rw',
    isa         => 'Node',
    required    => 0,
);

has 'right' => (
    is          => 'rw',
    isa         => 'Node',
    required    => 0,
);

1;

########################################################################
package Scratch::Tree::Node;

with qq/Scratch::Tree::Role::Node/;

1;

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


