#!/usr/bin/perl

use strict;
use warnings;

use Test::More;
use t::lib::Test::HT;

ht_test(SeeOther => { location => '/test' }, {
    code    => 303,
    reason  => 'See Other',
    headers => [
        Location => '/test',
    ],
});

done_testing;
