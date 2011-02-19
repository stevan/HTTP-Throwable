#!/usr/bin/perl
use strict;
use warnings;

use Test::More;
use t::lib::Test::HT;

ht_test(RequestURITooLong => {}, {
  code   => 414,
  reason => 'Request-URI Too Long',
});

done_testing;
