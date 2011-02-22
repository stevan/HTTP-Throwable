package HTTP::Throwable::Role::NoBody;
use Moose::Role;

sub body { return }

sub body_headers {
    my ($self, $body) = @_;

    return [
        'Content-Length' => 0,
    ];
}

sub as_string { $_[0]->status_line }

no Moose::Role;
1;

__END__
# ABSTRACT: an exception with no body

=head1 OVERVIEW

This is a very simple role, implementing the required C<as_string>, C<body>,
and C<body_headers> for L<HTTP::Throwable>.

When an HTTP::Throwable exception uses this role, its PSGI response will have
no entity body.  It will report a Content-Length of zero.  It will stringify to
its status line.
