package HTTP::Throwable::Role::Status::InternalServerError;
use Moose::Role;

with(
  'HTTP::Throwable',
  'StackTrace::Auto',
);

sub default_status_code { 500 }
sub default_reason      { 'Internal Server Error' }

has 'show_stack_trace' => ( is => 'ro', isa => 'Bool', default => 1 );

sub default_text {
    my ($self) = @_;

    my $out = $self->status_line;
    $out .= "\n\n" . $self->stack_trace->as_string
        if $self->show_stack_trace;

    return $out;
}

no Moose; 1;

__END__

# ABSTRACT: 500 Internal Server Error

=head1 DESCRIPTION

The server encountered an unexpected condition which prevented it
from fulfilling the request.

=attr show_stack_trace

This is a boolean attribute which by default is true and indicates
to the C<as_string> method whether or not to show the stack trace
in the output.

