# t/05_build.t -- tests a build with Module::Build

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
				modules		=> ['Sample::Built'],
				author		=> 'Fred Nurk',
				email		=> 'fred@example.com',
				builder		=> 'Module::Build',
			),
	"call Module::Starter->create_distro");
	
###########################################################################

ok (chdir 'Sample-Built',
	"cd Sample-Built");

for (qw( Changes Build.PL MANIFEST .cvsignore README lib lib/Sample/Built.pm
	t t/00_dist.t t/01_load.t t/pod.t t/pod-coverage.t )) {
    ok (-e,
		"$_ exists");
}

###########################################################################

