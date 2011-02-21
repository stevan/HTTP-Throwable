package HTTP::Throwable::Role::NoBody;
use Moose::Role;

sub body { return }

sub body_headers {
    my ($self, $body) = @_;

    return [
        'Content-Length' => 0,
    ];
}

sub as_string { $_[0]->status_line }

no Moose::Role;
1;
