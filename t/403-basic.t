#!/usr/bin/perl

use strict;
use warnings;

use Test::More;
use t::lib::Test::HT;

ht_test(Forbidden => {}, {
  code   => 403,
  reason => 'Forbidden',
});

done_testing;
