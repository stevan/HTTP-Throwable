package HTTP::Throwable::UnsupportedMediaType;
use Moose;

extends 'HTTP::Throwable';

has '+status_code' => ( default => 415 );
has '+reason'      => ( default => 'Unsupported Media Type' );

__PACKAGE__->meta->make_immutable;

no Moose; 1;

__END__

# ABSTRACT: 415 Unsupported Media Type

=head1 DESCRIPTION

The server is refusing to service the request because the entity
of the request is in a format not supported by the requested resource
for the requested method.

