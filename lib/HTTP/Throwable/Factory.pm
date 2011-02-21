package HTTP::Throwable::Factory;
use Moose;

sub throw {
    my $factory = shift;
    my $ident   = (! ref $_[0]) ? shift(@_) : undef;
    my $arg     = shift || {};

    $factory->class_for($ident)->throw($arg);
}

sub new_exception {
    my $factory = shift;
    my $ident   = (! ref $_[0]) ? shift(@_) : undef;
    my $arg     = shift || {};

    $factory->class_for($ident)->new($arg);
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
