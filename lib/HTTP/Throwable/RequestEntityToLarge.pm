package HTTP::Throwable::RequestEntityToLarge;
use Moose;

extends 'HTTP::Throwable';

has '+status_code' => ( default => 412 );
has '+reason'      => ( default => 'Request Entity To Large' );

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

# ABSTRACT: 412 Request Entity To Large

=head1 DESCRIPTION

The server is refusing to process a request because the request
entity is larger than the server is willing or able to process.
The server MAY close the connection to prevent the client from
continuing the request.

If the condition is temporary, the server SHOULD include a
Retry-After header field to indicate that it is temporary and
after what time the client MAY try again.

=head1 ATTRIBUTES

=attr retry_after

This is an optional string to be used to add a Retry-After header
in the PSGI response.
