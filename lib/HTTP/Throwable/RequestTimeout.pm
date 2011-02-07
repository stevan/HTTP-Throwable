package HTTP::Throwable::RequestTimeout;
use Moose;
use MooseX::StrictConstructor;

extends 'HTTP::Throwable';

has '+status_code' => ( default => 408 );
has '+reason'      => ( default => 'Request Timeout' );

__PACKAGE__->meta->make_immutable;

no Moose; 1;

__END__

# ABSTRACT: 408 Request Timeout

=head1 DESCRIPTION

The client did not produce a request within the
time that the server was prepared to wait. The
client MAY repeat the request without modifications
at any later time.

