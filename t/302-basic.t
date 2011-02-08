#!/usr/bin/perl

use strict;
use warnings;

use Test::More;
use Test::Fatal;
use Test::Moose;

BEGIN {
    use_ok('HTTP::Throwable::Found');
}

isa_ok(exception {
    HTTP::Throwable::Found->throw( location => '/test', additional_headers => [ 'Expires' => 'Soonish' ]);
}, 'HTTP::Throwable');

does_ok(exception {
    HTTP::Throwable::Found->throw( location => '/test', additional_headers => [ 'Expires' => 'Soonish' ]);
}, 'Throwable');

my $e = HTTP::Throwable::Found->new( location => '/test', additional_headers => [ 'Expires' => 'Soonish' ]);

my $body = '302 Found';

is($e->as_string, $body, '... got the right string transformation');
is_deeply(
    $e->as_psgi,
    [
        302,
        [
            'Content-Type'   => 'text/plain',
            'Content-Length' => length $body,
            'Location'       => '/test',
            'Expires'        => 'Soonish',
        ],
        [ $body ]
    ],
    '... got the right PSGI transformation'
);


done_testing;