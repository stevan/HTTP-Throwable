#!/usr/bin/perl
use strict;
use warnings;

use Test::Deep qw(ignore re);
use Test::More;
use Test::Fatal;
use Test::Moose;

use t::lib::Test::HT;

ht_test(InternalServerError => {}, {
  code   => 500,
  reason => 'Internal Server Error',
  length => ignore(),
  body   => re(qr{500 Internal Server Error.+at t/lib/Test/HT.pm}s),
});

done_testing;
