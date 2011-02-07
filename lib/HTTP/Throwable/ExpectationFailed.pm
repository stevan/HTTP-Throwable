package HTTP::Throwable::ExpectationFailed;
use Moose;

extends 'HTTP::Throwable';

has '+status_code' => ( default => 417 );
has '+reason'     => ( default => 'Expectation Failed' );

__PACKAGE__->meta->make_immutable;

no Moose; 1;

__END__

# ABSTRACT: 417 Expectation Failed

=head1 DESCRIPTION

The expectation given in an Expect request-header field
could not be met by this server, or, if the server is a
proxy, the server has unambiguous evidence that the
request could not be met by the next-hop server.

