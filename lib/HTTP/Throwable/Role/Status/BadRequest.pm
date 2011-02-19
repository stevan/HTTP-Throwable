package HTTP::Throwable::Role::Status::BadRequest;
use Moose::Role;

with(
    'HTTP::Throwable',
    'HTTP::Throwable::Role::BoringText',
);

sub default_status_code { 400 }

sub default_reason { 'Bad Request' }

no Moose::Role; 1;

__END__

# ABSTRACT: 400 Bad Request

=head1 DESCRIPTION

The request could not be understood by the server due to
malformed syntax. The client SHOULD NOT repeat the request
without modifications.
