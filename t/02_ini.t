# -*- perl -*-

# t/02_ini.t - check module loading and create testing directory

use Test::More tests => 4;

use Module::Starter qw(
	Module::Starter::Simple
	Module::Starter::Plugin::Template
	Module::Starter::Plugin::Template::TeTe);
ok(1, "used Module::Starter");

###########################################################################

use_ok( 'File::Path' );

ok (chdir 'blib' || chdir '../blib',
	"chdir 'blib'");

mkpath ('testing', 0, 0775);

ok (chdir 'testing',
	"chdir 'testing'");
