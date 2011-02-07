package HTTP::Throwable::HTTPVersionNotSupported;
use Moose;
use MooseX::StrictConstructor;

extends 'HTTP::Throwable';

has '+status_code' => ( default => 505 );
has '+reason'      => ( default => 'HTTP Version Not Supported' );

__PACKAGE__->meta->make_immutable;

no Moose; 1;

__END__

# ABSTRACT: 505 HTTP Version Not Supported

=head1 DESCRIPTION

The server does not support, or refuses to support, the
HTTP protocol version that was used in the request message.
The server is indicating that it is unable or unwilling to
complete the request using the same major version as the
client, other than with this error message. The response
SHOULD contain an entity describing why that version is not
supported and what other protocols are supported by that
server.
