#!/usr/bin/perl

use strict;
use warnings;

use Test::More;
use Test::Fatal;
use Test::Moose;

BEGIN {
    use_ok('HTTP::Throwable::PreconditionFailed');
}

isa_ok(exception {
    HTTP::Throwable::PreconditionFailed->throw();
}, 'HTTP::Throwable');

does_ok(exception {
    HTTP::Throwable::PreconditionFailed->throw();
}, 'Throwable');

my $e = HTTP::Throwable::PreconditionFailed->new();

my $body = '412 Precondition Failed';

is($e->as_string, $body, '... got the right string transformation');
is_deeply(
    $e->as_psgi,
    [
        412,
        [
            'Content-Type'   => 'text/plain',
            'Content-Length' => length $body,
        ],
        [ $body ]
    ],
    '... got the right PSGI transformation'
);


done_testing;