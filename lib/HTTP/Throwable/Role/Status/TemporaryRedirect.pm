package HTTP::Throwable::Role::Status::TemporaryRedirect;
use Moose::Role;

with(
  'HTTP::Throwable',
  'HTTP::Throwable::Role::BoringText',
);

sub default_status_code { 307 }
sub default_reason      { 'Temporary Redirect' }

has 'location' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
);

has 'additional_headers' => ( is => 'ro', isa => 'ArrayRef' );

around 'build_headers' => sub {
    my $next    = shift;
    my $self    = shift;
    my $headers = $self->$next( @_ );
    push @$headers => ('Location' => $self->location);
    if ( my $additional_headers = $self->additional_headers ) {
        push @$headers => @$additional_headers;
    }
    $headers;
};

no Moose::Role; 1;

__END__

# ABSTRACT: 307 Temporary Redirect

=head1 DESCRIPTION

The requested resource resides temporarily under a different URI.
Since the redirection MAY be altered on occasion, the client
SHOULD continue to use the Request-URI for future requests.
This response is only cacheable if indicated by a Cache-Control
or Expires header field.

The temporary URI SHOULD be given by the Location field in the
response. Unless the request method was HEAD, the entity of the
response SHOULD contain a short hypertext note with a hyperlink
to the new URI(s), since many pre-HTTP/1.1 user agents do not
understand the 307 status. Therefore, the note SHOULD contain
the information necessary for a user to repeat the original
request on the new URI.

=attr location

This is a required string, which will be used in the Location header
when creating a PSGI response.

=attr additional_headers

This is an optional ArrayRef containing HTTP headers that will be
included when creating the PSGI response.




