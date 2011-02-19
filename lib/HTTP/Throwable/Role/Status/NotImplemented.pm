package HTTP::Throwable::Role::Status::NotImplemented;
use Moose::Role;

with 'HTTP::Throwable';

sub default_status_code { 501 }
sub default_reason      { 'Not Implemented' }

no Moose::Role; 1;

__END__

# ABSTRACT: 501 Not Implemented

=head1 DESCRIPTION

The server does not support the functionality required to
fulfill the request. This is the appropriate response when
the server does not recognize the request method and is
not capable of supporting it for any resource.


