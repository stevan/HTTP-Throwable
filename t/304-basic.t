#!/usr/bin/perl
use strict;
use warnings;

use Test::More;
use Test::Deep;
use t::lib::Test::HT;

ht_test(
  NotModified => {
    location => '/test',
    additional_headers => [
      'Expires' => 'Soonish',
    ],
  },
  {
    code      => 304,
    reason    => 'Not Modified',
    as_string => '304 Not Modified',
    body      => undef,
    length    => 0,
    headers   => [
      Location => '/test',
      Expires  => 'Soonish',
    ],
  },
);

done_testing;
