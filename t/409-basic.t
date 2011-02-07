#!/usr/bin/perl

use strict;
use warnings;

use Test::More;
use Test::Fatal;
use Test::Moose;

BEGIN {
    use_ok('HTTP::Throwable::Conflict');
}

isa_ok(exception {
    HTTP::Throwable::Conflict->throw();
}, 'HTTP::Throwable');

does_ok(exception {
    HTTP::Throwable::Conflict->throw();
}, 'Throwable');

my $e = HTTP::Throwable::Conflict->new();

my $body = '409 Conflict';

is($e->as_string, $body, '... got the right string transformation');
is_deeply(
    $e->as_psgi,
    [
        409,
        [
            'Content-Type'   => 'text/plain',
            'Content-Length' => length $body,
        ],
        [ $body ]
    ],
    '... got the right PSGI transformation'
);


done_testing;