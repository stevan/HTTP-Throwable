#!/usr/bin/perl

use strict;
use warnings;

use Test::More;
use Test::Fatal;
use Test::Moose;

BEGIN {
    use_ok('HTTP::Throwable::Forbidden');
}

isa_ok(exception {
    HTTP::Throwable::Forbidden->throw();
}, 'HTTP::Throwable');

does_ok(exception {
    HTTP::Throwable::Forbidden->throw();
}, 'Throwable');

my $e = HTTP::Throwable::Forbidden->new();

my $body = '403 Forbidden';

is($e->as_string, $body, '... got the right string transformation');
is_deeply(
    $e->as_psgi,
    [
        403,
        [
            'Content-Type'   => 'text/plain',
            'Content-Length' => length $body,
        ],
        [ $body ]
    ],
    '... got the right PSGI transformation'
);


done_testing;