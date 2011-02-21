#!/usr/bin/perl
use strict;
use warnings;

use Test::More;
use t::lib::Test::HT;

ht_test(HTTPVersionNotSupported => {}, {
    code   => 505,
    reason => 'HTTP Version Not Supported',
});

done_testing;
