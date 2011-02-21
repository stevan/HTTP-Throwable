#!/usr/bin/perl
use strict;
use warnings;

use Test::More;
use t::lib::Test::HT;

ht_test(PreconditionFailed => {}, {
    code   => 412,
    reason => 'Precondition Failed',
});

done_testing;
