package Raisin::Param;

use strict;
use warnings;

use Carp;

sub new {
    my ($class, $kind, $required, $options) = @_;
    my $self = bless {}, $class;

    $self->{required} = $required eq 'required' ? 1 : 0;
    $self->{named} = $kind eq 'named' ? 1 : 0;

    @$self{qw(name type default regex)} = @$options;
    $self;
}

sub required { shift->{required} }
sub named    { shift->{named} }

sub name    { shift->{name} }
sub type    { shift->{type} }
sub default { shift->{default} }
sub regex   { shift->{regex} }

sub validate {
    my ($self, $value) = @_;

    # Required
    # Only optional parameters can has default value
    if ($self->required && !$$value) {
        carp "$self->{name} required but empty!";
        return;
    }

    # Optional and empty
    if (!defined($$value) && !$self->required) {
        #carp STDERR "$self->{name} optional and empty.";
        return 1;
    }

    if ($$value && ref $$value && ref $$value ne 'ARRAY') {
        carp "$self->{name} \$value should be SCALAR or ARRAYREF";
        return;
    }

    my $was_scalar;
    if (ref $$value ne 'ARRAY') {
        $was_scalar = 1;
        $$value = [$$value];
    }

    for my $v (@$$value) {
        if (!$self->type->check($v)) {
            carp "$self->{name} check() failed";
            return;
        }

        if ($self->regex && $v !~ $self->regex) {
            carp "$self->{name} ->regex failed";
            return;
        }

        if (my $in = $self->type->in) {
            $in->(\$v);
        }
    }

    $$value = $$value->[0] if $was_scalar;

    1;
}

1;

__END__

=head1 NAME

Raisin::Param - Parameter class for Raisin.

=head1 DESCRIPTION

Parameter class for L<Raisin>. Validates request paramters.

=head3 required { shift->{required} }

Returns C<true> if it's required parameter.

=head3 named

Returns C<true> if it's path parameter.

=head3 name

Returns parameter name.

=head3 type

Returns paramter type object.

=head3 default

Returns default value if exists or C<undef>.

=head3 regex

Return paramter regex if exists or C<undef>.

=head3 validate

Process and validate parameter. Takes B<reference> as the input paramter.

    $p->validate(\$value);

=cut
