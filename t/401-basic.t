#!/usr/bin/perl

use strict;
use warnings;

use Test::More;
use t::lib::Test::HT;

ht_test(
    Unauthorized => { www_authenticate => 'Basic realm="realm"' },
    {
        code    => 401,
        reason  => 'Unauthorized',
        headers => [ 'WWW-Authenticate' => 'Basic realm="realm"' ],
    },
);

ht_test(
    Unauthorized => {
        www_authenticate => [
            'Basic realm="basic realm"',
            'Digest realm="digest realm"',
        ]
    },
    {
        code    => 401,
        reason  => 'Unauthorized',
        headers => [
            'WWW-Authenticate' => 'Basic realm="basic realm"',
            'WWW-Authenticate' => 'Digest realm="digest realm"',
        ],
    },
);

done_testing;
