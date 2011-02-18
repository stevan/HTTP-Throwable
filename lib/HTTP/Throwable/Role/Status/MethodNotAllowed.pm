package HTTP::Throwable::Role::Status::MethodNotAllowed;
use Moose;
use MooseX::StrictConstructor;
use Moose::Util::TypeConstraints;

use List::AllUtils qw[ uniq ];

extends 'HTTP::Throwable';

enum 'HTTP::Throwable::Type::Methods' => qw[
    OPTIONS GET HEAD
    POST PUT DELETE
    TRACE CONNECT
];

subtype 'HTTP::Throwable::Type::MethodList'
    => as 'ArrayRef'
    => where { (scalar uniq @{$_}) == (scalar @{$_}) };

has '+status_code' => ( default => 405 );
has '+reason'      => ( default => 'Method Not Allowed' );

has 'allow' => (
    is       => 'ro',
    isa      => 'HTTP::Throwable::Type::MethodList[ HTTP::Throwable::Type::Methods ]',
    required => 1
);

around 'build_headers' => sub {
    my $next    = shift;
    my $self    = shift;
    my $headers = $self->$next( @_ );
    push @$headers => ('Allow' => join "," => @{ $self->allow });
    $headers;
};

__PACKAGE__->meta->make_immutable;

no Moose; no Moose::Util::TypeConstraints; 1;

__END__

# ABSTRACT: 405 Method Not Allowed

=head1 DESCRIPTION

The method specified in the Request-Line is not allowed for the
resource identified by the Request-URI. The response MUST include
an Allow header containing a list of valid methods for the requested
resource.

=attr allow

This is an ArrayRef of HTTP methods, it is required and the HTTP
methods will be type checked to ensure validity and uniqueness.

=head1 SEE ALSO

HTTP Methods - L<http://www.w3.org/Protocols/rfc2616/rfc2616-sec9.html>


