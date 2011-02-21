#!/usr/bin/perl

use strict;
use warnings;

use Test::More;
use t::lib::Test::HT;

ht_test(RequestEntityTooLarge => { retry_after => 'A Bit' }, {
    code    => 413,
    reason  => 'Request Entity Too Large',
    headers => [ 'Retry-After' => 'A Bit' ],
});

done_testing;
