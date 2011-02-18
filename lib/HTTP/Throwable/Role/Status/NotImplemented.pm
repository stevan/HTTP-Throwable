package HTTP::Throwable::Role::Status::NotImplemented;
use Moose;
use MooseX::StrictConstructor;

extends 'HTTP::Throwable';

has '+status_code' => ( default => 501 );
has '+reason'      => ( default => 'Not Implemented' );

__PACKAGE__->meta->make_immutable;

no Moose; 1;

__END__

# ABSTRACT: 501 Not Implemented

=head1 DESCRIPTION

The server does not support the functionality required to
fulfill the request. This is the appropriate response when
the server does not recognize the request method and is
not capable of supporting it for any resource.


