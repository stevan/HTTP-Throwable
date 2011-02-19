#!/usr/bin/perl
use strict;
use warnings;

use Test::More;
use t::lib::Test::HT;

ht_test(Gone => {}, {
  code   => 410,
  reason => 'Gone',
});

done_testing;
