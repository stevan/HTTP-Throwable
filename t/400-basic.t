#!/usr/bin/perl

use strict;
use warnings;

use Test::More;
use Test::Fatal;
use Test::Moose;

use t::lib::Test::HT;

ht_test(BadRequest => {}, {
    code   => 400,
    reason => 'Bad Request',
});

done_testing;
