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

  my $role;
  if (defined $ident) {
    $role = 'HTTP::Throwable::Role::Status::' . $ident;
  } else {
    $role = 'HTTP::Throwable::Role::Generic';
  }

  Class::MOP::load_class($role);

  my $class = Moose::Meta::Class->create_anon_class(
    superclasses => [ qw(Moose::Object) ],
    roles        => [ qw(HTTP::Throwable), $role ],
    cache        => 1,
  );

  return $class->name;
}

1;
