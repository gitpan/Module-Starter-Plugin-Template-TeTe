use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'Module::Starter::Plugin::Template::TeTe',
    license             => 'perl',
    dist_author         => 'Kathryn Andersen (RUBYKAT) <perlkat AT katspace dot com>',
    dist_version_from   => 'lib/Module/Starter/Plugin/Template/TeTe.pm',
    requires => {
	'File::Spec' => 0,
	'Text::Template' => '1.44',
        'Module::Starter' => 1.34,
        'Module::Starter::Plugin::Template' => 0,
    },
    build_requires => {
        'Test::More' => 0,
    },
    script_files        => ['scripts/create_template_dir'],
    add_to_cleanup      => [ 'Module-Starter-Plugin-Template-TeTe-*' ],
);

$builder->create_build_script();
# create the Makefile.PL if need be
if (! -f 'Makefile.PL')
{
    use Module::Build::Compat;
    print "creating Makefile.PL\n";
    Module::Build::Compat->create_makefile_pl('passthrough', $builder);
}
