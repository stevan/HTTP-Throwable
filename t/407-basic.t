#!/usr/bin/perl

use strict;
use warnings;

use Test::More;
use t::lib::Test::HT;

ht_test(
  ProxyAuthenticationRequired => {
    proxy_authenticate => 'Basic realm="realm"'
  },
  {
    code    => 407,
    reason  => 'Proxy Authentication Required',
    headers => [ 'Proxy-Authenticate' => 'Basic realm="realm"' ],
  },
);

ht_test(
  ProxyAuthenticationRequired => {
    proxy_authenticate => [
      'Basic realm="realm"',
      'Digest realm="other_realm"',
    ],
  },
  {
    code    => 407,
    reason  => 'Proxy Authentication Required',
    headers => [
      'Proxy-Authenticate' => 'Basic realm="realm"',
      'Proxy-Authenticate' => 'Digest realm="other_realm"',
    ],
  },
);

done_testing;
