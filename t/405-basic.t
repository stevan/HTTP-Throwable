#!/usr/bin/perl
use strict;
use warnings;

use Test::More;
use Test::Fatal;
use t::lib::Test::HT;

ht_test(MethodNotAllowed => { allow => [ qw(GET PUT) ] }, {
  code    => 405,
  reason  => 'Method Not Allowed',
  headers => [ Allow => 'GET,PUT' ],
});

like(
  exception {
    HTTP::Throwable::Factory->throw(MethodNotAllowed => {
      allow => [ 'GET', 'PUT', 'OPTIONS', 'PUT' ],
    });
  },
  qr/Attribute \(allow\) does not pass the type constraint/,
  '... type check works (must be unique list)',
);

like(
  exception {
    HTTP::Throwable::Factory->throw(MethodNotAllowed => {
      allow => [ 'GET', 'PUT', 'OPTIONS', 'TEST' ],
    });
  },
  qr/Attribute \(allow\) does not pass the type constraint/,
  '... type check works (must be all known methods)',
);

done_testing;
