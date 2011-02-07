#!/usr/bin/perl

use strict;
use warnings;

use Test::More;
use Test::Fatal;
use Test::Moose;

BEGIN {
    use_ok('HTTP::Throwable::NotFound');
}

isa_ok(exception {
    HTTP::Throwable::NotFound->throw();
}, 'HTTP::Throwable');

does_ok(exception {
    HTTP::Throwable::NotFound->throw();
}, 'Throwable');

my $e = HTTP::Throwable::NotFound->new();

my $body = '404 Not Found';

is($e->as_string, $body, '... got the right string transformation');
is_deeply(
    $e->as_psgi,
    [
        404,
        [
            'Content-Type'   => 'text/plain',
            'Content-Length' => length $body,
        ],
        [ $body ]
    ],
    '... got the right PSGI transformation'
);


done_testing;