package HTTP::Throwable::Role::Status::RequestTimeout;
use Moose::Role;

with(
  'HTTP::Throwable',
  'HTTP::Throwable::Role::BoringText',
);

sub default_status_code { 408 }
sub default_reason      { 'Request Timeout' }

no Moose::Role; 1;

__END__

# ABSTRACT: 408 Request Timeout

=head1 DESCRIPTION

The client did not produce a request within the
time that the server was prepared to wait. The
client MAY repeat the request without modifications
at any later time.

