#!/usr/bin/perl
use strict;
use warnings;

use Test::More;
use Test::Fatal;
use Test::Moose;
use t::lib::Test::HT;

ht_test(
    { status_code => 500, reason => 'Internal Server Error' },
    {
        code   => 500,
        reason => 'Internal Server Error',
        assert => sub {
          my $e = shift;

          is(
              "$e",
              '500 Internal Server Error',
              '... got the right string overload',
          );

          is_deeply(
              $e->(),
              [
                  500,
                  [
                      'Content-Type'   => 'text/plain',
                      'Content-Length' => 25,
                  ],
                  [ '500 Internal Server Error' ]
              ],
              '... got the right &{} overload transformation'
          );
        },
    },
);

done_testing;
