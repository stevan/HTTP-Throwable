package HTTP::Throwable::Role::Status::NotModified;
use Moose::Role;

use Plack::Util ();

with 'HTTP::Throwable';

sub default_status_code { 304 }
sub default_reason      { 'Not Modified' }

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

around 'as_psgi' => sub {
    my $next = shift;
    my $self = shift;
    my $psgi = $self->$next();
    # MUST NOT have a message body, see below
    Plack::Util::header_set( $psgi->[1], 'Content-Length' => 0 );
    $psgi->[2] = [];
    $psgi;
};

__PACKAGE__->meta->make_immutable;

no Moose; 1;

__END__

# ABSTRACT: 304 Not Modified

=head1 DESCRIPTION

If the client has performed a conditional GET request and access
is allowed, but the document has not been modified, the server
SHOULD respond with this status code. The 304 response MUST NOT
contain a message-body, and thus is always terminated by the
first empty line after the header fields.

The response MUST include the following header fields:

=over 4

=item Date, unless its omission is required by section 14.18.1

=back

If a clockless origin server obeys these rules, and proxies and
clients add their own Date to any response received without one
(as already specified by [RFC 2068], section 14.19), caches will
operate correctly.

=over 4

=item ETag and/or Content-Location, if the header would have been
      sent in a 200 response to the same request

=item Expires, Cache-Control, and/or Vary, if the field-value might
      differ from that sent in any previous response for the same
      variant

If the conditional GET used a strong cache validator, the response
SHOULD NOT include other entity-headers. Otherwise (i.e., the conditional
GET used a weak validator), the response MUST NOT include other
entity-headers; this prevents inconsistencies between cached
entity-bodies and updated headers.

If a 304 response indicates an entity not currently cached, then
the cache MUST disregard the response and repeat the request without
the conditional.

If a cache uses a received 304 response to update a cache entry,
the cache MUST update the entry to reflect any new field values
given in the response.

=attr location

This is a required string, which will be used in the Location header
when creating a PSGI response.

=attr additional_headers

This is an required ArrayRef containing HTTP headers that will be
included when creating the PSGI response. This can be used to conform
to the spec shown above.



