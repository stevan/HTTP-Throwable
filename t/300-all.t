#!/usr/bin/perl

use strict;
use warnings;

use Test::More;

use_ok('HTTP::Throwable::MultipleChoices');
use_ok('HTTP::Throwable::MovedPermanently');
use_ok('HTTP::Throwable::Found');
use_ok('HTTP::Throwable::SeeOther');
use_ok('HTTP::Throwable::NotModified');
use_ok('HTTP::Throwable::UseProxy');
use_ok('HTTP::Throwable::TemporaryRedirect');

done_testing;