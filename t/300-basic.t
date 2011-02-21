#!/usr/bin/perl
use strict;
use warnings;

use Test::More;
use t::lib::Test::HT;

ht_test(MultipleChoices => { location => '/test' }, {
    code    => 300,
    reason  => 'Multiple Choices',
    headers => [ Location => '/test' ],
});

done_testing;
