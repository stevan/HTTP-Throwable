package HTTP::Throwable;
use Moose::Role;
use MooseX::StrictConstructor;
use MooseX::Role::WithOverloading;

use overload
    '&{}' => 'to_app',
    '""'  => 'as_string',
    fallback => 1;

use Plack::Util ();

with 'Throwable';

has 'status_code' => (
    is       => 'ro',
    isa      => 'Int',
    builder  => 'default_status_code',
);

has 'reason' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
    builder  => 'default_reason',
);

has 'message' => (
    is  => 'ro',
    isa => 'Str',
    predicate => 'has_message',
);

has 'additional_headers' => ( is => 'ro', isa => 'ArrayRef' );

sub build_headers {
    my ($self, $body) = @_;

    my @headers;

    @headers = @{ $self->body_headers($body) };

    if ( my $additional_headers = $self->additional_headers ) {
        push @headers => @$additional_headers;
    }

    return \@headers;
}

sub status_line {
    my $self = shift;
    my $out  = $self->status_code . " " . $self->reason;
    $out .= " " . $self->message if $self->message;

    return $out;
}

requires 'body';
requires 'body_headers';
requires 'as_string';

sub as_psgi {
    my $self    = shift;
    my $body    = $self->body;
    my $headers = $self->build_headers( $body );
    [ $self->status_code, $headers, [ defined $body ? $body : () ] ];
}

sub to_app {
    my $self = shift;
    sub { my $env; $self->as_psgi( $env ) }
}

sub is_redirect {
    my $status = (shift)->status_code;
    return $status >= 300 && $status < 400;
}

sub is_client_error {
    my $status = (shift)->status_code;
    return $status >= 400 && $status < 500;
}

sub is_server_error {
    my $status = (shift)->status_code;
    return $status >= 500 && $status < 600;
}

no Moose::Role; 1;

__END__

# ABSTRACT: A set of strongly-typed, PSGI-friendly HTTP 1.1 exception classes

=head1 SYNOPSIS

I<Actually>, you probably want to use L<HTTP::Throwable::Factory>, so here's a
sample of how that works:

  use HTTP::Throwable::Factory qw(http_throw http_exception);

  # you can just throw a generic exception...
  HTTP::Throwable::Factory->throw({
      status_code => 500,
      reason      => 'Internal Server Error',
      message     => 'Something has gone very wrong!'
  });

  # or with a little sugar...
  http_throw({
      status_code => 500,
      reason      => 'Internal Server Error',
      message     => 'Something has gone very wrong!'
  });


  # ...but it's much more convenient to throw well-defined exceptions, like
  # this:

  http_throw(InternalServerError => {
    message => 'Something has gone very wrong!',
  });

  # or you can use the exception objects as PSGI apps:
  builder {
      mount '/old' => http_exception(MovedPermanently => { location => '/new' }),
      # ...
  };

=head1 DESCRIPTION

HTTP-Throwable provides a set of strongly-typed, PSGI-friendly exception
implementations corresponding to the HTTP error status code (4xx-5xx) as well
as the redirection codes (3xx).

This particular package (HTTP::Throwable) is the shared role for all the
exceptions involved.  It's not intended that you use HTTP::Throwable
directly, although you can, and instructions for using it correctly are
given below.  Instead, you probably want to use
L<HTTP::Throwable::Factory>, which will assemble exception classes from
roles needed to build an exception for your use case.

For example, you can throw a redirect:

  use HTTP::Throwable::Factory qw(http_throw);

  http_throw(MovedPermanently => { location => '/foo-bar' });

...or a generic fully user-specified exception...

  http_throw({
    status_code => 512,
    reason      => 'Server on fire',
    message     => "Please try again after heavy rain",
  });

For a list of pre-defined, known errors, see L</WELL-KNOWN TYPES> below.
These types will have the correct status code and reason, and will
understand extra status-related arguments like redirect location or authentication realms.

For information on using HTTP::Throwable directly, see L</COMPOSING WITH
HTTP::THROWABLE>, below.

=head2 HTTP::Exception

This module is similar to HTTP::Exception with a few, well uhm,
exceptions. First, we are not implementing the 1xx and 2xx status
codes, it is this authors opinion that those not being errors or
an exception control flow (redirection) should not be handled with
exceptions. And secondly, this module is very PSGI friendly in that
it can turn your exception into a PSGI response with just a
method call.

All that said HTTP::Exception is a wonderful module and if that
better suits your needs, then by all means, use it.

=head2 Note about Stack Traces

It should be noted that even though these are all exception objects,
only the 500 Internal Server Error error actually includes the stack
trace (albiet optionally). This is because more often then not you will
not actually care about the stack trace and therefore do not the extra
overhead. If you do find you want a stack trace though, it is as simple
as adding the L<StackTrace::Auto> role to your exceptions.

=attr status_code

This is the status code integer as specified in the HTTP spec.

=attr resason

This is the reason phrase as specified in the HTTP spec.

=attr message

This is an additional message string that can be supplied, which I<may>
be used when stringifying or building an HTTP response.

=method status_line

This returns a string that would be used as a status line in a response,
like C<404 Not Found>.

=method as_string

This returns a string representation of the exception.  This method
B<must> be implemented by any class consuming this role.

=method as_psgi

This returns a representation of the exception object as PSGI
response.

In theory, it accepts a PSGI environment as its only argument, but
currently the environment is ignored.

=method to_app

This is the standard Plack convention for L<Plack::Component>s.
It will return a CODE ref which expects the C<$env> parameter
and returns the results of C<as_psgi>.

=method &{}

We overload C<&{}> to call C<to_app>, again in keeping with the
L<Plack::Component> convention.

=head1 WELL-KNOWN TYPES

Below is a list of the well-known types recognized by the factory and
shipped with this distribution. The obvious 4xx and 5xx errors are
included but we also include the 3xx redirection status codes. This is
because, while not really an error, the 3xx status codes do represent an
exceptional control flow.

The implementation for each of these is in a role with a name in the
form C<HTTP::Throwable::Role::Status::STATUS-NAME>.  For example, "Gone"
is C<HTTP::Throwable::Role::Status::Gone>.  When throwing the exception
with the factory, just pass "Gone"

=head2 Redirection 3xx

This class of status code indicates that further action needs to
be taken by the user agent in order to fulfill the request. The
action required MAY be carried out by the user agent without
interaction with the user if and only if the method used in the
second request is GET or HEAD.

=over 4

=item 300 L<HTTP::Throwable::Role::Status::MultipleChoices>

=item 301 L<HTTP::Throwable::Role::Status::MovedPermanently>

=item 302 L<HTTP::Throwable::Role::Status::Found>

=item 303 L<HTTP::Throwable::Role::Status::SeeOther>

=item 304 L<HTTP::Throwable::Role::Status::NotModified>

=item 305 L<HTTP::Throwable::Role::Status::UseProxy>

=item 307 L<HTTP::Throwable::Role::Status::TemporaryRedirect>

=back

=head2 Client Error 4xx

The 4xx class of status code is intended for cases in which
the client seems to have erred. Except when responding to a
HEAD request, the server SHOULD include an entity containing an
explanation of the error situation, and whether it is a temporary
or permanent condition. These status codes are applicable to any
request method. User agents SHOULD display any included entity
to the user.

=over 4

=item 400 L<HTTP::Throwable::Role::Status::BadRequest>

=item 401 L<HTTP::Throwable::Role::Status::Unauthorized>

=item 403 L<HTTP::Throwable::Role::Status::Forbidden>

=item 404 L<HTTP::Throwable::Role::Status::NotFound>

=item 405 L<HTTP::Throwable::Role::Status::MethodNotAllowed>

=item 406 L<HTTP::Throwable::Role::Status::NotAcceptable>

=item 407 L<HTTP::Throwable::Role::Status::ProxyAuthenticationRequired>

=item 408 L<HTTP::Throwable::Role::Status::RequestTimeout>

=item 409 L<HTTP::Throwable::Role::Status::Conflict>

=item 410 L<HTTP::Throwable::Role::Status::Gone>

=item 411 L<HTTP::Throwable::Role::Status::LengthRequired>

=item 412 L<HTTP::Throwable::Role::Status::PreconditionFailed>

=item 413 L<HTTP::Throwable::Role::Status::RequestEntityTooLarge>

=item 414 L<HTTP::Throwable::Role::Status::RequestURITooLong>

=item 415 L<HTTP::Throwable::Role::Status::UnsupportedMediaType>

=item 416 L<HTTP::Throwable::Role::Status::RequestedRangeNotSatisfiable>

=item 417 L<HTTP::Throwable::Role::Status::ExpectationFailed>

=back

=head2 Server Error 5xx

Response status codes beginning with the digit "5" indicate
cases in which the server is aware that it has erred or is
incapable of performing the request. Except when responding to
a HEAD request, the server SHOULD include an entity containing
an explanation of the error situation, and whether it is a
temporary or permanent condition. User agents SHOULD display
any included entity to the user. These response codes are applicable
to any request method.

=over 4

=item 500 L<HTTP::Throwable::Role::Status::InternalServerError>

=item 501 L<HTTP::Throwable::Role::Status::NotImplemented>

=item 502 L<HTTP::Throwable::Role::Status::BadGateway>

=item 503 L<HTTP::Throwable::Role::Status::ServiceUnavailable>

=item 504 L<HTTP::Throwable::Role::Status::GatewayTimeout>

=item 505 L<HTTP::Throwable::Role::Status::HTTPVersionNotSupported>

=back

=head1 COMPOSING WITH HTTP::THROWABLE

In general, we expect that you'll use L<HTTP::Throwable::Factory> or a
subclass to throw exceptions.  You can still use HTTP::Throwable
directly, though, if you keep these things in mind:

HTTP::Throwable is mostly concerned about providing basic headers and a
PSGI representation.  It doesn't worry about the body or a
stringification.  You B<must> provide the methods C<body> and
C<body_headers> and C<as_string>.

The C<body> method returns the string (of octets) to be sent as the HTTP
entity.  That body is passed to the C<body_headers> method, which must
return an arrayref of headers to add to the response.  These will
generally include the Content-Type and Content-Length headers.

The C<as_string> method should return a printable string, even if the
body is going to be empty.

For convenience, these three methods are implemented by the roles
L<HTTP::Throwable::Role::TextBody> and L<HTTP::Throwable::Role::NoBody>.

=head1 SEE ALSO

L<http://www.w3.org/Protocols/rfc2616/rfc2616-sec10.html>
