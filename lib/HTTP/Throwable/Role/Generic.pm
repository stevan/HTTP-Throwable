package HTTP::Throwable::Role::Generic;
use Moose::Role;

with 'HTTP::Throwable';

sub default_status_code {
    confess "generic HTTP::Throwable must be given status code in constructor";
}

sub default_reason {
    confess "generic HTTP::Throwable must be given reason in constructor";
}

no Moose::Role; 1;

__END__

# ABSTRACT: a generic built-by-hand exception

=head1 DESCRIPTION

This role is used (for boring internals-related reasons) when you throw an
exception with no special roles mixed in.

