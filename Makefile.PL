use inc::Module::Install;
name 'Acme-Fuzzy';
all_from 'lib/Acme/Fuzzy.pm';

requires 'Class::Inspector' => '1.23';
requires 'List::MoreUtils'  => '0.22';

tests 't/*.t';
author_tests 'xt';

build_requires 'Test::More';
use_test_base;
auto_include;
WriteAll;
