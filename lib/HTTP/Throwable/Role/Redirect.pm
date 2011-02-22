package HTTP::Throwable::Role::Redirect;
use Moose::Role;

has 'location' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
);

around 'build_headers' => sub {
    my $next    = shift;
    my $self    = shift;
    my $headers = $self->$next( @_ );
    push @$headers => ('Location' => $self->location);

    return $headers;
};

no Moose::Role; 1;

__END__
# ABSTRACT: an exception that is a redirect

=head1 OVERVIEW

This is an extremely simple method used by most of the 3xx series of
exceptions.  It adds a C<location> attribute that will be provided as the
Location header when the exception is converted to an HTTP message.

Note that "MultipleChoices," the 300 status code is I<not> currently a
redirect, as its Location header is optional.  This may change in the future of
the semantics of this role are refined.
