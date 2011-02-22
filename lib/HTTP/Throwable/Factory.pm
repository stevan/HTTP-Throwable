package HTTP::Throwable::Factory;
use Moose;

use Sub::Exporter::Util ();
use Sub::Exporter -setup => {
  exports => [
    http_throw     => Sub::Exporter::Util::curry_method('throw'),
    http_exception => Sub::Exporter::Util::curry_method('new_exception'),
  ],
};

sub throw {
    my $factory = shift;
    my $ident   = (! ref $_[0]) ? shift(@_) : undef;
    my $arg     = shift || {};

    $factory->class_for($ident, $arg)->throw($arg);
}

sub new_exception {
    my $factory = shift;
    my $ident   = (! ref $_[0]) ? shift(@_) : undef;
    my $arg     = shift || {};

    $factory->class_for($ident, $arg)->new($arg);
}

sub core_roles {
    return qw(
        HTTP::Throwable
        MooseX::StrictConstructor::Role::Object
    );
}

sub extra_roles {
    return qw(
        HTTP::Throwable::Role::TextBody
    );
}

sub roles_for_ident {
    my ($self, $ident) = @_;

    return "HTTP::Throwable::Role::Status::$ident";
}

sub roles_for_no_ident {
    my ($self, $ident) = @_;

    return qw(
        HTTP::Throwable::Role::Generic
        HTTP::Throwable::Role::BoringText
    );
}

sub base_class { 'Moose::Object' }

sub class_for {
    my ($self, $ident) = @_;

    my @roles;
    if (defined $ident) {
        @roles = $self->roles_for_ident($ident);
    } else {
        @roles = $self->roles_for_no_ident;
    }

    Class::MOP::load_class($_) for @roles;

    my $class = Moose::Meta::Class->create_anon_class(
        superclasses => [ $self->base_class ],
        roles        => [
          $self->core_roles,
          $self->extra_roles,
          @roles
        ],
        cache        => 1,
    );

    return $class->name;
}

1;

__END__

# ABSTRACT: a factory that throws HTTP::Throwables for you

=head1 OVERVIEW

L<HTTP::Throwable> is a role that makes it easy to build exceptions that, once
thrown, can be turned into L<PSGI>-style HTTP responses.  Because
HTTP::Throwable and all its related roles are, well, roles, they can't be
instantiated or thrown directly.  Instead, they must be built into classes
first.  HTTP::Throwable::Factory takes care of this job, building classes out
of the roles you need for the exception you want to throw.

You can use the factory to either I<build> or I<throw> an exception of either a
I<generic> or I<specific> type.  Building and throwing are very similar -- the
only difference is whether or not the newly built object is thrown or returned.
To throw an exception, use the C<throw> method on the factory.  To return it,
use the C<new_exception> method.  In the examples below, we'll just use
C<throw>.

To throw a generic exception -- one where you must specify the status code and
reason, and any other headers -- you pass C<throw> a hashref of arguments that
will be passed to the exception class's constructor.

  HTTP::Throwable::Factory->throw({
      status_code => 301,
      reason      => 'Moved Permanently',
      additional_headers => [
        Location => '/new',
      ],
  });

To throw a specific type of exception, include an exception type identifier,
like this:

  HTTP::Throwable::Factory->throw(MovedPermanently => { location => '/new' });

The type identifier is (by default) the end of a role name in the form
C<HTTP::Throwable::Role::Status::IDENTIFIER>.  The full list of such included
roles is given in L<the HTTP::Throwable docs|HTTP::Throwable/WELL-KNOWN TYPES>.

=head2 Exports

You can import routines called C<http_throw> and C<http_exception> that work
like the C<throw> and C<new_exception> methods, respectively, but are not
called as methods.  For example:

  use HTTP::Throwable::Factory 'http_exception';

  builder {
      mount '/old' => http_exception('Gone'),
  };

=head1 SUBCLASSING

One of the big benefits of using HTTP::Throwable::Factory is that you can
subclass it to change the kind of exceptions it provides.

If you subclass it, you can change its behavior by overriding the following
methods -- provided in the order of likelihood that you'd want to override
them, most likely first.

=head2 extra_roles

This method returns a list of role names that will be included in any class
built by the factory.  By default, it includes only
L<HTTP::Throwable::Role::TextBody> to satisfy HTTP::Throwable's requirements
for methods needed to build a body.

This is the method you're most likely to override in a subclass.

=head2 roles_for_ident

=head2 roles_for_no_ident

This methods convert the exception type identifier to a role to apply.  For
example, if you call:

  Factory->throw(NotFound => { ... })

...then C<roles_for_ident> is called with "NotFound" as its argument.

If C<throw> is called I<without> a type identifier, C<roles_for_no_ident> is
called.

By default, C<roles_for_ident> returns C<HTTP::Throwable::Role::Status::$ident>
and C<roles_for_no_ident> returns L<HTTP::Throwable::Role::Generic> and
L<HTTP::Throwable::Role::BoringText>.

=head2 base_class

This is the base class that will be subclassed and into which all the roles
will be composed.  By default, it is L<Moose::Object>, the universal base Moose
class.

=head2 core_roles

This method returns the roles that are expected to be applied to every
HTTP::Throwable exception.  This method's results might change over time, and
you are encouraged I<B<not>> to alter it.
