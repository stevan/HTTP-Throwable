#!/usr/bin/perl

use strict;
use warnings;

use Test::More;
use t::lib::Test::HT;

ht_test(
  Found => {
    location => '/test',
    additional_headers => [
      Expires => 'Soonish',
    ],
  },
  {
    code    => 302,
    reason  => 'Found',
    headers => [
      Location => '/test',
      Expires  => 'Soonish',
    ],
  },
);

done_testing;
