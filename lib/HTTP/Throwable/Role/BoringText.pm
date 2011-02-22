package HTTP::Throwable::Role::BoringText;
use t::lib::Test::HT;

use Moose::Role;

sub text_body { $_[0]->status_line }

no Moose::Role;
1;

__END__
# ABSTRACT: provide the simplest text_body method possible

=head1 OVERVIEW

This role is as simple as can be.  It provides a single method, C<text_body>,
which returns the result of calling the C<status_line> method.

This method exists so that exception classes can easily be compatible with the
L<HTTP::Throwable::Role::TextBody> role to provide a plain text body when
converted to an HTTP message.  Most of the core well-known exception types
consume this method.

