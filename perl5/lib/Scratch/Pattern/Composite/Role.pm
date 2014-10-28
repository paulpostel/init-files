# here's the interface we're going to support directly and as a composite, it
# has one property and one method
#
package Scratch::Pattern::Composite::Role;

use Moose::Role;


has 'name' => (
    is          => 'ro',
    isa         => 'Str',
    required    => 1,
);

sub process {
    my $self = shift;
    printf "Processing an instance of %s, named %s\n",
        ref $self, $self->name;
}

1;
