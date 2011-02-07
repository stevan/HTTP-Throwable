package HTTP::Throwable;
use Moose;

with 'Throwable';

has 'status_code' => (
    is       => 'ro',
    isa      => 'Int',
    required => 1,
);

has 'reason' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
);

has 'message' => ( is => 'ro', isa => 'Str' );

sub content_type { 'text/plain' }

sub build_headers {
    my ($self, $body) = @_;
    [
        'Content-Type'   => $self->content_type,
        'Content-Length' => length $body,
    ]
}

sub as_string {
    my $self = shift;
    my $out  = $self->status_code . " " . $self->reason;
    $out .= " " . $self->message if $self->message;
    $out;
}

sub as_psgi {
    my $self    = shift;
    my $body    = $self->as_string;
    my $headers = $self->build_headers( $body );
    [ $self->status_code, $headers, [ $body ] ];
}

__PACKAGE__->meta->make_immutable;

no Moose; 1;

__END__

# ABSTRACT: A set of HTTP exception objects

=head1 SYNOPSIS

  use HTTP::Throwable;

  # you can use this directly, but ...
  HTTP::Throwable->throw(
      status_code => 500,
      reason      => 'Internal Server Error',
      message     => 'Something has gone very wrong'
  );

  # it is more useful for subclassing
  package InternalServerError;
  use Moose;

  extends 'HTTP::Throwable';
     with 'StackTrace::Auto';

  has '+status_code' => ( default => 500 );
  has '+reason'      => ( default => 'Internal Server Error' );

  around 'as_string' => sub {
      my $next = shift;
      my $self = shift;
      $self->$next() . "\n\n" . $self->stack_trace->as_string;
  };

=head1 DESCRIPTION

This is the base object for all the HTTP::Throwable subclasses.
While you can easily use this object in your code, you likely want
to use the appropriate subclass for the given error as they will
provide the status-code, reason and enforce any required headers.

=head1 ATTRIBUTES

=attr status_code

This is the status code integer as specified in the HTTP spec.

=attr resason

This is the reason phrase as specified in the HTTP spec.

=attr message

This is an additional message string that can be supplied

=head1 METHODS

=method as_string

This returns a string representation of the exception made up
of the status code, the reason and the message.

=method as_psgi

This returns a representation of the exception object as PSGI
response. It will build the content-type and content-length
headers and include the result of C<as_string> in the body.

=head1 SUBCLASSES



=head1 SEE ALSO

L<http://www.w3.org/Protocols/rfc2616/rfc2616-sec10.html>






