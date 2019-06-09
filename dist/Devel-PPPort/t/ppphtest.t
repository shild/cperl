################################################################################
#
#            !!!!!   Do NOT edit this file directly!   !!!!!
#
#            Edit mktests.PL and/or parts/inc/ppphtest instead.
#
#  This file was automatically generated from the definition files in the
#  parts/inc/ subdirectory by mktests.PL. To learn more about how all this
#  works, please read the F<HACKERS> file that came with this distribution.
#
################################################################################

BEGIN {
  if ($ENV{'PERL_CORE'}) {
    chdir 't' if -d 't';
    if (-d '../lib' && -d '../dist/Devel-PPPort') {
      @INC = ('../lib', '../dist/Devel-PPPort/t');
    } elsif (-d '../../../lib' && -d '../../../dist/Devel-PPPort') {
      @INC = ('../../../lib', '.');
    }
    require Config; import Config;
    use vars '%Config';
    if (" $Config{'extensions'} " !~ m[ Devel/PPPort ]) {
      print "1..0 # Skip -- Perl configured without Devel::PPPort module\n";
      exit 0;
    }
  }
  else {
    unshift @INC, 't';
  }

  sub load {
    require 'testutil.pl';
  }

  if (238) {
    load();
    plan(tests => 238);
  }
}

use Devel::PPPort;
use strict;
$^W = 1;

package Devel::PPPort;
use vars '@ISA';
require DynaLoader;
@ISA = qw(DynaLoader);
bootstrap Devel::PPPort;

package main;

BEGIN {
  if ($ENV{'SKIP_SLOW_TESTS'}) {
    for (1 .. 238) {
      skip("skip: SKIP_SLOW_TESTS", 0);
    }
    exit 0;
  }
}

use File::Path qw/rmtree mkpath/;
use Config;

my $tmp = 'ppptmp';
my $inc = '';
my $isVMS = $^O eq 'VMS';
my $isMAC = $^O eq 'MacOS';
my $perl = find_perl();

rmtree($tmp) if -d $tmp;
mkpath($tmp) or die "mkpath $tmp: $!\n";
chdir($tmp) or die "chdir $tmp: $!\n";

if ($ENV{'PERL_CORE'}) {
  if (-d '../../lib') {
    if ($isVMS) {
      $inc = '"-I../../lib"';
    }
    elsif ($isMAC) {
      $inc = '-I:::lib';
    }
    else {
      $inc = '-I../../lib';
    }
    unshift @INC, '../../lib';
  }
}
if ($perl =~ m!^\./!) {
  $perl = ".$perl";
}

END {
  chdir('..') if !-d $tmp && -d "../$tmp";
  rmtree($tmp) if -d $tmp;
}

ok(&Devel::PPPort::WriteFile("ppport.h"));

# Check GetFileContents()
ok(-e "ppport.h", 1);

my $data;

open(F, "<ppport.h") or die "Failed to open ppport.h: $!";
while(<F>) {
  $data .= $_;
}
close(F);

ok(Devel::PPPort::GetFileContents("ppport.h"), $data);
ok(Devel::PPPort::GetFileContents(), $data);

sub comment
{
  my $c = shift;
  my $x = 0;
  $c =~ s/^/sprintf("# %2d| ", ++$x)/meg;
  $c .= "\n" unless $c =~ /[\r\n]$/;
  print $c;
}

sub ppport
{
  my @args = ('ppport.h', @_);
  unshift @args, $inc if $inc;
  my $run = $perl =~ m/\s/ ? qq("$perl") : $perl;
  $run .= ' -MMac::err=unix' if $isMAC;
  for (@args) {
    $_ = qq("$_") if $isVMS && /^[^"]/;
    $run .= " $_";
  }
  print "# *** running $run ***\n";
  $run .= ' 2>&1' unless $isMAC;
  my @out = `$run`;
  my $out = join '', @out;
  comment($out);
  return wantarray ? @out : $out;
}

sub matches
{
  my($str, $re, $mod) = @_;
  my @n;
  eval "\@n = \$str =~ /$re/g$mod;";
  if ($@) {
    my $err = $@;
    $err =~ s/^/# *** /mg;
    print "# *** ERROR ***\n$err\n";
  }
  return $@ ? -42 : scalar @n;
}

sub eq_files
{
  my($f1, $f2) = @_;
  return 0 unless -e $f1 && -e $f2;
  local *F;
  for ($f1, $f2) {
    print "# File: $_\n";
    unless (open F, $_) {
      print "# couldn't open $_: $!\n";
      return 0;
    }
    $_ = do { local $/; <F> };
    close F;
    comment($_);
  }
  return $f1 eq $f2;
}

my @tests;

for (split /\s*={70,}\s*/, do { local $/; <DATA> }) {
  s/^\s+//; s/\s+$//;
  my($c, %f);
  ($c, @f{m/-{20,}\s+(\S+)\s+-{20,}/g}) = split /\s*-{20,}\s+\S+\s+-{20,}\s*/;
  push @tests, { code => $c, files => \%f };
}

my $t;
for $t (@tests) {
  print "#\n", ('# ', '-'x70, "\n")x3, "#\n";
  my $f;
  for $f (keys %{$t->{files}}) {
    my @f = split /\//, $f;
    if (@f > 1) {
      pop @f;
      my $path = join '/', @f;
      mkpath($path) or die "mkpath('$path'): $!\n";
    }
    my $txt = $t->{files}{$f};
    local *F;
    open F, ">$f" or die "open $f: $!\n";
    print F "$txt\n";
    close F;
    print "# *** writing $f ***\n";
    comment($txt);
  }

  print "# *** evaluating test code ***\n";
  comment($t->{code});

  eval $t->{code};
  if ($@) {
    my $err = $@;
    $err =~ s/^/# *** /mg;
    print "# *** ERROR ***\n$err\n";
  }
  ok($@, '');

  for (keys %{$t->{files}}) {
    unlink $_ or die "unlink('$_'): $!\n";
  }
}

sub find_perl
{
  my $perl = $^X;

  return $perl if $isVMS;

  my $exe = $Config{'_exe'} || '';

  if ($perl =~ /^perl\Q$exe\E$/i) {
    $perl = "perl$exe";
    eval "require File::Spec";
    if ($@) {
      $perl = "./$perl";
    } else {
      $perl = File::Spec->catfile(File::Spec->curdir(), $perl);
    }
  }

  if ($perl !~ /\Q$exe\E$/i) {
    $perl .= $exe;
  }

  warn "find_perl: cannot find $perl from $^X" unless -f $perl;

  return $perl;
}

__DATA__

my $o = ppport(qw(--help));
ok($o =~ /^Usage:.*ppport\.h/m);
ok($o =~ /--help/m);

$o = ppport(qw(--version));
ok($o =~ /^This is.*ppport.*\d+\.\d+(?:_?\d+)?\.$/);

$o = ppport(qw(--nochanges));
ok($o =~ /^Scanning.*test\.xs/mi);
ok($o =~ /Analyzing.*test\.xs/mi);
ok(matches($o, '^Scanning', 'm'), 1);
ok(matches($o, 'Analyzing', 'm'), 1);
ok($o =~ /Uses Perl_newSViv instead of newSViv/);

$o = ppport(qw(--quiet --nochanges));
ok($o =~ /^\s*$/);

---------------------------- test.xs ------------------------------------------

Perl_newSViv();

===============================================================================

# check if C and C++ comments are filtered correctly

my $o = ppport(qw(--copy=a));
ok($o =~ /^Scanning.*MyExt\.xs/mi);
ok($o =~ /Analyzing.*MyExt\.xs/mi);
ok(matches($o, '^Scanning', 'm'), 1);
ok($o =~ /^Needs to include.*ppport\.h/m);
ok($o !~ /^Uses grok_bin/m);
ok($o !~ /^Uses newSVpv/m);
ok($o =~ /Uses 1 C\+\+ style comment/m);
ok(eq_files('MyExt.xsa', 'MyExt.ra'));

# check if C++ are left untouched with --cplusplus

$o = ppport(qw(--copy=b --cplusplus));
ok($o =~ /^Scanning.*MyExt\.xs/mi);
ok($o =~ /Analyzing.*MyExt\.xs/mi);
ok(matches($o, '^Scanning', 'm'), 1);
ok($o =~ /^Needs to include.*ppport\.h/m);
ok($o !~ /^Uses grok_bin/m);
ok($o !~ /^Uses newSVpv/m);
ok($o !~ /Uses \d+ C\+\+ style comment/m);
ok(eq_files('MyExt.xsb', 'MyExt.rb'));

unlink qw(MyExt.xsa MyExt.xsb);

---------------------------- MyExt.xs -----------------------------------------

newSVuv();
    // newSVpv();
  XPUSHs(foo);
/* grok_bin(); */

---------------------------- MyExt.ra -----------------------------------------

#include "ppport.h"
newSVuv();
    /* newSVpv(); */
  XPUSHs(foo);
/* grok_bin(); */

---------------------------- MyExt.rb -----------------------------------------

#include "ppport.h"
newSVuv();
    // newSVpv();
  XPUSHs(foo);
/* grok_bin(); */

===============================================================================

my $o = ppport(qw(--nochanges file1.xs));
ok($o =~ /^Scanning.*file1\.xs/mi);
ok($o =~ /Analyzing.*file1\.xs/mi);
ok($o !~ /^Scanning.*file2\.xs/mi);
ok($o =~ /^Uses newCONSTSUB/m);
ok($o =~ /^Uses PL_expect/m);
ok($o =~ /^Uses SvPV_nolen.*depends.*sv_2pv_flags/m);
ok($o =~ /WARNING: PL_expect/m);
ok($o =~ /hint for newCONSTSUB/m);
ok($o =~ /^Analysis completed \(1 warning\)/m);
ok($o =~ /^Looks good/m);

$o = ppport(qw(--nochanges --nohints file1.xs));
ok($o =~ /^Scanning.*file1\.xs/mi);
ok($o =~ /Analyzing.*file1\.xs/mi);
ok($o !~ /^Scanning.*file2\.xs/mi);
ok($o =~ /^Uses newCONSTSUB/m);
ok($o =~ /^Uses PL_expect/m);
ok($o =~ /^Uses SvPV_nolen.*depends.*sv_2pv_flags/m);
ok($o =~ /WARNING: PL_expect/m);
ok($o !~ /hint for newCONSTSUB/m);
ok($o =~ /^Analysis completed \(1 warning\)/m);
ok($o =~ /^Looks good/m);

$o = ppport(qw(--nochanges --nohints --nodiag file1.xs));
ok($o =~ /^Scanning.*file1\.xs/mi);
ok($o =~ /Analyzing.*file1\.xs/mi);
ok($o !~ /^Scanning.*file2\.xs/mi);
ok($o !~ /^Uses newCONSTSUB/m);
ok($o !~ /^Uses PL_expect/m);
ok($o !~ /^Uses SvPV_nolen/m);
ok($o =~ /WARNING: PL_expect/m);
ok($o !~ /hint for newCONSTSUB/m);
ok($o =~ /^Analysis completed \(1 warning\)/m);
ok($o =~ /^Looks good/m);

$o = ppport(qw(--nochanges --quiet file1.xs));
ok($o =~ /^\s*$/);

$o = ppport(qw(--nochanges file2.xs));
ok($o =~ /^Scanning.*file2\.xs/mi);
ok($o =~ /Analyzing.*file2\.xs/mi);
ok($o !~ /^Scanning.*file1\.xs/mi);
ok($o =~ /^Uses mXPUSHp/m);
ok($o =~ /^Needs to include.*ppport\.h/m);
ok($o !~ /^Looks good/m);
ok($o =~ /^1 potentially required change detected/m);

$o = ppport(qw(--nochanges --nohints file2.xs));
ok($o =~ /^Scanning.*file2\.xs/mi);
ok($o =~ /Analyzing.*file2\.xs/mi);
ok($o !~ /^Scanning.*file1\.xs/mi);
ok($o =~ /^Uses mXPUSHp/m);
ok($o =~ /^Needs to include.*ppport\.h/m);
ok($o !~ /^Looks good/m);
ok($o =~ /^1 potentially required change detected/m);

$o = ppport(qw(--nochanges --nohints --nodiag file2.xs));
ok($o =~ /^Scanning.*file2\.xs/mi);
ok($o =~ /Analyzing.*file2\.xs/mi);
ok($o !~ /^Scanning.*file1\.xs/mi);
ok($o !~ /^Uses mXPUSHp/m);
ok($o !~ /^Needs to include.*ppport\.h/m);
ok($o !~ /^Looks good/m);
ok($o =~ /^1 potentially required change detected/m);

$o = ppport(qw(--nochanges --quiet file2.xs));
ok($o =~ /^\s*$/);

---------------------------- file1.xs -----------------------------------------

#define NEED_newCONSTSUB
#define NEED_PL_parser
#include "ppport.h"

newCONSTSUB();
SvPV_nolen();
PL_expect = 0;

---------------------------- file2.xs -----------------------------------------

mXPUSHp(foo);

===============================================================================

my $o = ppport(qw(--nochanges));
ok($o =~ /^Scanning.*FooBar\.xs/mi);
ok($o =~ /Analyzing.*FooBar\.xs/mi);
ok(matches($o, '^Scanning', 'm'), 1);
ok($o !~ /^Looks good/m);
ok($o =~ /^Uses grok_bin/m);

---------------------------- FooBar.xs ----------------------------------------

newSViv();
XPUSHs(foo);
grok_bin();

===============================================================================

my $o = ppport(qw(--nochanges));
ok($o =~ /^Scanning.*First\.xs/mi);
ok($o =~ /Analyzing.*First\.xs/mi);
ok($o =~ /^Scanning.*second\.h/mi);
ok($o =~ /Analyzing.*second\.h/mi);
if ($] < 5.006001) {
  skip("skip Scanning.*sub.*third with perl $]");  #96
  skip("skip Analyzing.*sub.*third with perl $]"); #97
  skip("skip ^Scanning == 3");
} else {
  ok($o =~ /^Scanning.*sub.*third\.c/mi);
  ok($o =~ /Analyzing.*sub.*third\.c/mi);
  ok(matches($o, '^Scanning', 'm'), 3);
}
ok($o !~ /^Scanning.*foobar/mi);
# warn '# ',$o;

---------------------------- First.xs -----------------------------------------

one

---------------------------- foobar.xyz ---------------------------------------

two

---------------------------- second.h -----------------------------------------

three

---------------------------- sub/third.c --------------------------------------

four

===============================================================================

my $o = ppport(qw(--nochanges));
ok($o =~ /Possibly wrong #define NEED_foobar in.*test.xs/i);

---------------------------- test.xs ------------------------------------------

#define NEED_foobar

===============================================================================

# And now some complex "real-world" example

my $o = ppport(qw(--copy=f));
for (qw(main.xs mod1.c mod2.c mod3.c mod4.c mod5.c)) {
  ok($o =~ /^Scanning.*\Q$_\E/mi);
  ok($o =~ /Analyzing.*\Q$_\E/i);
}
ok(matches($o, '^Scanning', 'm'), 6);

ok(matches($o, '^Writing copy of', 'm'), 5);
ok(!-e "mod5.cf");

for (qw(main.xs mod1.c mod2.c mod3.c mod4.c)) {
  ok($o =~ /^Writing copy of.*\Q$_\E.*with changes/mi);
  ok(-e "${_}f");
  ok(eq_files("${_}f", "${_}r"));
  unlink "${_}f";
}

---------------------------- main.xs ------------------------------------------

#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#define NEED_newCONSTSUB
#define NEED_grok_hex_GLOBAL
#include "ppport.h"

newCONSTSUB();
grok_hex();
Perl_grok_bin(aTHX_ foo, bar);

/* some comment */

perl_eval_pv();
grok_bin();
Perl_grok_bin(bar, sv_no);

---------------------------- mod1.c -------------------------------------------

#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#define NEED_grok_bin_GLOBAL
#define NEED_newCONSTSUB
#include "ppport.h"

newCONSTSUB();
grok_bin();
{
  Perl_croak ("foo");
  Perl_sv_catpvf();  /* I know it's wrong ;-) */
}

---------------------------- mod2.c -------------------------------------------

#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#define NEED_eval_pv
#include "ppport.h"

newSViv();

/*
   eval_pv();
*/

---------------------------- mod3.c -------------------------------------------

#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

grok_oct();
eval_pv();

---------------------------- mod4.c -------------------------------------------

#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

START_MY_CXT;

---------------------------- mod5.c -------------------------------------------

#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "ppport.h"
call_pv();

---------------------------- main.xsr -----------------------------------------

#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#define NEED_eval_pv_GLOBAL
#define NEED_grok_hex
#define NEED_newCONSTSUB_GLOBAL
#include "ppport.h"

newCONSTSUB();
grok_hex();
grok_bin(foo, bar);

/* some comment */

eval_pv();
grok_bin();
grok_bin(bar, PL_sv_no);

---------------------------- mod1.cr ------------------------------------------

#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#define NEED_grok_bin_GLOBAL
#include "ppport.h"

newCONSTSUB();
grok_bin();
{
  Perl_croak (aTHX_ "foo");
  Perl_sv_catpvf(aTHX);  /* I know it's wrong ;-) */
}

---------------------------- mod2.cr ------------------------------------------

#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"


newSViv();

/*
   eval_pv();
*/

---------------------------- mod3.cr ------------------------------------------

#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#define NEED_grok_oct
#include "ppport.h"

grok_oct();
eval_pv();

---------------------------- mod4.cr ------------------------------------------

#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include "ppport.h"

START_MY_CXT;

===============================================================================

my $o = ppport(qw(--nochanges));
ok($o =~ /Uses grok_hex/m);
ok($o !~ /Looks good/m);

$o = ppport(qw(--nochanges --compat-version=5.8.0));
ok($o !~ /Uses grok_hex/m);
ok($o =~ /Looks good/m);

---------------------------- FooBar.xs ----------------------------------------

grok_hex();

===============================================================================

my $o = ppport(qw(--nochanges));
ok($o =~ /Uses SvPVutf8_force, which may not be portable/m);

$o = ppport(qw(--nochanges --compat-version=5.5.3));
ok($o =~ /Uses SvPVutf8_force, which may not be portable/m);

$o = ppport(qw(--nochanges --compat-version=5.005_03));
ok($o =~ /Uses SvPVutf8_force, which may not be portable/m);

$o = ppport(qw(--nochanges --compat-version=5.6.0));
ok($o !~ /Uses SvPVutf8_force/m);

$o = ppport(qw(--nochanges --compat-version=5.006));
ok($o !~ /Uses SvPVutf8_force/m);

$o = ppport(qw(--nochanges --compat-version=5.999.999));
ok($o !~ /Uses SvPVutf8_force/m);

$o = ppport(qw(--nochanges --compat-version=6.0.0));
ok($o =~ /Only Perl 5 is supported/m);

$o = ppport(qw(--nochanges --compat-version=5.1000.999));
ok($o =~ /Invalid version number: 5.1000.999/m);

$o = ppport(qw(--nochanges --compat-version=5.999.1000));
ok($o =~ /Invalid version number: 5.999.1000/m);

---------------------------- FooBar.xs ----------------------------------------

SvPVutf8_force();

===============================================================================

my $o = ppport(qw(--nochanges));
ok($o !~ /potentially required change/);
ok(matches($o, '^Looks good', 'm'), 2);

---------------------------- FooBar.xs ----------------------------------------

#define NEED_grok_numeric_radix
#define NEED_grok_number
#include "ppport.h"

GROK_NUMERIC_RADIX();
grok_number();

---------------------------- foo.c --------------------------------------------

#include "ppport.h"

call_pv();

===============================================================================

# check --api-info option

my $o = ppport(qw(--api-info=INT2PTR));
my %found = map {($_ => 1)} $o =~ /^===\s+(\w+)\s+===/mg;
ok(scalar keys %found, 1);
ok(exists $found{INT2PTR});
ok(matches($o, '^Supported at least starting from perl-5\.6\.0\.', 'm'), 1);
ok(matches($o, '^Support by .*ppport.* provided back to perl-5\.003\.', 'm'), 1);

$o = ppport(qw(--api-info=Zero));
%found = map {($_ => 1)} $o =~ /^===\s+(\w+)\s+===/mg;
ok(scalar keys %found, 1);
ok(exists $found{Zero});
ok(matches($o, '^No portability information available\.', 'm'), 1);

$o = ppport(qw(--api-info=/Zero/));
%found = map {($_ => 1)} $o =~ /^===\s+(\w+)\s+===/mg;
ok(scalar keys %found, 2);
ok(exists $found{Zero});
ok(exists $found{ZeroD});

===============================================================================

# check --list-provided option

my @o = ppport(qw(--list-provided));
my %p;
my $fail = 0;
for (@o) {
  my($name, $flags) = /^(\w+)(?:\s+\[(\w+(?:,\s+\w+)*)\])?$/ or $fail++;
  exists $p{$name} and $fail++;
  $p{$name} = defined $flags ? { map { ($_ => 1) } $flags =~ /(\w+)/g } : '';
}
ok(@o > 100);
ok($fail, 0);

ok(exists $p{call_pv});
ok(not ref $p{call_pv});

ok(exists $p{grok_bin});
ok(ref $p{grok_bin}, 'HASH');
ok(scalar keys %{$p{grok_bin}}, 2);
ok($p{grok_bin}{explicit});
ok($p{grok_bin}{depend});

ok(exists $p{gv_stashpvn});
ok(ref $p{gv_stashpvn}, 'HASH');
ok(scalar keys %{$p{gv_stashpvn}}, 2);
ok($p{gv_stashpvn}{depend});
ok($p{gv_stashpvn}{hint});

ok(exists $p{sv_catpvf_mg});
ok(ref $p{sv_catpvf_mg}, 'HASH');
ok(scalar keys %{$p{sv_catpvf_mg}}, 2);
ok($p{sv_catpvf_mg}{explicit});
ok($p{sv_catpvf_mg}{depend});

ok(exists $p{PL_signals});
ok(ref $p{PL_signals}, 'HASH');
ok(scalar keys %{$p{PL_signals}}, 1);
ok($p{PL_signals}{explicit});

===============================================================================

# check --list-unsupported option

my @o = ppport(qw(--list-unsupported));
my %p;
my $fail = 0;
for (@o) {
  my($name, $ver) = /^(\w+)\s*\.+\s*([\d._]+)$/ or $fail++;
  exists $p{$name} and $fail++;
  $p{$name} = $ver;
}
ok(@o > 100);
ok($fail, 0);

ok(exists $p{utf8_distance});
ok($p{utf8_distance}, '5.6.0');

ok(exists $p{save_generic_svref});
ok($p{save_generic_svref}, '5.005_03');

===============================================================================

# check --nofilter option

my $o = ppport(qw(--nochanges));
ok($o =~ /^Scanning.*foo\.cpp/mi);
ok($o =~ /Analyzing.*foo\.cpp/mi);
ok(matches($o, '^Scanning', 'm'), 1);
ok(matches($o, 'Analyzing', 'm'), 1);

$o = ppport(qw(--nochanges foo.cpp foo.o Makefile.PL));
ok($o =~ /Skipping the following files \(use --nofilter to avoid this\):/m);
ok(matches($o, '^\|\s+foo\.o', 'mi'), 1);
ok(matches($o, '^\|\s+Makefile\.PL', 'mi'), 1);
ok($o =~ /^Scanning.*foo\.cpp/mi);
ok($o =~ /Analyzing.*foo\.cpp/mi);
ok(matches($o, '^Scanning', 'm'), 1);
ok(matches($o, 'Analyzing', 'm'), 1);

$o = ppport(qw(--nochanges --nofilter foo.cpp foo.o Makefile.PL));
ok($o =~ /^Scanning.*foo\.cpp/mi);
ok($o =~ /Analyzing.*foo\.cpp/mi);
ok($o =~ /^Scanning.*foo\.o/mi);
ok($o =~ /Analyzing.*foo\.o/mi);
ok($o =~ /^Scanning.*Makefile/mi);
ok($o =~ /Analyzing.*Makefile/mi);
ok(matches($o, '^Scanning', 'm'), 3);
ok(matches($o, 'Analyzing', 'm'), 3);

---------------------------- foo.cpp ------------------------------------------

newSViv();

---------------------------- foo.o --------------------------------------------

newSViv();

---------------------------- Makefile.PL --------------------------------------

newSViv();

===============================================================================

# check if explicit variables are handled propery

my $o = ppport(qw(--copy=a));
ok($o =~ /^Needs to include.*ppport\.h/m);
ok($o =~ /^Uses PL_signals/m);
ok($o =~ /^File needs PL_signals, adding static request/m);
ok(eq_files('MyExt.xsa', 'MyExt.ra'));

unlink qw(MyExt.xsa);

---------------------------- MyExt.xs -----------------------------------------

PL_signals = 123;
if (PL_signals == 42)
  foo();

---------------------------- MyExt.ra -----------------------------------------

#define NEED_PL_signals
#include "ppport.h"
PL_signals = 123;
if (PL_signals == 42)
  foo();

===============================================================================

my $o = ppport(qw(--nochanges file.xs));
ok($o =~ /^Uses PL_copline/m);
ok($o =~ /WARNING: PL_copline/m);
ok($o =~ /^Uses SvUOK/m);
ok($o =~ /WARNING: Uses SvUOK, which may not be portable/m);
ok($o =~ /^Analysis completed \(2 warnings\)/m);
ok($o =~ /^Looks good/m);

$o = ppport(qw(--nochanges --compat-version=5.8.0 file.xs));
ok($o =~ /^Uses PL_copline/m);
ok($o =~ /WARNING: PL_copline/m);
ok($o !~ /WARNING: Uses SvUOK, which may not be portable/m);
ok($o =~ /^Analysis completed \(1 warning\)/m);
ok($o =~ /^Looks good/m);

---------------------------- file.xs -----------------------------------------

#define NEED_PL_parser
#include "ppport.h"
SvUOK
PL_copline

===============================================================================

my $o = ppport(qw(--copy=f));

for (qw(file.xs)) {
  ok($o =~ /^Writing copy of.*\Q$_\E.*with changes/mi);
  ok(-e "${_}f");
  ok(eq_files("${_}f", "${_}r"));
  unlink "${_}f";
}

---------------------------- file.xs -----------------------------------------

a_string = "sv_undef"
a_char = 'sv_yes'
#define SOMETHING defgv
/* C-comment: sv_tainted */
#
# This is just a big XS comment using sv_no
#
/* The following, is NOT an XS comment! */
#  define SOMETHING_ELSE defgv + \
                         sv_undef

---------------------------- file.xsr -----------------------------------------

#include "ppport.h"
a_string = "sv_undef"
a_char = 'sv_yes'
#define SOMETHING PL_defgv
/* C-comment: sv_tainted */
#
# This is just a big XS comment using sv_no
#
/* The following, is NOT an XS comment! */
#  define SOMETHING_ELSE PL_defgv + \
                         PL_sv_undef

===============================================================================

my $o = ppport(qw(--copy=f));

for (qw(file.xs)) {
  ok($o =~ /^Writing copy of.*\Q$_\E.*with changes/mi);
  ok(-e "${_}f");
  ok(eq_files("${_}f", "${_}r"));
  unlink "${_}f";
}

---------------------------- file.xs -----------------------------------------

#define NEED_warner
#include "ppport.h"
Perl_croak_nocontext("foo");
Perl_croak("bar");
croak("foo");
croak_nocontext("foo");
Perl_warner_nocontext("foo");
Perl_warner("foo");
warner_nocontext("foo");
warner("foo");

---------------------------- file.xsr -----------------------------------------

#define NEED_warner
#include "ppport.h"
Perl_croak_nocontext("foo");
Perl_croak(aTHX_ "bar");
croak("foo");
croak_nocontext("foo");
Perl_warner_nocontext("foo");
Perl_warner(aTHX_ "foo");
warner_nocontext("foo");
warner("foo");

