#!/usr/bin/perl
use strict;
use warnings;

use Test::More;
use t::lib::Test::HT;

ht_test(ServiceUnavailable => { retry_after => 'A Little While' }, {
    code    => 503,
    reason  => 'Service Unavailable',
    headers => [ 'Retry-After' => 'A Little While' ],
});

done_testing;
