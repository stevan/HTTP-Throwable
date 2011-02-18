package HTTP::Throwable::Role::Status::RequestedRangeNotSatisfiable;
use Moose;
use MooseX::StrictConstructor;

extends 'HTTP::Throwable';

has '+status_code' => ( default => 416 );
has '+reason'      => ( default => 'Requested Range Not Satisfiable' );

has 'content_range' => ( is => 'ro', isa => 'Str' );

around 'build_headers' => sub {
    my $next    = shift;
    my $self    = shift;
    my $headers = $self->$next( @_ );
    if ( my $content_range = $self->content_range ) {
        push @$headers => ('Content-Range' => $content_range);
    }
    $headers;
};

__PACKAGE__->meta->make_immutable;

no Moose; 1;

__END__

# ABSTRACT: 416 Requested Range Not Satisfiable

=head1 DESCRIPTION

A server SHOULD return a response with this status code if a
request included a Range request-header field, and none of the
range-specifier values in this field overlap the current extent
of the selected resource, and the request did not include an
If-Range request-header field. (For byte-ranges, this means that
the first-byte-pos of all of the byte-range-spec values were greater
than the current length of the selected resource.)

When this status code is returned for a byte-range request, the
response SHOULD include a Content-Range entity-header field specifying
the current length of the selected resource. This response MUST NOT
use the multipart/byteranges content-type.

