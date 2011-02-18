package HTTP::Throwable::Role::Status::LengthRequired;
use Moose;
use MooseX::StrictConstructor;

extends 'HTTP::Throwable';

has '+status_code' => ( default => 411 );
has '+reason'      => ( default => 'Length Required' );

__PACKAGE__->meta->make_immutable;

no Moose; 1;

__END__

# ABSTRACT: 411 Length Required

=head1 DESCRIPTION

The server refuses to accept the request without a defined
Content-Length. The client MAY repeat the request if it
adds a valid Content-Length header field containing the
length of the message-body in the request message.
