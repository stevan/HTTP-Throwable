package HTTP::Throwable::BadRequest;
use Moose;
use MooseX::StrictConstructor;

extends 'HTTP::Throwable';

has '+status_code' => ( default => 400 );
has '+reason'      => ( default => 'Bad Request' );

__PACKAGE__->meta->make_immutable;

no Moose; 1;

__END__

# ABSTRACT: 400 Bad Request

=head1 DESCRIPTION

The request could not be understood by the server due to
malformed syntax. The client SHOULD NOT repeat the request
without modifications.
