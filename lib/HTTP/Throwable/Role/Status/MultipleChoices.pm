package HTTP::Throwable::Role::Status::MultipleChoices;
use Moose;
use MooseX::StrictConstructor;

extends 'HTTP::Throwable';

has '+status_code' => ( default => 300 );
has '+reason'      => ( default => 'Multiple Choices' );

has 'location' => ( is => 'ro', isa => 'Str' );

around 'build_headers' => sub {
    my $next    = shift;
    my $self    = shift;
    my $headers = $self->$next( @_ );
    if ( my $location = $self->location ) {
        push @$headers => ('Location' => $location);
    }
    $headers;
};

__PACKAGE__->meta->make_immutable;

no Moose; 1;

__END__

# ABSTRACT: 300 Multiple Choices

=head1 DESCRIPTION

The requested resource corresponds to any one of a set of representations,
each with its own specific location, and agent-driven negotiation information
is being provided so that the user (or user agent) can select a preferred
representation and redirect its request to that location.

Unless it was a HEAD request, the response SHOULD include an entity containing
a list of resource characteristics and location(s) from which the user or user
agent can choose the one most appropriate. The entity format is specified by
the media type given in the Content-Type header field. Depending upon the
format and the capabilities of the user agent, selection of the most appropriate
choice MAY be performed automatically. However, this specification does not
define any standard for such automatic selection.

If the server has a preferred choice of representation, it SHOULD include
the specific URI for that representation in the Location field; user agents
MAY use the Location field value for automatic redirection. This response is
cacheable unless indicated otherwise.

=attr location

This is an optional string, which, if supplied, will be used in the Location
header when creating a PSGI response.







