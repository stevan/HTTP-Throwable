#!/usr/bin/perl

use strict;
use warnings;

use Test::More;
use Test::Fatal;
use Test::Moose;

BEGIN {
    use_ok('HTTP::Throwable');
}

isa_ok(exception {
    HTTP::Throwable->throw( status_code => 500, reason => 'Internal Server Error' );
}, 'HTTP::Throwable');

does_ok(exception {
    HTTP::Throwable->throw( status_code => 500, reason => 'Internal Server Error' );
}, 'Throwable');

my $e = HTTP::Throwable->new( status_code => 500, reason => 'Internal Server Error' );

is($e->as_string, '500 Internal Server Error', '... got the right string transformation');
is_deeply(
    $e->as_psgi,
    [
        500,
        [
            'Content-Type'   => 'text/plain',
            'Content-Length' => 25,
        ],
        [ '500 Internal Server Error' ]
    ],
    '... got the right PSGI transformation'
);

is("$e", '500 Internal Server Error', '... got the right string overload');
is_deeply(
    $e->(),
    [
        500,
        [
            'Content-Type'   => 'text/plain',
            'Content-Length' => 25,
        ],
        [ '500 Internal Server Error' ]
    ],
    '... got the right &{} overload transformation'
);

{
    my $e = HTTP::Throwable->new( status_code => 500, reason => 'Internal Server Error' );
    ok( !$e->is_redirect );
    ok( !$e->is_client_error );
    ok( $e->is_server_error );
}

{
    my $e = HTTP::Throwable->new( status_code => 403, reason => 'Forbidden' );
    ok( !$e->is_redirect );
    ok( $e->is_client_error );
    ok( !$e->is_server_error );
}

{
    my $e = HTTP::Throwable->new( status_code => 302, reason => 'Found' );
    ok( $e->is_redirect );
    ok( !$e->is_client_error );
    ok( !$e->is_server_error );
}

done_testing;
