#!/usr/bin/perl

use strict;
use warnings;

use Test::More;
use t::lib::Test::HT;

ht_test(RequestTimeout => {}, {
    code   => 408,
    reason => 'Request Timeout',
});

done_testing;
