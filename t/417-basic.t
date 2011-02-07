#!/usr/bin/perl

use strict;
use warnings;

use Test::More;
use Test::Fatal;
use Test::Moose;

BEGIN {
    use_ok('HTTP::Throwable::ExpectationFailed');
}

isa_ok(exception {
    HTTP::Throwable::ExpectationFailed->throw();
}, 'HTTP::Throwable');

does_ok(exception {
    HTTP::Throwable::ExpectationFailed->throw();
}, 'Throwable');

my $e = HTTP::Throwable::ExpectationFailed->new();

my $body = '417 Expectation Failed';

is($e->as_string, $body, '... got the right string transformation');
is_deeply(
    $e->as_psgi,
    [
        417,
        [
            'Content-Type'   => 'text/plain',
            'Content-Length' => length $body,
        ],
        [ $body ]
    ],
    '... got the right PSGI transformation'
);


done_testing;