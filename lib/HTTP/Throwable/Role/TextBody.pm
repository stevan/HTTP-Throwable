package HTTP::Throwable::Role::TextBody;
use Moose::Role;

sub content_type { 'text/plain' }

sub body { $_[0]->text_body }

no Moose::Role;
1;
