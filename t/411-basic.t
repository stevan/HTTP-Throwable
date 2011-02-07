#!/usr/bin/perl

use strict;
use warnings;

use Test::More;
use Test::Fatal;
use Test::Moose;

BEGIN {
    use_ok('HTTP::Throwable::LengthRequired');
}

isa_ok(exception {
    HTTP::Throwable::LengthRequired->throw();
}, 'HTTP::Throwable');

does_ok(exception {
    HTTP::Throwable::LengthRequired->throw();
}, 'Throwable');

my $e = HTTP::Throwable::LengthRequired->new();

my $body = '411 Length Required';

is($e->as_string, $body, '... got the right string transformation');
is_deeply(
    $e->as_psgi,
    [
        411,
        [
            'Content-Type'   => 'text/plain',
            'Content-Length' => length $body,
        ],
        [ $body ]
    ],
    '... got the right PSGI transformation'
);


done_testing;