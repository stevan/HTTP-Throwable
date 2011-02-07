# HTTP-Throwable

This is a set of exception classes corresponding to the
HTTP error status code (4xx-5xx) and the redirection
codes (3xx).

## See Also

This module is similar to HTTP::Exception with a few,
well uhm, exceptions. First, we are not implementing
the 1xx and 2xx status codes, it is this authors opinion
that those not being errors or an exception control flow
(redirection) should not be handled with exceptions. And
secondly, this module is very PSGI friendly in that it
can turn your exception into a PSGI response with just
a method call.

## Installation

To install this module type the following:

    perl Makefile.PL
    make
    make test
    make install

## Dependencies

This module requires these other modules and libraries:

    Moose
    Throwable

## Copyright and License

Copyright (C) 2011 Infinity Interactive, Inc.

(http://www.iinteractive.com)

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.









