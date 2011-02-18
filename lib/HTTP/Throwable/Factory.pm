package HTTP::Throwable::Factory;
use Moose;

sub throw {
  my ($factory, $ident, $arg) = @_;

  $self->class_for($ident)->throw($arg);
}

sub class_for {
  my ($self, $ident) = @_;

  my $class = 'HTTP::Throwable::Role::Status::' . $ident;
  Class::MOP::load_class($class);

  return $class;
}

1;
