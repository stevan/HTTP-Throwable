#!/usr/bin/perl
use strict;
use warnings;

use Test::More;
use t::lib::Test::HT;

ht_test(GatewayTimeout => {}, {
    code   => 504,
    reason => 'Gateway Timeout',
});

done_testing;
