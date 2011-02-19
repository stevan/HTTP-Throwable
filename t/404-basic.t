#!/usr/bin/perl

use strict;
use warnings;

use Test::More;
use t::lib::Test::HT;

ht_test(NotFound=> {}, {
  code   => 404,
  reason => 'Not Found',
});

done_testing;
