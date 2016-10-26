# Copyright (C) 2015-2016 Yoann Le Garff, Nicolas Boquet and Yann Le Bras
# navel-definition-collector is licensed under the Apache License, Version 2.0

#-> BEGIN

#-> initialization

package Navel::Definition::Collector 0.1;

use Navel::Base;

use parent 'Navel::Base::Definition';

use JSON::Validator;

use Navel::API::Swagger2::Scheduler;

#-> methods

sub json_validator {
    my $class = shift;

    state $json_validator = JSON::Validator->new->schema(
        Navel::API::Swagger2::Scheduler->new->expand->api_spec->get('/definitions/collector')
    );
}

BEGIN {
    __PACKAGE__->_create_setters(@{__PACKAGE__->json_validator->schema->data->{required}});
}

sub validate {
    my $class = shift;

    $class->SUPER::validate(
        raw_definition => shift,
        validator => sub {
            [
                $class->json_validator->validate(shift)
            ];
        },
        if_possible_suffix_errors_with_key_value => 'name'
    );
}

sub full_name {
    my $self = shift;

    __PACKAGE__ . '.' . $self->{backend} . '.' . $self->{name};
}

# sub AUTOLOAD {}

# sub DESTROY {}

1;

#-> END

__END__

=pod

=encoding utf8

=head1 NAME

Navel::Definition::Collector

=head1 COPYRIGHT

Copyright (C) 2015-2016 Yoann Le Garff, Nicolas Boquet and Yann Le Bras

=head1 LICENSE

navel-definition-collector is licensed under the Apache License, Version 2.0

=cut
