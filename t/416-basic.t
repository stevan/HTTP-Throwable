#!/usr/bin/perl

use strict;
use warnings;

use Test::More;
use Test::Fatal;
use Test::Moose;

BEGIN {
    use_ok('HTTP::Throwable::RequestedRangeNotSatisfiable');
}

isa_ok(exception {
    HTTP::Throwable::RequestedRangeNotSatisfiable->throw( content_range => 300 );
}, 'HTTP::Throwable');

does_ok(exception {
    HTTP::Throwable::RequestedRangeNotSatisfiable->throw( content_range => 300 );
}, 'Throwable');

my $e = HTTP::Throwable::RequestedRangeNotSatisfiable->new( content_range => 300 );

my $body = '416 Requested Range Not Satisfiable';

is($e->as_string, $body, '... got the right string transformation');
is_deeply(
    $e->as_psgi,
    [
        416,
        [
            'Content-Type'   => 'text/plain',
            'Content-Length' => length $body,
            'Content-Range'  => 300
        ],
        [ $body ]
    ],
    '... got the right PSGI transformation'
);


done_testing;