#!/usr/bin/perl
use strict;
use warnings;

use Test::More;
use t::lib::Test::HT;

ht_test(NotAcceptable => {}, {
    code   => 406,
    reason => 'Not Acceptable',
});

done_testing;
