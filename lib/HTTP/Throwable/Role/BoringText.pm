package HTTP::Throwable::Role::BoringText;
use Moose::Role;

sub text_body { $_[0]->status_line }

no Moose::Role;
1;
