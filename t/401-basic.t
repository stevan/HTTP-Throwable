#!/usr/bin/perl

use strict;
use warnings;

use Test::More;
use Test::Fatal;
use Test::Moose;

BEGIN {
    use_ok('HTTP::Throwable::Unauthorized');
}

isa_ok(exception {
    HTTP::Throwable::Unauthorized->throw( www_authenticate => 'Basic realm="realm"');
}, 'HTTP::Throwable');

does_ok(exception {
    HTTP::Throwable::Unauthorized->throw( www_authenticate => 'Basic realm="realm"');
}, 'Throwable');

{
    my $e = HTTP::Throwable::Unauthorized->new( www_authenticate => 'Basic realm="realm"');

    my $body = '401 Unauthorized';

    is($e->as_string, $body, '... got the right string transformation');
    is_deeply(
        $e->as_psgi,
        [
            401,
            [
                'Content-Type'     => 'text/plain',
                'Content-Length'   => length $body,
                'WWW-Authenticate' => 'Basic realm="realm"'
            ],
            [ $body ]
        ],
        '... got the right PSGI transformation'
    );
}

{
    my $e = HTTP::Throwable::Unauthorized->new(
        www_authenticate => [
            'Basic realm="secret but not secure"',
            'Digest realm="a little more secure"'
        ]
    );

    my $body = '401 Unauthorized';

    is($e->as_string, $body, '... got the right string transformation');
    is_deeply(
        $e->as_psgi,
        [
            401,
            [
                'Content-Type'     => 'text/plain',
                'Content-Length'   => length $body,
                'WWW-Authenticate' => 'Basic realm="secret but not secure"',
                'WWW-Authenticate' => 'Digest realm="a little more secure"'
            ],
            [ $body ]
        ],
        '... got the right PSGI transformation'
    );
}

done_testing;