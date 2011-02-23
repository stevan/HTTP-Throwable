package HTTP::Throwable::Role::TextBody;
use Moose::Role;

sub body { $_[0]->text_body }

sub body_headers {
    my ($self, $body) = @_;

    return [
        'Content-Type'   => 'text/plain',
        'Content-Length' => length $body,
    ];
}

sub as_string { $_[0]->body }

requires 'text_body';

no Moose::Role;
1;

__END__
# ABSTRACT: an exception with a plaintext body

=head1 OVERVIEW

This is a very simple role, implementing the required C<as_string>, C<body>,
and C<body_headers> for L<HTTP::Throwable>.  In turn, it requires that a
C<text_body> method be provided.

When an HTTP::Throwable exception uses this role, its PSGI response will have a
C<text/plain> content type and will send the result of calling its C<text_body>
method as the response body.  It will also stringify to the text body.

The role L<HTTP::Throwable::Role::BoringText> can be useful to provide a
C<text_body> method that issues the C<status_line> as the body.
