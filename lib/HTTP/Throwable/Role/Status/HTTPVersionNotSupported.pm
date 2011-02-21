package HTTP::Throwable::Role::Status::HTTPVersionNotSupported;
use Moose::Role;

with(
    'HTTP::Throwable',
    'HTTP::Throwable::Role::BoringText',
);

sub default_status_code { 505 }
sub default_reason      { 'HTTP Version Not Supported' }

no Moose::Role; 1;

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
