#!/usr/bin/perl

use strict;
use warnings;

use Test::More;
use Test::Fatal;
use Test::Moose;

BEGIN {
    use_ok('HTTP::Throwable::UnsupportedMediaType');
}

isa_ok(exception {
    HTTP::Throwable::UnsupportedMediaType->throw();
}, 'HTTP::Throwable');

does_ok(exception {
    HTTP::Throwable::UnsupportedMediaType->throw();
}, 'Throwable');

my $e = HTTP::Throwable::UnsupportedMediaType->new();

my $body = '415 Unsupported Media Type';

is($e->as_string, $body, '... got the right string transformation');
is_deeply(
    $e->as_psgi,
    [
        415,
        [
            'Content-Type'   => 'text/plain',
            'Content-Length' => length $body,
        ],
        [ $body ]
    ],
    '... got the right PSGI transformation'
);


done_testing;