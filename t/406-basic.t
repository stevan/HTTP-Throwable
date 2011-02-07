#!/usr/bin/perl

use strict;
use warnings;

use Test::More;
use Test::Fatal;
use Test::Moose;

BEGIN {
    use_ok('HTTP::Throwable::NotAcceptable');
}

isa_ok(exception {
    HTTP::Throwable::NotAcceptable->throw();
}, 'HTTP::Throwable');

does_ok(exception {
    HTTP::Throwable::NotAcceptable->throw();
}, 'Throwable');

my $e = HTTP::Throwable::NotAcceptable->new();

my $body = '406 Not Acceptable';

is($e->as_string, $body, '... got the right string transformation');
is_deeply(
    $e->as_psgi,
    [
        406,
        [
            'Content-Type'   => 'text/plain',
            'Content-Length' => length $body,
        ],
        [ $body ]
    ],
    '... got the right PSGI transformation'
);


done_testing;