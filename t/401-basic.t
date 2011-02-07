#!/usr/bin/perl

use strict;
use warnings;

use Test::More;
use Test::Fatal;
use Test::Moose;

BEGIN {
    use_ok('HTTP::Throwable::Unauthorized');
}

isa_ok(exception {
    HTTP::Throwable::Unauthorized->throw( www_authenticate => 'Basic "realm"');
}, 'HTTP::Throwable');

does_ok(exception {
    HTTP::Throwable::Unauthorized->throw( www_authenticate => 'Basic "realm"');
}, 'Throwable');

my $e = HTTP::Throwable::Unauthorized->new( www_authenticate => 'Basic "realm"');

my $body = '401 Unauthorized';

is($e->as_string, $body, '... got the right string transformation');
is_deeply(
    $e->as_psgi,
    [
        401,
        [
            'Content-Type'     => 'text/plain',
            'Content-Length'   => length $body,
            'WWW-Authenticate' => 'Basic "realm"'
        ],
        [ $body ]
    ],
    '... got the right PSGI transformation'
);


done_testing;