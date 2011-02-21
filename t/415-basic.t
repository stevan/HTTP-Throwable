#!/usr/bin/perl

use strict;
use warnings;

use Test::More;
use t::lib::Test::HT;

ht_test(UnsupportedMediaType => {}, {
    code   => 415,
    reason => 'Unsupported Media Type',
});

done_testing;
