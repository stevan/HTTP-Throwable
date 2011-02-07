#!/usr/bin/perl

use strict;
use warnings;

use Test::More;
use Test::Fatal;
use Test::Moose;

BEGIN {
    use_ok('HTTP::Throwable::TemporaryRedirect');
}

isa_ok(exception {
    HTTP::Throwable::TemporaryRedirect->throw( temp_location => '/test', cache_headers => [ 'Expires' => 'Soonish' ] );
}, 'HTTP::Throwable');

does_ok(exception {
    HTTP::Throwable::TemporaryRedirect->throw( temp_location => '/test', cache_headers => [ 'Expires' => 'Soonish' ] );
}, 'Throwable');

my $e = HTTP::Throwable::TemporaryRedirect->new( temp_location => '/test', cache_headers => [ 'Expires' => 'Soonish' ] );

my $body = '307 Temporary Redirect';

is($e->as_string, $body, '... got the right string transformation');
is_deeply(
    $e->as_psgi,
    [
        307,
        [
            'Content-Type'   => 'text/plain',
            'Content-Length' => length $body,
            'Location'       => '/test',
            'Expires'        => 'Soonish'
        ],
        [ $body ]
    ],
    '... got the right PSGI transformation'
);


done_testing;