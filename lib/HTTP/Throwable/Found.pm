package HTTP::Throwable::Found;
use Moose;
use MooseX::StrictConstructor;

extends 'HTTP::Throwable';

has '+status_code' => ( default => 302 );
has '+reason'      => ( default => 'Found' );

has 'temp_location' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
);

has 'cache_headers' => ( is => 'ro', isa => 'ArrayRef' );

around 'build_headers' => sub {
    my $next    = shift;
    my $self    = shift;
    my $headers = $self->$next( @_ );
    push @$headers => ('Location' => $self->temp_location);
    if ( my $cache_headers = $self->cache_headers ) {
        push @$headers => @$cache_headers;
    }
    $headers;
};

__PACKAGE__->meta->make_immutable;

no Moose; 1;

__END__

# ABSTRACT: 302 Found

=head1 DESCRIPTION

The requested resource resides temporarily under a different URI.
Since the redirection might be altered on occasion, the client
SHOULD continue to use the Request-URI for future requests. This
response is only cacheable if indicated by a Cache-Control or
Expires header field.

The temporary URI SHOULD be given by the Location field in the
response. Unless the request method was HEAD, the entity of the
response SHOULD contain a short hypertext note with a hyperlink
to the new URI(s).

=attr temp_location

This is a required string, which will be used in the Location header
when creating a PSGI response.

=attr cache_headers

This is an optional ArrayRef containing HTTP headers that will be
included when creating the PSGI response.


