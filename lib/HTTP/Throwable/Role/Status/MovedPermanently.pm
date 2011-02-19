package HTTP::Throwable::Role::Status::MovedPermanently;
use Moose::Role;

with(
  'HTTP::Throwable',
  'HTTP::Throwable::Role::BoringBody',
);

sub default_status_code { 301 }
sub default_reason      { 'Moved Permanently' }

has 'location' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
);

around 'build_headers' => sub {
    my $next    = shift;
    my $self    = shift;
    my $headers = $self->$next( @_ );
    push @$headers => ('Location' => $self->location);
    $headers;
};

no Moose::Role; 1;

__END__

# ABSTRACT: 301 Moved Permanently

=head1 DESCRIPTION

The requested resource has been assigned a new permanent URI and
any future references to this resource SHOULD use one of the
returned URIs. Clients with link editing capabilities ought to
automatically re-link references to the Request-URI to one or more
of the new references returned by the server, where possible. This
response is cacheable unless indicated otherwise.

The new permanent URI SHOULD be given by the Location field in the
response. Unless the request method was HEAD, the entity of the
response SHOULD contain a short hypertext note with a hyperlink to
the new URI(s).

=attr location

This is a required string, which will be used in the Location header
when creating a PSGI response.



