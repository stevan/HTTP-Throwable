package HTTP::Throwable::SeeOther;
use Moose;
use MooseX::StrictConstructor;

extends 'HTTP::Throwable';

has '+status_code' => ( default => 303 );
has '+reason'      => ( default => 'See Other' );

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

__PACKAGE__->meta->make_immutable;

no Moose; 1;

__END__

# ABSTRACT: 303 See Other

=head1 DESCRIPTION

The response to the request can be found under a different URI
and SHOULD be retrieved using a GET method on that resource.
This method exists primarily to allow the output of a
POST-activated script to redirect the user agent to a selected
resource. The new URI is not a substitute reference for the
originally requested resource. The 303 response MUST NOT be
cached, but the response to the second (redirected) request
might be cacheable.

The different URI SHOULD be given by the Location field in
the response. Unless the request method was HEAD, the entity
of the response SHOULD contain a short hypertext note with a
hyperlink to the new URI(s).

=attr location

This is a required string, which will be used in the Location header
when creating a PSGI response.



