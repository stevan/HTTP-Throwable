#!/usr/bin/perl

use strict;
use warnings;

use Test::More;
use Test::Fatal;
use Test::Moose;

BEGIN {
    use_ok('HTTP::Throwable::ServiceUnavailable');
}

isa_ok(exception {
    HTTP::Throwable::ServiceUnavailable->throw( retry_after => 'A Little While' );
}, 'HTTP::Throwable');

does_ok(exception {
    HTTP::Throwable::ServiceUnavailable->throw( retry_after => 'A Little While' );
}, 'Throwable');

my $e = HTTP::Throwable::ServiceUnavailable->new( retry_after => 'A Little While' );

my $body = '503 Service Unavailable';

is($e->as_string, $body, '... got the right string transformation');
is_deeply(
    $e->as_psgi,
    [
        503,
        [
            'Content-Type'   => 'text/plain',
            'Content-Length' => length $body,
            'Retry-After'    => 'A Little While'
        ],
        [ $body ]
    ],
    '... got the right PSGI transformation'
);


done_testing;