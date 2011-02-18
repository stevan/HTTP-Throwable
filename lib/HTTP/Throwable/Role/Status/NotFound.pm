package HTTP::Throwable::Role::Status::NotFound;
use Moose;
use MooseX::StrictConstructor;

extends 'HTTP::Throwable';

has '+status_code' => ( default => 404 );
has '+reason'      => ( default => 'Not Found' );

__PACKAGE__->meta->make_immutable;

no Moose; 1;

__END__

# ABSTRACT: 404 Not Found

=head1 DESCRIPTION

The server has not found anything matching the Request-URI.
No indication is given of whether the condition is temporary
or permanent. The 410 (Gone) status code SHOULD be used if
the server knows, through some internally configurable mechanism,
that an old resource is permanently unavailable and has no
forwarding address. This status code is commonly used when
the server does not wish to reveal exactly why the request
has been refused, or when no other response is applicable.

