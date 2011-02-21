package HTTP::Throwable::Role::TextBody;
use Moose::Role;

sub content_type { 'text/plain' }

sub body { $_[0]->text_body }

sub body_headers {
    my ($self, $body) = @_;

    return [
        'Content-Type'   => $self->content_type,
        'Content-Length' => length $body,
    ];
}

no Moose::Role;
1;
