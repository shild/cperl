#!./perl -- -*- mode: cperl; cperl-indent-level: 4 -*-

BEGIN {
    chdir 't' if -d 't';
    @INC = ( '.', '../lib' );
}

use strict;
use Config ();
use vars '$a', '$b';
require '../t/test.pl';
skip_all("test only with ivsize 8") unless $Config::Config{ivsize} == 8;
push @INC, 'cpan/Math-BigInt/lib' if is_miniperl();
plan(15);

$|=1;
# XXX 64bit IV only. needs to be global to bypass constant folding.
$a = 18446744073709551614;
$b = 1844674407370955162400;

# test it at compile-time in constant folding
use exact_arith;
my $n = 18446744073709551614 * 2; # => Math::BigInt or *::GMP
like(ref $n, qr/^Math::BigInt/,  '* type (c)');
ok($n eq '36893488147419103228', '* val (c)');

{
    no exact_arith;
    my $m = 18446744073709551614 * 2;
    is(ref $m, '', '* no type (c)');
    is($m, 3.68934881474191e+19, '* no val (c)');
}

my $two = 2;
$n = $a * $two; # run-time
like(ref $n, qr/^Math::BigInt/,  '* type (r)');
ok($n eq '36893488147419103228', '* val (r)');

{
    no exact_arith;
    my $m = $a * $two;
    is(ref $m, '', '* no type (r)');
    is($m, 3.68934881474191e+19, '* no val (r)');
}

my $c = 18446744073709551614 + 10000;
like(ref $c, qr/^Math::BigInt/,  '+ type (c)');
my $r = $a + 10000;
like(ref $r, qr/^Math::BigInt/,  '+ type (r)');

$c = 18446744073709551614 - (- 2);
like(ref $c, qr/^Math::BigInt/,  '- type (c)');
$r = $c  - 1;
like(ref $r, qr/^Math::BigInt/,  '- type (r)');

# gets smaller, not bigger. with 0.3 we switch to NV
#$c = $b / 3;
#like(ref $c, qr/^Math::BigInt/,  '/ type (c)');
#$r = $b / 3;
#like(ref $r, qr/^Math::BigInt/,  '/ type (r)');

$c = 18446744073709551614 ** 2;
like(ref $c, qr/^Math::BigInt/,  '** type (c)');
$r = $a ** 2;
like(ref $r, qr/^Math::BigInt/,  '** type (r)');

$a++;
$r = $a++;
like(ref $r, qr/^Math::BigInt/,  '++ type (r)');
