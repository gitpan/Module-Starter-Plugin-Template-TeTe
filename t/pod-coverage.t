#!perl -T

use Test::More;
eval "use Test::Pod::Coverage 1.04 tests=>1";
plan skip_all => "Test::Pod::Coverage 1.04 required for testing POD coverage" if $@;
#all_pod_coverage_ok();
pod_coverage_ok("Module::Starter::Plugin::Template::TeTe",
	"Module::Starter::Plugin::Template::TeTe is covered");
