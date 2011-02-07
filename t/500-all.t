#!/usr/bin/perl

use strict;
use warnings;

use Test::More;

use_ok('HTTP::Throwable::InternalServerError');
use_ok('HTTP::Throwable::NotImplemented');
use_ok('HTTP::Throwable::BadGateway');
use_ok('HTTP::Throwable::ServiceUnavailable');
use_ok('HTTP::Throwable::GatewayTimeout');
use_ok('HTTP::Throwable::HTTPVersionNotSupported');

done_testing;
