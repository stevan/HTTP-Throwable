#!/usr/bin/perl
use strict;
use warnings;

use Test::More;
use t::lib::Test::HT;

ht_test(MovedPermanently => { location => '/test' }, {
  code    => 301,
  reason  => 'Moved Permanently',
  headers => [
    Location => '/test',
  ],
});

done_testing;
