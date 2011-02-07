package HTTP::Throwable::Unauthorized;
use Moose;

extends 'HTTP::Throwable';

has '+status_code' => ( default => 401 );
has '+reason'      => ( default => 'Unauthorized' );

has 'www_authenticate' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
);

around 'build_headers' => sub {
    my $next    = shift;
    my $self    = shift;
    my $headers = $self->$next( @_ );
    push @$headers => [ 'WWW-Authenticate' => $self->www_authenticate ];
    $headers;
};

__PACKAGE__->meta->make_immutable;

no Moose; 1;

__END__

# ABSTRACT: 401 Unauthorized

=head1 DESCRIPTION

The request requires user authentication. The response MUST include a
WWW-Authenticate header field containing a challenge applicable to the
requested resource. The client MAY repeat the request with a suitable
Authorization header field. If the request already included Authorization
credentials, then the 401 response indicates that authorization has been
refused for those credentials. If the 401 response contains the same
challenge as the prior response, and the user agent has already attempted
authentication at least once, then the user SHOULD be presented the entity
that was given in the response, since that entity might include relevant
diagnostic information.

=head1 ATTRIBUTES

=attr www_authenticate

This is a required string that will be used to populate the 'WWW-Authenticate'
header when creating a PSGI response.

=head1 SEE ALSO

HTTP Authentication: Basic and Digest Access Authentication - L<http://www.apps.ietf.org/rfc/rfc2617.html>

WWW-Authenticate Header - L<http://www.apps.ietf.org/rfc/rfc2617.html#sec-3.2.1>
