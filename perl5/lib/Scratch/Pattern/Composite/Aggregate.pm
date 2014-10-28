# here's the aggregate class, it implements the Composite::Role so it behaves like
# simple, single instances.  could have defined a role for this that adds the aggregate too...
package Scratch::Pattern::Composite::Aggregate;

use Moose;
use MooseX::StrictConstructor;

with qw(Scratch::Pattern::Composite::Role);

has 'aggregates' => (
    is          => 'ro',
    isa         => 'ArrayRef[Scratch::Pattern::Composite::Role]',
    required    => 1,
    lazy        => 1,
    builder     => '_build_aggregates',
);

sub _build_aggregates {
    [];
}

sub process {
    my $self = shift;
    $_->process() for @{$self->aggregates};
}


__PACKAGE__->meta->make_immutable;

1;
