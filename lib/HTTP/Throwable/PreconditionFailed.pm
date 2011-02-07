package HTTP::Throwable::PreconditionFailed;
use Moose;

extends 'HTTP::Throwable';

has '+status_code' => ( default => 412 );
has '+reason'      => ( default => 'Precondition Failed' );

__PACKAGE__->meta->make_immutable;

no Moose; 1;

__END__

# ABSTRACT: 412 Precondition Failed

=head1 DESCRIPTION

The precondition given in one or more of the request-header
fields evaluated to false when it was tested on the server.
This response code allows the client to place preconditions
on the current resource metainformation (header field data)
and thus prevent the requested method from being applied to
a resource other than the one intended.

