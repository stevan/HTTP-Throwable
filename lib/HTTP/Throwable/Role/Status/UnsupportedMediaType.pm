package HTTP::Throwable::Role::Status::UnsupportedMediaType;
use Moose::Role;

with(
    'HTTP::Throwable',
    'HTTP::Throwable::Role::BoringText',
);

sub default_status_code { 415 }
sub default_reason      { 'Unsupported Media Type' }

no Moose::Role; 1;

__END__

# ABSTRACT: 415 Unsupported Media Type

=head1 DESCRIPTION

The server is refusing to service the request because the entity
of the request is in a format not supported by the requested resource
for the requested method.

