package Catalyst::Helper::View::MicroMason;

use strict;

=head1 NAME

Catalyst::Helper::View::MicroMason - Helper for MicroMason Views

=head1 SYNOPSIS

    script/create.pl view MicroMason MicroMason

=head1 DESCRIPTION

Helper for MicroMason Views.

=head2 METHODS

=head3 mk_compclass

=cut

sub mk_compclass {
    my ( $self, $helper ) = @_;
    my $file = $helper->{file};
    $helper->render_file( 'compclass', $file );
}

=head1 SEE ALSO

L<Catalyst::Manual>, L<Catalyst::Test>, L<Catalyst::Request>,
L<Catalyst::Response>, L<Catalyst::Helper>

=head1 AUTHOR

Jonas Alves, C<jgda@cpan.org>

=head1 LICENSE

This library is free software . You can redistribute it and/or modify it under
the same terms as perl itself.

=cut

1;

__DATA__

__compclass__
package [% class %];

use strict;
use base 'Catalyst::View::MicroMason';

__PACKAGE__->config(
    Mixins => [qw( -Filters )], # to use |h and |u
);
    
=head1 NAME

[% class %] - MicroMason View Component

=head1 SYNOPSIS

    Very simple to use

=head1 DESCRIPTION

Very nice component.

=head1 AUTHOR

Clever guy

=head1 LICENSE

This library is free software . You can redistribute it and/or modify it under
the same terms as perl itself.

=cut

1;
