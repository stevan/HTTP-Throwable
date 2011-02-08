#!/usr/bin/perl

use strict;
use warnings;

use Test::More;
use Test::Fatal;
use Test::Moose;

BEGIN {
    use_ok('HTTP::Throwable::MethodNotAllowed');
}

isa_ok(exception {
    HTTP::Throwable::MethodNotAllowed->throw( allow => [ 'GET', 'PUT' ] );
}, 'HTTP::Throwable');

does_ok(exception {
    HTTP::Throwable::MethodNotAllowed->throw( allow => [ 'GET', 'PUT' ] );
}, 'Throwable');

my $e = HTTP::Throwable::MethodNotAllowed->new( allow => [ 'GET', 'PUT' ] );

my $body = '405 Method Not Allowed';

is($e->as_string, $body, '... got the right string transformation');
is_deeply(
    $e->as_psgi,
    [
        405,
        [
            'Content-Type'   => 'text/plain',
            'Content-Length' => length $body,
            'Allow'          => 'GET,PUT'
        ],
        [ $body ]
    ],
    '... got the right PSGI transformation'
);

like(exception {
    HTTP::Throwable::MethodNotAllowed->throw( allow => [ 'GET', 'PUT', 'OPTIONS', 'PUT' ] );
}, qr/Attribute \(allow\) does not pass the type constraint/, '... type check works');

like(exception {
    HTTP::Throwable::MethodNotAllowed->throw( allow => [ 'GET', 'PUT', 'OPTIONS', 'TEST' ] );
}, qr/Attribute \(allow\) does not pass the type constraint/, '... type check works');


done_testing;