#!/usr/bin/perl

use strict;
use warnings;

use Test::More;

use_ok('HTTP::Throwable::BadRequest');
use_ok('HTTP::Throwable::Unauthorized');
use_ok('HTTP::Throwable::Forbidden');
use_ok('HTTP::Throwable::NotFound');
use_ok('HTTP::Throwable::MethodNotAllowed');
use_ok('HTTP::Throwable::NotAcceptable');
use_ok('HTTP::Throwable::ProxyAuthenticationRequired');
use_ok('HTTP::Throwable::RequestTimeout');
use_ok('HTTP::Throwable::Conflict');
use_ok('HTTP::Throwable::Gone');
use_ok('HTTP::Throwable::LengthRequired');
use_ok('HTTP::Throwable::PreconditionFailed');
use_ok('HTTP::Throwable::RequestEntityToLarge');
use_ok('HTTP::Throwable::RequestURITooLong');
use_ok('HTTP::Throwable::UnsupportedMediaType');
use_ok('HTTP::Throwable::RequestedRangeNotSatisfiable');
use_ok('HTTP::Throwable::ExpectationFailed');

done_testing;