package HTTP::Throwable::Role::TextBody;
use Moose::Role;

sub body { $_[0]->text_body }

sub body_headers {
    my ($self, $body) = @_;

    return [
        'Content-Type'   => 'text/plain',
        'Content-Length' => length $body,
    ];
}

sub as_string { $_[0]->body }

no Moose::Role;
1;
