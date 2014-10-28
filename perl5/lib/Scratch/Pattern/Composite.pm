# here's the class for a non-composite instance
#
package Scratch::Pattern::Composite;

use Moose;
use MooseX::StrictConstructor;

with qw/Scratch::Pattern::Composite::Role/;

__PACKAGE__->meta->make_immutable;

1;
