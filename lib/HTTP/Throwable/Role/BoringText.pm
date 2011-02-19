package HTTP::Throwable::Role::BoringText;
use Moose::Role;

sub default_text { $_[0]->status_line }

no Moose::Role;
1;
