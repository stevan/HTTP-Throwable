#!/usr/bin/perl

use strict;
use warnings;

use Test::More;
use Test::Fatal;
use Test::Moose;

BEGIN {
    use_ok('HTTP::Throwable::ImATeapot');
}

isa_ok(exception {
    HTTP::Throwable::ImATeapot->throw();
}, 'HTTP::Throwable');

does_ok(exception {
    HTTP::Throwable::ImATeapot->throw();
}, 'Throwable');

my $e = HTTP::Throwable::ImATeapot->new();

my $body = "418 I'm a teapot";

like($e->as_string, qr/\A$body\b/, '... got the right status line');

for my $this (
    [ 1, 1, 'SHORT AND STOUT' ],
    [ 1, 0, 'SHORT NOT STOUT' ],
    [ 0, 1, 'MERELY STOUT' ],
    [ 0, 0, 'WITH A SPOUT' ],
) {
    my $e = HTTP::Throwable::ImATeapot->new(
      short => $this->[0],
      stout => $this->[1],
    );

    like($e->as_string, qr/$this->[2]/, "contains proper message");

    diag $e->as_string;
}

done_testing;
