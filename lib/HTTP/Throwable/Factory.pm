package HTTP::Throwable::Factory;
use Moose;

sub throw {
  my $factory = shift;
  my $ident   = (! ref $_[0]) ? shift(@_) : undef;
  my $arg     = shift || {};

  $factory->class_for($ident)->throw($arg);
}

sub class_for {
  my ($self, $ident) = @_;

  my @roles;
  if (defined $ident) {
    @roles = 'HTTP::Throwable::Role::Status::' . $ident;
  } else {
    @roles = qw(
      HTTP::Throwable::Role::Generic
      HTTP::Throwable::Role::BoringBody
    );
  }

  Class::MOP::load_class($_) for @roles;

  my $class = Moose::Meta::Class->create_anon_class(
    superclasses => [ qw(Moose::Object) ],
    roles        => [ qw(HTTP::Throwable), @roles ],
    cache        => 1,
  );

  return $class->name;
}

1;
