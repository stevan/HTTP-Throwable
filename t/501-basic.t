#!/usr/bin/perl

use strict;
use warnings;

use Test::More;
use Test::Fatal;
use Test::Moose;

BEGIN {
    use_ok('HTTP::Throwable::NotImplemented');
}

isa_ok(exception {
    HTTP::Throwable::NotImplemented->throw();
}, 'HTTP::Throwable');

does_ok(exception {
    HTTP::Throwable::NotImplemented->throw();
}, 'Throwable');

my $e = HTTP::Throwable::NotImplemented->new();

my $body = '501 Not Implemented';

is($e->as_string, $body, '... got the right string transformation');
is_deeply(
    $e->as_psgi,
    [
        501,
        [
            'Content-Type'   => 'text/plain',
            'Content-Length' => length $body,
        ],
        [ $body ]
    ],
    '... got the right PSGI transformation'
);


done_testing;