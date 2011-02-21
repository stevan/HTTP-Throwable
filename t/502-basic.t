#!/usr/bin/perl

use strict;
use warnings;

use Test::More;
use t::lib::Test::HT;

ht_test(BadGateway => {}, {
    code   => 502,
    reason => 'Bad Gateway',
});

done_testing;
