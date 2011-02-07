#!/usr/bin/perl

use strict;
use warnings;

use Test::More;
use Test::Fatal;
use Test::Moose;

BEGIN {
    use_ok('HTTP::Throwable::HTTPVersionNotSupported');
}

isa_ok(exception {
    HTTP::Throwable::HTTPVersionNotSupported->throw();
}, 'HTTP::Throwable');

does_ok(exception {
    HTTP::Throwable::HTTPVersionNotSupported->throw();
}, 'Throwable');

my $e = HTTP::Throwable::HTTPVersionNotSupported->new();

my $body = '505 HTTP Version Not Supported';

is($e->as_string, $body, '... got the right string transformation');
is_deeply(
    $e->as_psgi,
    [
        505,
        [
            'Content-Type'   => 'text/plain',
            'Content-Length' => length $body,
        ],
        [ $body ]
    ],
    '... got the right PSGI transformation'
);


done_testing;