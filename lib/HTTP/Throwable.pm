package HTTP::Throwable;
use Moose;

with 'Throwable';

has 'status_code' => (
    is       => 'ro',
    isa      => 'Int',
    required => 1,
);

has 'message' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
);

sub content_type { 'text/plain' }

sub as_string {
    my $self = shift;
    $self->status_code . " " . $self->message;
}

sub as_psgi {
    my $self = shift;
    my $body = $self->as_string;
    [
        $self->status_code,
        [
            'Content-Type'   => $self->content_type,
            'Content-Length' => length $body
        ],
        [ $body ]
    ];
}

__PACKAGE__->meta->make_immutable;

no Moose; 1;

__END__

# ABSTRACT: A Moosey solution to this problem

=head1 SYNOPSIS

  use HTTP::Throwable;

=head1 DESCRIPTION

