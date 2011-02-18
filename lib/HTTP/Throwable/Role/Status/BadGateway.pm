package HTTP::Throwable::Role::Status::BadGateway;
use Moose;
use MooseX::StrictConstructor;

extends 'HTTP::Throwable';

has '+status_code' => ( default => 502 );
has '+reason'      => ( default => 'Bad Gateway' );

__PACKAGE__->meta->make_immutable;

no Moose; 1;

__END__

# ABSTRACT: 502 Bad Gateway

=head1 DESCRIPTION

The server, while acting as a gateway or proxy, received
an invalid response from the upstream server it accessed
in attempting to fulfill the request.


