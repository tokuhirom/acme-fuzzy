use strict;
use warnings;
use Acme::Fuzzy;
use Test::More tests => 3;

package Some::Long::Name::Class;

sub new { bless {}, shift }
sub foo { 'bar' }

package main;

is(Some::LOng::Name::Klass->new->foo, 'bar', 'class name fallback');
is(Some::Long::Name::Class->neo->foo, 'bar', 'method name fallback');
is(Same::Lang::Nome::Klass->neo->foo, 'bar', 'both');

