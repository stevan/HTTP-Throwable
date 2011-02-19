#!/usr/bin/perl
use strict;
use warnings;

use Test::More;
use t::lib::Test::HT;

ht_test(Conflict => {}, {
  code   => 409,
  reason => 'Conflict',
});

done_testing;
