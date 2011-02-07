#!/usr/bin/perl

use strict;
use warnings;

use Test::More;
use Test::Fatal;
use Test::Moose;

BEGIN {
    use_ok('HTTP::Throwable::RequestURITooLong');
}

isa_ok(exception {
    HTTP::Throwable::RequestURITooLong->throw();
}, 'HTTP::Throwable');

does_ok(exception {
    HTTP::Throwable::RequestURITooLong->throw();
}, 'Throwable');

my $e = HTTP::Throwable::RequestURITooLong->new();

my $body = '414 Request-URI Too Long';

is($e->as_string, $body, '... got the right string transformation');
is_deeply(
    $e->as_psgi,
    [
        414,
        [
            'Content-Type'   => 'text/plain',
            'Content-Length' => length $body,
        ],
        [ $body ]
    ],
    '... got the right PSGI transformation'
);


done_testing;