#!/usr/bin/perl

use strict;
use warnings;

use Test::More;
use t::lib::Test::HT;

ht_test(RequestedRangeNotSatisfiable => { content_range => 300 }, {
    code    => 416,
    reason  => 'Requested Range Not Satisfiable',
    headers => [ 'Content-Range' => 300, ],
});

done_testing;
