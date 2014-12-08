#!/usr/local/bin/perl
##############################################################################
# simple implementation of a skip list for numeric scalars
##############################################################################

package SkipList;

use warnings;
use strict;

use Moose;
use MooseX::StrictConstructor;
use namespace::autoclean;
use Module::Load;

use SkipList::Node;
use overload    '""' => 'to_string';

has '_lists' => (
    is          => 'ro',
    isa         => 'ArrayRef',
    required    => 1,
    default     => sub { [] },
);

has 'promotion_chance' => (
    is          => 'ro',
    isa         => 'Num',
    required    => 1,
    default     => sub { 0.5 },
);

has 'content_class' => (
    is          => 'ro',
    isa         => 'Str',
    required    => 1,
    default     => sub { 'SkipList::Content::String' },
);

sub BUILD {
    my $self = shift;
    load $self->content_class;
}

sub _content_factory {
    my $self = shift;
    my $value = shift;
    $self->content_class->new( value => $value );
}

sub add {
    my $self = shift;
    my $value = shift;
    $self->_add( 0, $self->_content_factory( $value ), undef );
}

sub find {
    my $self = shift;
    my $value = shift;
    $self->_find_via_content( $self->_lists->[-1], $self->_content_factory( $value ) );
}

sub remove {
    my $self = shift;
    my $value = shift;
    if ( my $node = $self->find( $value ) ) {
        $self->_unlink( $node );        # unlink it

        # unlink from downward lists too
        while ( $node = $node->lower ) {
            $self->_unlink( $node ); 
        }

        # optimization, remove those lists with just a single (marker) entry
        while ( @{$self->_lists} && ! $self->_lists->[-1]->next ) {
            pop @{$self->_lists};
        }
        return 1;
    }
    undef;
}

sub _unlink {
    my $self = shift;
    my $node = shift;

    if ( $node->prior ) {
        $node->prior->next( $node->next );
    }
    if ( $node->next ) {
        $node->next->prior( $node->prior );
    }
}


sub _add {
    my $self = shift;
    my $index = shift;          # index into aref of current list to add to
    my $content = shift;        # content to add into $aref->[$index]
    my $lower_node = shift;     # lower node from which content was promoted (if any)

    my $node = $self->_link_content( $index, $content );
    if ( $self->_promote( $content ) ) {
        $self->_add( $index + 1, $content, $node );
    }
    if ( $lower_node ) {
        $node->lower( $lower_node );
    }
}


sub _find_via_content {
    my $self = shift;
    my $current = shift;
    my $content = shift;

    my $prior;
    while ( $current ) {
        if ( defined $current->content ) {
            my $cmp = $current->content->compare( $content );
            if ( $cmp == 0 ) {
                return $current;       # found it
            }
            elsif ( $cmp == 1 ) {
                # passed it, descend to lower list
                $current = $prior->lower;
                next;
            }
        }
        $prior = $current;
        $current = $current->next;
    }
    $prior && ( ! defined $prior->content || $content->compare( $prior->content ) == 1 )
        ? $self->_find_via_content( $prior->lower, $content )
        : undef;
}

sub _link_content {
    my $self = shift;
    my $index = shift;
    my $content = shift;

    my $node = SkipList::Node->new( content => $content );
    my $prior;
    unless ( $self->_lists->[$index] ) {
        # list is empty, add nil value to start and link to
        # lower list if there is one
        my $starter = SkipList::Node->new( content => undef );
        $self->_lists->[$index] = $starter;
        if ( $index > 0 ) {
            $starter->lower( $self->_lists->[$index - 1] );
        }
    }
    my $current = $self->_lists->[$index];
    while ( $current && ( ! defined $current->content || $node->content->compare( $current->content ) == 1 ) ) {
        $prior = $current;
        $current = $current->next;
    }
    $node->next( $current );
    if ( $current ) {
        $current->prior( $node );
    }
    $node->prior( $prior );
    $prior->next( $node );
    $node;
}

sub _promote {
    my $self = shift;
    my $content = shift;
    rand() <= $self->promotion_chance;
}

sub to_string {
    my $self = shift;

    my $s = '';
    for( my $i = @{$self->_lists} - 1; $i >= 0; $i-- ) {
        my $node = $self->_lists->[$i];
        $s .= "[$i]\n\t";
        my $l = '';
        while ( $node ) {
            $l .= " " if $l;
            $l .= ( $node->content ? $node->content->to_string : 'undef' ) . " ";
            $node = $node->next;
        }
        $s .= "$l\n";
    }
    $s;
}

sub to_full_string {
    my $self = shift;

    my $s = '';
    for( my $i = @{$self->_lists} - 1; $i >= 0; $i-- ) {
        my $node = $self->_lists->[$i];
        $s .= "\n" if $s;
        $s .= "[$i]\n\t";
        my $l = '';
        while ( $node ) {
            $l .= "\n\t" if $l;
            $l .= sprintf qq|(%s[%s] <= %s[%s] / %s[%s] => %s[%s]) |,
                _node_to_str( $node->prior ),
                $node->prior && $node->prior->content ? $node->prior->content->to_string : 'undef',
                _node_to_str( $node ),
                $node && $node->content ? $node->content->to_string : 'undef',
                _node_to_str( $node->lower ),
                $node->lower && $node->lower->content ? $node->lower->content->to_string : 'undef',
                _node_to_str( $node->next ),
                $node->next && $node->next->content ? $node->next->content->to_string : 'undef';
            $node = $node->next;
        }
        $s .= $l;
    }
    $s;
}

sub _node_to_str {
    my $node = shift;
    return 'undef' unless $node;
    my $ns = "$node";
    $ns =~ s/^[^(]*//;
    $ns;
}

__PACKAGE__->meta->make_immutable;

1;
