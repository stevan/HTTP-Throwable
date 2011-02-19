#!/usr/bin/perl
use strict;
use warnings;

use Test::More;
use t::lib::Test::HT;

ht_test(NotImplemented => {}, {
  code   => 501,
  reason => 'Not Implemented',
});

done_testing;
