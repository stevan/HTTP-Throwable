package HTTP::Throwable::Role::Status::ExpectationFailed;
use Moose::Role;

with(
    'HTTP::Throwable',
    'HTTP::Throwable::Role::BoringText',
);

sub default_status_code { 417 }
sub default_reason      { 'Expectation Failed' }

no Moose::Role; 1;

__END__

# ABSTRACT: 417 Expectation Failed

=head1 DESCRIPTION

The expectation given in an Expect request-header field
could not be met by this server, or, if the server is a
proxy, the server has unambiguous evidence that the
request could not be met by the next-hop server.

