# t/03_quick.t -- tests a quick build with minimal options

#use Test::More qw/no_plan/;
use Test::More tests => 15;

use Module::Starter qw(
	Module::Starter::Simple
	Module::Starter::Plugin::Template
	Module::Starter::Plugin::Template::TeTe);
ok(1, "used Module::Starter");

ok (chdir 'blib/testing' || chdir '../blib/testing', "chdir 'blib/testing'");

###########################################################################

ok (Module::Starter->create_distro
			(
				modules		=> ['Sample::Module'],
				author		=> 'Fred Nurk',
				email		=> 'fred@example.com',
			),
	"call Module::Starter->create_distro");
	
###########################################################################

ok (chdir 'Sample-Module',
	"cd Sample-Module");

for (qw( Changes MANIFEST .cvsignore README lib lib/Sample/Module.pm
	t t/00_dist.t t/01_load.t t/pod.t t/pod-coverage.t )) {
    ok (-e,
		"$_ exists");
}

###########################################################################

