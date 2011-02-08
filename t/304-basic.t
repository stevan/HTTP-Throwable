#!/usr/bin/perl

use strict;
use warnings;

use Test::More;
use Test::Fatal;
use Test::Moose;

BEGIN {
    use_ok('HTTP::Throwable::NotModified');
}

isa_ok(exception {
    HTTP::Throwable::NotModified->throw( location => '/test', additional_headers => [ 'Expires' => 'Soonish' ] );
}, 'HTTP::Throwable');

does_ok(exception {
    HTTP::Throwable::NotModified->throw( location => '/test', additional_headers => [ 'Expires' => 'Soonish' ] );
}, 'Throwable');

my $e = HTTP::Throwable::NotModified->new( location => '/test', additional_headers => [ 'Expires' => 'Soonish' ] );

my $body = '304 Not Modified';

is($e->as_string, $body, '... got the right string transformation');
is_deeply(
    $e->as_psgi,
    [
        304,
        [
            'Content-Type'   => 'text/plain',
            'Content-Length' => 0,
            'Location'       => '/test',
            'Expires'        => 'Soonish'
        ],
        []
    ],
    '... got the right PSGI transformation'
);


done_testing;