# t/10_mktempl.t -- tests making template dir

#use Test::More qw/no_plan/;
use Test::More tests => 19;

use_ok ('Module::Starter::Plugin::Template::TeTe');

use_ok( 'File::Path' );

ok (chdir 'blib' || chdir '../blib', "chdir 'blib'");
if (!-d 'testing')
{
    mkpath ('testing', 0, 0775);
}
ok (chdir 'testing', "chdir 'testing'");
my $dirname = 'templates';
if (-d $dirname)
{
    diag("removing $dirname");
    rmtree($dirname);
}

###########################################################################

ok (Module::Starter::Plugin::Template::TeTe->
	create_template_directory('templates'),
	"call Module::Starter::Plugin::Template::TeTe->create_template_directory");
	
###########################################################################

ok (chdir $dirname, "cd $dirname");

for (qw( Changes MANIFEST MANIFEST.SKIP cvsignore README Todo
	Makefile.PL Build.PL Module.pm
	00_dist.t 01_load.t pod.t pod-coverage.t )) {
    ok (-e,
		"$_ exists");
}

###########################################################################

