#!/usr/bin/perl
use strict;
use warnings;

use Test::More;
use t::lib::Test::HT;

ht_test(UseProxy => { location => '/proxy/test' }, {
    code    => 305,
    reason  => 'Use Proxy',
    headers => [
        Location => '/proxy/test',
    ],
});

done_testing;
