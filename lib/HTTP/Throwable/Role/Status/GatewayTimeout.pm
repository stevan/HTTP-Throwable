package HTTP::Throwable::Role::Status::GatewayTimeout;
use Moose::Role;

with(
  'HTTP::Throwable',
  'HTTP::Throwable::Role::BoringText',
);

sub default_status_code { 504 }
sub default_reason      { 'Gateway Timeout' }

no Moose::Role; 1;

__END__

# ABSTRACT: 504 Gateway Timeout

=head1 DESCRIPTION

The server, while acting as a gateway or proxy, did not
receive a timely response from the upstream server specified
by the URI (e.g. HTTP, FTP, LDAP) or some other auxiliary
server (e.g. DNS) it needed to access in attempting to
complete the request.

