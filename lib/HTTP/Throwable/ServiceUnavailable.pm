package HTTP::Throwable::ServiceUnavailable;
use Moose;
use MooseX::StrictConstructor;

extends 'HTTP::Throwable';

has '+status_code' => ( default => 503 );
has '+reason'      => ( default => 'Service Unavailable' );

has 'retry_after' => ( is => 'ro', isa => 'Str' );

around 'build_headers' => sub {
    my $next    = shift;
    my $self    = shift;
    my $headers = $self->$next( @_ );
    if ( my $retry = $self->retry_after ) {
        push @$headers => ('Retry-After' => $retry);
    }
    $headers;
};

__PACKAGE__->meta->make_immutable;

no Moose; 1;

__END__

# ABSTRACT: 503 Service Unavailable

=head1 DESCRIPTION

The server is currently unable to handle the request due to
a temporary overloading or maintenance of the server. The
implication is that this is a temporary condition which will
be alleviated after some delay. If known, the length of the
delay MAY be indicated in a Retry-After header. If no
Retry-After is given, the client SHOULD handle the response as
it would for a 500 response.

  Note: The existence of the 503 status code does not imply that a
  server must use it when becoming overloaded. Some servers may wish
  to simply refuse the connection.


