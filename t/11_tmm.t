# t/11_tmm.t -- tests a build with MakeMaker and template dir

#use Test::More qw/no_plan/;
use Test::More tests => 16;

use Module::Starter qw(
	Module::Starter::Simple
	Module::Starter::Plugin::Template
	Module::Starter::Plugin::Template::TeTe);
ok(1, "used Module::Starter");

ok (chdir 'blib/testing' || chdir '../blib/testing', "chdir 'blib/testing'");

###########################################################################

ok (Module::Starter->create_distro
			(
				modules		=> ['Sample::MadeTT'],
				author		=> 'Fred Nurk',
				email		=> 'fred@example.com',
				builder		=> 'ExtUtils::MakeMaker',
				template_dir	=> 'templates',
			),
	"call Module::Starter->create_distro");
	
###########################################################################

ok (chdir 'Sample-MadeTT',
	"cd Sample-MadeTT");

for (qw( Changes Makefile.PL MANIFEST .cvsignore README lib lib/Sample/MadeTT.pm
	t t/00_dist.t t/01_load.t t/pod.t t/pod-coverage.t )) {
    ok (-e,
		"$_ exists");
}

###########################################################################

