package HTTP::Throwable::Role::BoringText;
use t::lib::Test::HT;

use Moose::Role;

sub text_body { $_[0]->status_line }

no Moose::Role;
1;
