#!/usr/bin/perl

use strict;
use warnings;

use Test::More;
use t::lib::Test::HT;

ht_test(
    TemporaryRedirect => {
        location => '/test',
        additional_headers => [
            'Expires' => 'Soonish'
        ]
    },
    {
        code    => 307,
        reason  => 'Temporary Redirect',
        headers => [
            'Location' => '/test',
            'Expires'  => 'Soonish',
        ],
    },
);

done_testing;
