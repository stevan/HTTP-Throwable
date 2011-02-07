#!/usr/bin/perl

use strict;
use warnings;

use Test::More;
use Test::Fatal;
use Test::Moose;

BEGIN {
    use_ok('HTTP::Throwable::Gone');
}

isa_ok(exception {
    HTTP::Throwable::Gone->throw();
}, 'HTTP::Throwable');

does_ok(exception {
    HTTP::Throwable::Gone->throw();
}, 'Throwable');

my $e = HTTP::Throwable::Gone->new();

my $body = '410 Gone';

is($e->as_string, $body, '... got the right string transformation');
is_deeply(
    $e->as_psgi,
    [
        410,
        [
            'Content-Type'   => 'text/plain',
            'Content-Length' => length $body,
        ],
        [ $body ]
    ],
    '... got the right PSGI transformation'
);


done_testing;