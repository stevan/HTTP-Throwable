#!/usr/bin/perl

use strict;
use warnings;

use Test::More;
use Test::Fatal;
use Test::Moose;

BEGIN {
    use_ok('HTTP::Throwable::SeeOther');
}

isa_ok(exception {
    HTTP::Throwable::SeeOther->throw( location => '/test' );
}, 'HTTP::Throwable');

does_ok(exception {
    HTTP::Throwable::SeeOther->throw( location => '/test' );
}, 'Throwable');

my $e = HTTP::Throwable::SeeOther->new( location => '/test' );

my $body = '303 See Other';

is($e->as_string, $body, '... got the right string transformation');
is_deeply(
    $e->as_psgi,
    [
        303,
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