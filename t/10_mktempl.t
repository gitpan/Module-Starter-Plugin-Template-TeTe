# t/10_mktempl.t -- tests making template dir

#use Test::More qw/no_plan/;
use Test::More tests => 17;

use_ok ('Module::Starter::Plugin::Template::TeTe');

ok (chdir 'blib/testing' || chdir '../blib/testing', "chdir 'blib/testing'");

###########################################################################

ok (Module::Starter::Plugin::Template::TeTe->
	create_template_directory('templates'),
	"call Module::Starter::Plugin::Template::TeTe->create_template_directory");
	
###########################################################################

ok (chdir 'templates',
	"cd templates");

for (qw( Changes MANIFEST MANIFEST.SKIP cvsignore README Todo
	Makefile.PL Build.PL Module.pm
	00_dist.t 01_load.t pod.t pod-coverage.t )) {
    ok (-e,
		"$_ exists");
}

###########################################################################

