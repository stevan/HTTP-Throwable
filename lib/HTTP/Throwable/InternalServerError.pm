package HTTP::Throwable::InternalServerError;
use Moose;

extends 'HTTP::Throwable';
   with 'StackTrace::Auto';

has '+status_code' => ( default => 500 );
has '+reason'      => ( default => 'Internal Server Error' );

has 'show_stack_trace' => ( is => 'ro', isa => 'Bool', default => 1 );

around 'as_string' => sub {
    my $next = shift;
    my $self = shift;
    my $out  = $self->$next();
    $out .= "\n\n" . $self->stack_trace->as_string
        if $self->show_stack_trace;
    $out;
};

__PACKAGE__->meta->make_immutable;

no Moose; 1;

__END__

# ABSTRACT: 500 Internal Server Error

=head1 DESCRIPTION

The server encountered an unexpected condition which prevented it
from fulfilling the request.

=head1 ATTRIBUTES

=attr show_stack_trace

This is a boolean attribute which by default is true and indicates
to the C<as_string> method whether or not to show the stack trace
in the output.

