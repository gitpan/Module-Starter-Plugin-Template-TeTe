# t/03_quick.t -- tests a quick build with minimal options

#use Test::More qw/no_plan/;
use Test::More tests => 16;

use Module::Starter qw(
	Module::Starter::Simple
	Module::Starter::Plugin::Template
	Module::Starter::Plugin::Template::TeTe);
ok(1, "used Module::Starter");

use_ok( 'File::Path' );

ok (chdir 'blib' || chdir '../blib', "chdir 'blib'");
if (!-d 'testing')
{
    mkpath ('testing', 0, 0775);
}
ok (chdir 'testing', "chdir 'testing'");
my $dirname = 'Sample-Module';
if (-d $dirname)
{
    diag("removing $dirname");
    rmtree($dirname);
}

###########################################################################

Module::Starter->create_distro
(
 modules		=> ['Sample::Module'],
 author		=> 'Fred Nurk',
 email		=> 'fred@example.com',
 );
	
###########################################################################

ok (chdir $dirname, "cd $dirname");

for (qw( Changes MANIFEST .cvsignore README lib lib/Sample/Module.pm
	t t/00_dist.t t/01_load.t t/pod.t t/pod-coverage.t )) {
    ok (-e,
		"$_ exists");
}

###########################################################################

