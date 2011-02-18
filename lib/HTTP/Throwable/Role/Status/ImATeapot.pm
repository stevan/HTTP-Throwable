package HTTP::Throwable::Role::Status::ImATeapot;
use Moose;
use MooseX::StrictConstructor;

extends 'HTTP::Throwable';

has '+status_code' => ( default => 418 );
has '+reason'      => ( default => "I'm a teapot" );

my $TEAPOT = <<'END';
                       (
            _           ) )
         _,(_)._        ((     I'M A LITTLE TEAPOT__X__
    ___,(_______).        )
  ,'__.   /       \    /\_
 /,' /  |""|       \  /  /
| | |   |__|       |,'  /
 \`.|                  /
  `. :           :    /
    `.            :.,'
      `-.________,-'
END

has '+message'     => (
  lazy      => 1,
  init_arg  => undef,
  default   => sub {
    my $self = shift;
    my $base = $TEAPOT;
    my $msg  = $self->short && $self->stout ? " SHORT AND STOUT"
             : $self->short                 ? " SHORT NOT STOUT"
             : $self->stout                 ? " MERELY STOUT"
             :                                " WITH A SPOUT";

    $base =~ s/__X__/$msg/;

    return $base;
  },
);

has 'short' => (is => 'ro', isa => 'Bool', default => 0);
has 'stout' => (is => 'ro', isa => 'Bool', default => 0);

__PACKAGE__->meta->make_immutable;

no Moose; 1;

__END__

# ABSTRACT: 418 I'm a teapot

=head1 DESCRIPTION

This exception provides RFC2324 support, in accordance with section 2.3.3:

   Any attempt to brew coffee with a teapot should result in the error code
   "418 I'm a teapot".  The resulting entity body MAY be short and stout.

Boolean attributes C<short> and C<stout> are provided, and default to false.

