package HTTP::Throwable::Role::Status::GatewayTimeout;
use Moose;
use MooseX::StrictConstructor;

extends 'HTTP::Throwable';

has '+status_code' => ( default => 504 );
has '+reason'      => ( default => 'Gateway Timeout' );

__PACKAGE__->meta->make_immutable;

no Moose; 1;

__END__

# ABSTRACT: 504 Gateway Timeout

=head1 DESCRIPTION

The server, while acting as a gateway or proxy, did not
receive a timely response from the upstream server specified
by the URI (e.g. HTTP, FTP, LDAP) or some other auxiliary
server (e.g. DNS) it needed to access in attempting to
complete the request.

