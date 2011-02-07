#!/usr/bin/perl

use strict;
use warnings;

use Test::More;
use Test::Fatal;
use Test::Moose;

BEGIN {
    use_ok('HTTP::Throwable::UseProxy');
}

isa_ok(exception {
    HTTP::Throwable::UseProxy->throw( proxy_location => '/proxy/test' );
}, 'HTTP::Throwable');

does_ok(exception {
    HTTP::Throwable::UseProxy->throw( proxy_location => '/proxy/test' );
}, 'Throwable');

my $e = HTTP::Throwable::UseProxy->new( proxy_location => '/proxy/test' );

my $body = '305 Use Proxy';

is($e->as_string, $body, '... got the right string transformation');
is_deeply(
    $e->as_psgi,
    [
        305,
        [
            'Content-Type'   => 'text/plain',
            'Content-Length' => length $body,
            'Location'       => '/proxy/test',
        ],
        [ $body ]
    ],
    '... got the right PSGI transformation'
);


done_testing;