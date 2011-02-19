#!/usr/bin/perl
use strict;
use warnings;

use Test::More;
use t::lib::Test::HT;

ht_test(LengthRequired => {}, {
  code   => 411,
  reason => 'Length Required',
});

done_testing;
