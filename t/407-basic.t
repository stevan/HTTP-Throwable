#!/usr/bin/perl

use strict;
use warnings;

use Test::More;
use Test::Fatal;
use Test::Moose;

BEGIN {
    use_ok('HTTP::Throwable::ProxyAuthenticationRequired');
}

isa_ok(exception {
    HTTP::Throwable::ProxyAuthenticationRequired->throw( proxy_authenticate => 'Basic realm="realm"' );
}, 'HTTP::Throwable');

does_ok(exception {
    HTTP::Throwable::ProxyAuthenticationRequired->throw( proxy_authenticate => 'Basic realm="realm"' );
}, 'Throwable');

{
    my $e = HTTP::Throwable::ProxyAuthenticationRequired->new( proxy_authenticate => 'Basic realm="realm"' );
    my $body = '407 Proxy Authentication Required';

    is($e->as_string, $body, '... got the right string transformation');
    is_deeply(
        $e->as_psgi,
        [
            407,
            [
                'Content-Type'        => 'text/plain',
                'Content-Length'      => length $body,
                 'Proxy-Authenticate' => 'Basic realm="realm"'
            ],
            [ $body ]
        ],
        '... got the right PSGI transformation'
    );
}

{
    my $e = HTTP::Throwable::ProxyAuthenticationRequired->new(
        proxy_authenticate => [
            'Basic realm="realm"',
            'Digest realm="other_realm"'
        ]
    );
    my $body = '407 Proxy Authentication Required';

    is($e->as_string, $body, '... got the right string transformation');
    is_deeply(
        $e->as_psgi,
        [
            407,
            [
                'Content-Type'        => 'text/plain',
                'Content-Length'      => length $body,
                 'Proxy-Authenticate' => 'Basic realm="realm"',
                 'Proxy-Authenticate' => 'Digest realm="other_realm"',
            ],
            [ $body ]
        ],
        '... got the right PSGI transformation'
    );
}

done_testing;