package HTTP::Throwable::ProxyAuthenticationRequired;
use Moose;
use MooseX::StrictConstructor;

extends 'HTTP::Throwable';

has '+status_code' => ( default => 407 );
has '+reason'      => ( default => 'Proxy Authentication Required' );

has 'proxy_authenticate' => (
    is       => 'ro',
    isa      => 'Str | ArrayRef[ Str ]',
    required => 1,
);

around 'build_headers' => sub {
    my $next    = shift;
    my $self    = shift;
    my $headers = $self->$next( @_ );
    my $proxy_auth = $self->proxy_authenticate;
    if ( ref $proxy_auth ) {
        push @$headers => (map { ('Proxy-Authenticate' => $_) } @$proxy_auth);
    }
    else {
        push @$headers => ('Proxy-Authenticate' => $proxy_auth );
    }
    $headers;
};

__PACKAGE__->meta->make_immutable;

no Moose; 1;

__END__

# ABSTRACT: 407 Proxy Authentication Required

=head1 DESCRIPTION

This code is similar to 401 (Unauthorized), but indicates that the
client must first authenticate itself with the proxy. The proxy MUST
return a Proxy-Authenticate header field containing a challenge applicable
to the proxy for the requested resource. The client MAY repeat the request
with a suitable Proxy-Authorization header field.

=attr proxy_authenticate

This is a required string or array of strings that will be used to populate
the 'Proxy-Authenticate' header(s) when creating a PSGI response.

=head1 SEE ALSO

HTTP Authentication: Basic and Digest Access Authentication - L<http://www.apps.ietf.org/rfc/rfc2617.html>

Proxy-Authenticate Header - L<http://www.apps.ietf.org/rfc/rfc2617.html#sec-3.6>
