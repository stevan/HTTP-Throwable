#!/usr/bin/perl

use strict;
use warnings;

use Test::More;
use Test::Fatal;
use Test::Moose;

BEGIN {
    use_ok('HTTP::Throwable::MultipleChoices');
}

isa_ok(exception {
    HTTP::Throwable::MultipleChoices->throw( preferred_location => '/test' );
}, 'HTTP::Throwable');

does_ok(exception {
    HTTP::Throwable::MultipleChoices->throw( preferred_location => '/test' );
}, 'Throwable');

my $e = HTTP::Throwable::MultipleChoices->new( preferred_location => '/test' );

my $body = '300 Multiple Choices';

is($e->as_string, $body, '... got the right string transformation');
is_deeply(
    $e->as_psgi,
    [
        300,
        [
            'Content-Type'   => 'text/plain',
            'Content-Length' => length $body,
            'Location'       => '/test'
        ],
        [ $body ]
    ],
    '... got the right PSGI transformation'
);

done_testing;