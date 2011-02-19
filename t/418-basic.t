#!/usr/bin/perl
use strict;
use warnings;

use Test::More;
use Test::Deep qw(ignore re);

use t::lib::Test::HT;

for my $this (
    [ 1, 1, qr/SHORT AND STOUT/ ],
    [ 1, 0, qr/SHORT NOT STOUT/ ],
    [ 0, 1, qr/MERELY STOUT/ ],
    [ 0, 0, qr/WITH A SPOUT/ ],
) {
  ht_test(ImATeapot => { short => $this->[0], stout => $this->[1] }, {
    code   => 418,
    reason => q{I'm a teapot},
    length => ignore(),
    body   => re($this->[2]),
  });
}

done_testing;
