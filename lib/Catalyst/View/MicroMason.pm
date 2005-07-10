package Catalyst::View::MicroMason;

use strict;
use base qw/Catalyst::Base/;
use Text::MicroMason;
use NEXT;

our $VERSION = '0.02';

__PACKAGE__->mk_accessors('template');

=head1 NAME

Catalyst::View::MicroMason - MicroMason View Class

=head1 SYNOPSIS

    # use the helper
    script/create.pl view MicroMason MicroMason

    # lib/MyApp/View/MicroMason.pm
    package MyApp::View::MicroMason;

    use base 'Catalyst::View::MicroMason';

    __PACKAGE__->config(
        Mixins        => [qw( -Filters )], # to use |h and |u
        template_root => '/path/to/comp_root'
    );


    1;
    
    # Meanwhile, maybe in an 'end' action
    $c->forward('MyApp::View::MicroMason');

=head1 DESCRIPTION

Want to use a MicroMason component in your views? No problem!
Catalyst::View::MicroMason comes to the rescue.

=head1 CAVEATS

You have to define C<template_root>.  If C<template_root> is not directly
defined within C<config>, the value comes from C<config->{root}>. If you don't
define it at all, MicroMason is going to use the root of your system.

=head1 METHODS

=cut

sub new {
    my $self = shift;
    my $c    = shift;
    $self = $self->NEXT::new(@_);
    my $root = $c->config->{root};
    my @Mixins  = @{ $self->config->{Mixins} || [] };
    push @Mixins, qw(-TemplateDir -AllowGlobals);
    my %attribs = %{ $self->config };
    $self->template( Text::MicroMason->new( @Mixins,
       template_root => "$root",
       #allow_globals => [qw($c $base $name)], 
       %attribs ) );
    return $self;
}

=head3 process

Renders the component specified in $c->stash->{template} or $c->request->match
to $c->response->output.

Note that the component name must be absolute, or is converted to absolute
(ie, a / is added to the beginning if it doesn't start with one)

MicroMason global variables C<$base>, C<$c> and c<$name> are automatically set to the base, context and name of the app, respectively.

=cut

sub process {
    my ( $self, $c ) = @_;
    $c->res->headers->content_type('text/html;charset=utf8');
    my $component_path = $c->stash->{template} || $c->req->match;
    unless ($component_path) {
        $c->log->debug('No MicroMason component specified for rendering')
          if $c->debug;
        return 0;
    }
    $component_path = '/' . $component_path if ( $component_path !~ m[^/]o );
    $c->log->debug(qq/Rendering component "$component_path"/) if $c->debug;

    # Set the URL base, context and name of the app as global Mason vars
    # $base, $c and $name
    $self->template->set_globals(
        '$base' => $c->req->base,
        '$c'    => $c,
        '$name' => $c->config->{name}
    );

    my $output = eval {
        $self->template->execute(
            file => $component_path,
            %{ $c->stash },    # pass the stash
        );
    };

    if ( my $error = $@ ) {
        chomp $error;
        $error =
          qq/Couldn't render component "$component_path" - error was "$error"/;
        $c->log->error($error);
        $c->error($error);
    }
    $c->res->output( $output );
    return 1;
}

=head3 config

This allows your view subclass to pass additional settings to the
Mason Text::MicroMason->new constructor.

=cut 

=head1 SEE ALSO

L<Catalyst>, L<Text::MicroMason>

=head1 AUTHOR

Jonas Alves C<jgda@cpan.org>

=head1 COPYRIGHT

This program is free software, you can redistribute it and/or modify it under
the same terms as Perl itself.

=cut

1;
