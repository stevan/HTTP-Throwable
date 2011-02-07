#!/usr/bin/perl

use strict;
use warnings;

use Test::More;
use Test::Fatal;
use Test::Moose;

BEGIN {
    use_ok('HTTP::Throwable::InternalServerError');
}

isa_ok(exception {
    HTTP::Throwable::InternalServerError->throw();
}, 'HTTP::Throwable');

does_ok(exception {
    HTTP::Throwable::InternalServerError->throw();
}, 'Throwable');

my $e = HTTP::Throwable::InternalServerError->new();

my $body = '500 Internal Server Error' . "\n\n";

is($e->as_string, $body, '... got the right string transformation');
is_deeply(
    $e->as_psgi,
    [
        500,
        [
            'Content-Type'   => 'text/plain',
            'Content-Length' => length $body,
        ],
        [ $body ]
    ],
    '... got the right PSGI transformation'
);


done_testing;