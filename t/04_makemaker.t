# t/04_makemaker.t -- tests a build with MakeMaker

#use Test::More qw/no_plan/;
use Test::More tests => 17;

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
my $dirname = 'Sample-Made';
if (-d $dirname)
{
    diag("removing $dirname");
    rmtree($dirname);
}

###########################################################################

Module::Starter->create_distro
			(
				modules		=> ['Sample::Made'],
				author		=> 'Fred Nurk',
				email		=> 'fred@example.com',
				builder		=> 'ExtUtils::MakeMaker',
			);
	
###########################################################################

ok (chdir $dirname, "cd $dirname");

for (qw( Changes Makefile.PL MANIFEST .cvsignore README lib lib/Sample/Made.pm
	t t/00_dist.t t/01_load.t t/pod.t t/pod-coverage.t )) {
    ok (-e,
		"$_ exists");
}

###########################################################################

