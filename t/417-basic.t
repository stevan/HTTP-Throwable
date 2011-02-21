#!/usr/bin/perl
use strict;
use warnings;

use Test::More;
use t::lib::Test::HT;

ht_test(ExpectationFailed => {}, {
    code   => 417,
    reason => 'Expectation Failed',
});

done_testing;
