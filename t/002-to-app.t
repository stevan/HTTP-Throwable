#!/usr/bin/perl

use strict;
use warnings;

use Test::More;
use Plack::Test;
use Plack::Builder;
use HTTP::Request::Common qw[ GET ];

BEGIN {
    use_ok('HTTP::Throwable::MovedPermanently');
    use_ok('HTTP::Throwable::NotFound');
    use_ok('HTTP::Throwable::MethodNotAllowed');
}


test_psgi(
    app => builder {
        mount '/old' => HTTP::Throwable::MovedPermanently->new(
            location => '/new'
        );
        mount '/new' => sub {
            [ 200, [], ['HERE']];
        };
    },
    client => sub {
        my $cb = shift;

        {
            my $req = GET "/old";
            my $res = $cb->($req);
            is($res->code, 301, '... got the right status code');
            is($res->header('Content-Type'), 'text/plain', '... got the right Content-Type header');
            is($res->header('Content-Length'), 21, '... got the right Content-Length header');
            is($res->header('Location'), '/new', '... got the right Allow header');
            is($res->content, '301 Moved Permanently', '... got the right content body');
        }
        {
            my $req = GET "/new";
            my $res = $cb->($req);
            is($res->code, 200, '... got the right status code');
            is($res->content, 'HERE', '... got the right content body');
        }
    }
);

test_psgi(
    app => HTTP::Throwable::MethodNotAllowed->new( allow => [qw[ POST PUT ]] )->to_app,
    client => sub {
        my $cb = shift;

        {
            my $req = GET "/";
            my $res = $cb->($req);
            is($res->code, 405, '... got the right status code');
            is($res->header('Content-Type'), 'text/plain', '... got the right Content-Type header');
            is($res->header('Content-Length'), 22, '... got the right Content-Length header');
            is($res->header('Allow'), 'POST,PUT', '... got the right Allow header');
            is($res->content, '405 Method Not Allowed', '... got the right content body');
        }
    }
);

test_psgi(
    app => HTTP::Throwable::NotFound->new,
    client => sub {
        my $cb = shift;

        {
            my $req = GET "/";
            my $res = $cb->($req);
            is($res->code, 404, '... got the right status code');
            is($res->header('Content-Type'), 'text/plain', '... got the right Content-Type header');
            is($res->header('Content-Length'), 13, '... got the right Content-Length header');
            is($res->content, '404 Not Found', '... got the right content body');
        }
    }
);


done_testing;