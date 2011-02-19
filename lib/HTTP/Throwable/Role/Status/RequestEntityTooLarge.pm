package HTTP::Throwable::Role::Status::RequestEntityTooLarge;
use Moose::Role;

with(
  'HTTP::Throwable',
  'HTTP::Throwable::Role::BoringText',
);

sub default_status_code { 413 }
sub default_reason      { 'Request Entity Too Large' }

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

no Moose::Role; 1;

__END__

# ABSTRACT: 413 Request Entity Too Large

=head1 DESCRIPTION

The server is refusing to process a request because the request
entity is larger than the server is willing or able to process.
The server MAY close the connection to prevent the client from
continuing the request.

If the condition is temporary, the server SHOULD include a
Retry-After header field to indicate that it is temporary and
after what time the client MAY try again.

=attr retry_after

This is an optional string to be used to add a Retry-After header
in the PSGI response.
