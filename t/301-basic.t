#!/usr/bin/perl

use strict;
use warnings;

use Test::More;
use Test::Fatal;
use Test::Moose;

BEGIN {
    use_ok('HTTP::Throwable::MovedPermanently');
}

isa_ok(exception {
    HTTP::Throwable::MovedPermanently->throw( new_location => '/test' );
}, 'HTTP::Throwable');

does_ok(exception {
    HTTP::Throwable::MovedPermanently->throw( new_location => '/test' );
}, 'Throwable');

my $e = HTTP::Throwable::MovedPermanently->new( new_location => '/test' );

my $body = '301 Moved Permanently';

is($e->as_string, $body, '... got the right string transformation');
is_deeply(
    $e->as_psgi,
    [
        301,
        [
            'Content-Type'   => 'text/plain',
            'Content-Length' => length $body,
            'Location'       => '/test'
        ],
        [ $body ]
    ],
    '... got the right PSGI transformation'
);


done_testing;