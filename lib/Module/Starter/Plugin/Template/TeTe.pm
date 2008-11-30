package Module::Starter::Plugin::Template::TeTe;
# vi:et:sw=4 ts=4

use warnings;
use strict;
use ExtUtils::Command qw(mkpath);
use File::Spec;
use Text::Template;
use Data::Dumper;

=head1 NAME

Module::Starter::Plugin::Template::TeTe - Module::Starter plugin for Text::Template templates

=head1 VERSION

This describes version B<0.06> of Module::Starter::Plugin::Template::TeTe

=cut

our $VERSION = '0.06';

=head1 SYNOPSIS

 use Module::Starter qw(
   Module::Starter::Simple
   Module::Starter::Plugin::Template
   Module::Starter::Plugin::Template::TeTe
 );

 Module::Starter->create_distro(%args);

=head1 DESCRIPTION

This plugin is designed to be added to a Module::Starter::Simple-compatible
Module::Starter class.  It uses the API provided by
Module::Starter::Plugin::Template and implements "render" and "templates"
methods using the Text::Template template system.

=head1 CLASS METHODS

=head2 new(%args)

This plugin calls the C<new> supermethod and then sets various defaults.

Note that this will also set itself from the @ARGV array.

This takes the following arguments in addition to its parents:

=over

=item DELIMITERS => ['[==', '==]']

Delimiters used to mark template text. (default '[==' and '==]')
If the user wishes to change the delimiters, they need to make sure
that they have template files for all the used templates, because
if a template is missing, the default template will be used, and
they use the default delimiters.

=item template_dir => I<directory>

Name of the directory to look for templates.  If this is not set,
then all the templates will simply be the default ones.

=item version => I<version_string>

Define the version, in case you don't want to use the default '0.01'.

=item need_new_method => 1

If your module is object-oriented, then it will need a "new" method.
(default: off)

=back

=cut

sub new {
    my $class = shift;
    my $self  = $class->SUPER::new(@_, @ARGV);
	$self->{DELIMITERS} ||= ['[==', '==]'];
	$self->{template_dir} ||= '';
    $self->{version} ||= '0.01';
    $self->{need_new_method} ||= 0;

    $self->{timestamp} = scalar localtime;
    $self->{year} = (localtime())[5] + 1900;
    bless $self => $class;
}

=head1 OBJECT METHODS

=head2 templates()

This method is used to initialize the template store on the
Module::Starter object.  It returns a hash of templates; each key is a
(file)name and each value is the body of the template.  The name
"Module.pm" is used for the module template.

=cut

sub templates {
    my $self = shift;

    my %templates = $self->default_templates();
    # now get any templates from the template dir
    if ($self->{template_dir}
        && opendir TDIR, $self->{template_dir})
    {
        while (my $file = readdir(TDIR))
        {
            if ($file !~ /^\./) # no dotfiles allowed
            {
                my $fullname =
                    File::Spec->catfile($self->{template_dir}, $file);
                # read the file and make its contents the template
                if (open (FILE, $fullname)) {
                    my $filetext = do {local $/; <FILE>};
                    close FILE;
                    if ($filetext) {
                        $templates{$file} = $filetext;
                    }
                }
            }
        }
        closedir TDIR;
    }
    return %templates;
}

=head2 renderer()

This method is used to initialize the template renderer.  Its result is
stored in the object's C<renderer> entry.

In this case, no renderer is created, because the Text::Template
needs to be created per template, so there's nothing to make here.

=cut

sub renderer {
    my $self = shift;
    $self->{renderer} = undef;
}

=head2 render($template, \%options)

The C<render> method will render the template passed to it, using the
data in the Module::Starter object and in the hash of passed parameters.

=cut

sub render {
    my $self = shift;
    my $template_text = shift;
    my $options = shift;
    if (!defined $options)
    {
        $options = {};
    }
    my $data = {
	%{$self},
	%{$options},
    };

    my $tt = Text::Template->new(
		    TYPE => 'STRING',
		    SOURCE => $template_text,
		    DELIMITERS => $self->{'DELIMITERS'},
		    )
	    or die "Template error: could not make template\n";
    my $ret_str = $tt->fill_in(HASH => $data)
		or die "Template error: Could not write output\n";
    return $ret_str;
}

=head2 create_template_directory($directory)

    Module::Starter::Plugin::Templates::TeTe->
        create_template_directory( $directory );

Creates the named I<$directory> and populates it with a file for each
default template.  These can be customized and the directory used in
conjunction with the B<template_dir> configuration option.
Returns a true value if successful.

=cut

sub create_template_directory ($$) {
    my $self = shift;
    my $dir = shift;
    if (not -d $dir)
    {
        local @ARGV = $dir;
        mkpath();
        die "Couldn't create $dir: $!\n" unless -d $dir;
    }

    my %templates = $self->default_templates();
	while (my ($name, $template) = each(%templates )) {
        # clean up the templates a bit, to get rid of that ugly
        # [=='='==] thing
        $template =~ s/^\[=='='==\]/=/mg;
		open (FILE, ">$dir/$name")
            or die "Could not write '$dir/$name': $!";
		print FILE $template;
		close FILE;
	}
	return 1;
}

=head1 INTERNAL METHODS

These methods are used internally. They are documented for developer
purposes only and may change in future releases.  End users are
encouraged to avoid using them.

=head2 default_templates()

    $self->default_templates();
 
Generates the default templates from <<HERE statements in the code.
Returns a hash containing the default templates.

Templates included are:

	* Module.pm
	* Makefile.PL
	* Build.PL
	* Changes
	* README
	* 00_dist.t
	* 01_load.t
	* pod.t
	* pod-coverage.t
	* MANIFEST
	* MANIFEST.SKIP
    * cvsignore
	* Todo

=cut

sub default_templates {
	my ($self) = @_;
	my %templates;

#-------------------------------------------------------------------------#
	
	$templates{'Module.pm'} = <<'EOF';
package [==$module==];
use strict;
use warnings;

[=='='==]head1 NAME

[==$module==] - Put abstract here 

[=='='==]head1 VERSION

This describes version B<[==$version==]> of [==$module==].

[=='='==]cut

our $VERSION = '[==$version==]';

[=='='==]head1 SYNOPSIS

  use [==$module==];
  blah blah blah

[=='='==]head1 DESCRIPTION

The writer of this module didn't write a description.

[=='='==]cut

[==if ($need_new_method) {
    $OUT="
\=head1 METHODS

\=head2 new

\=cut
";
$OUT .='
sub new {
    my $class = shift;
	my %parameters = @_;
	my $self = bless ({%parameters}, ref ($class) || $class);
	return ($self);
} # new
';
}
else {
    $OUT="
\=head1 FUNCTIONS

\=head2 function1

\=cut

sub function1 {

} # function1
";
}==]
[=='='==]head1 BUGS

Please report any bugs or feature requests to the author.

[=='='==]head1 AUTHOR

    [==$author==]
    [==$email==]

[=='='==]head1 COPYRIGHT & LICENCE

Copyright (c) [==$year==] by [==$author==]
[==if ($license eq 'perl') {
    $OUT='
This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.
';
} else {
    $OUT="Licence: $license";
}==]

[=='='==]head1 SEE ALSO

perl(1).

[=='='==]cut

1; # End of [==$module==]
__END__
EOF

#-------------------------------------------------------------------------#
	
	$templates{'Makefile.PL'} = <<'EOF';
use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => '[==$main_module==]',
    AUTHOR              => '[=="$author <$email>"==]',
    VERSION_FROM        => '[==$main_pm_file==]',
    ABSTRACT_FROM       => '[==$main_pm_file==]',
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => '[==${distro}==]-*' },
);
EOF

#-------------------------------------------------------------------------#
	
	$templates{'Build.PL'} = <<'EOF';
use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => '[==$main_module==]',
    license             => '[==$license==]',
    dist_author         => '[=="${author} <${email}>"==]',
    dist_version_from   => '[==$main_pm_file==]',
	requires            => {
	     # module requirements here
	},
    build_requires => {
        'Test::More' => 0,
    },
    add_to_cleanup      => [ '[==${distro}==]-*' ],
    create_makefile_pl => 'traditional',
);

$builder->create_build_script();
EOF

#-------------------------------------------------------------------------#
	
	$templates{'Changes'} = <<'EOF';
Revision history for Perl module [==$distro==]
=================================[=='='x length($distro)==]

[==$version==] [==$timestamp==]
	- original version; created by Module::Starter
EOF
	
	$templates{'Todo'} = <<'EOF';
TODO list for Perl module [==$distro==]

- Nothing yet

EOF
	
#-------------------------------------------------------------------------#
	
	$templates{'README'} = <<'EOF';
[==$distro==]
[=='=' x length($distro)==]

The README is used to introduce the module and provide instructions on
how to install the module, any machine dependencies it may have (for
example C compilers and installed libraries) and any other information
that should be provided before the module is installed.

A README file is required for CPAN modules since CPAN extracts the README
file from a module distribution so that people browsing the archive
can use it get an idea of the modules uses. It is usually a good idea
to provide version information here so that people can decide whether
fixes for the module are worth downloading.

INSTALLATION

[==$build_instructions==]

COPYRIGHT AND LICENCE

Copyright (c) [==$year==] [==$author==]
[==if ($license eq 'perl') {
    $OUT='
This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.
';
} else {
    $OUT='Put the correct copyright and licence information here.'
}==]
EOF

#-------------------------------------------------------------------------#
	
	$templates{'00_dist.t'} = <<'EOF';
# Test distribution before release
# Optional for end users if Test::Distribution not installed

use Test::More;

BEGIN {
	eval {
   	   require Test::Distribution;
	};
	if($@) {
   	   plan skip_all => "Test::Distribution not installed";
	}
	else {
   	   import Test::Distribution;
	}
}
EOF

	$templates{'01_load.t'} = <<'EOF';
use Test::More tests => [==@modules==];

BEGIN {
[==$OUT = join("\n", map{ "use_ok( '$_' );" } @modules);==]
}

diag( "Testing [==$modules[0]==] ${[==$modules[0]==]::VERSION}" );
EOF

    $templates{'pod.t'} = <<'HERE';
#!perl -T

use Test::More;
eval "use Test::Pod 1.14";
plan skip_all => "Test::Pod 1.14 required for testing POD" if $@;
all_pod_files_ok();
HERE

    $templates{'pod-coverage.t'} = <<'HERE';
#!perl -T

use Test::More;
eval "use Test::Pod::Coverage 1.04";
plan skip_all => "Test::Pod::Coverage 1.04 required for testing POD coverage" if $@;
all_pod_coverage_ok();
HERE

#-------------------------------------------------------------------------#
	
	$templates{'MANIFEST'} = <<'EOF';
[==$OUT=''; $OUT .= "$_\n" for @files;==]
EOF

#-------------------------------------------------------------------------#
	
	$templates{'MANIFEST.SKIP'} = <<'EOF';
# Version control files and dirs.
\bRCS\b
\bCVS\b
,v$

# distro files
[==${distro}==]-*

# ExtUtils::MakeMaker generated files and dirs.
^Makefile$
^blib/
^blibdirs$
^pm_to_blib$
^MakeMaker-\d

# Module::Build
^Build$
^_build

# Temp, old, vi and emacs files.
~$
\.old$
^#.*#$
^\.#
\.swp$
\.bak$
EOF

#-------------------------------------------------------------------------#
	
	$templates{'cvsignore'} = <<'EOF';
blib*
Build
Makefile
Makefile.old
pm_to_blib*
*.tar.gz
.lwpcookies
[==${distro}==]-*
cover_db
EOF

#----------------------------------------------------------------------#
	
return %templates;

}

=head1 REQUIRES

    File::Spec
    Text::Template
    Module::Starter
    Module::Starter::Plugin::Template

=head1 INSTALLATION

To install this module, run the following commands:

    perl Build.PL
    ./Build
    ./Build test
    ./Build install

=head1 AUTHOR

Kathryn Andersen (RUBYKAT), C<< <perlkat AT katspace dot com> >>

=head1 BUGS

Please report any bugs or feature requests to the author
at the above address.

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2004 Kathryn Andersen

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

1; # End of Module::Starter::Plugin::Template::TeTe
