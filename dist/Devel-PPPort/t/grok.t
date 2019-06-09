################################################################################
#
#            !!!!!   Do NOT edit this file directly!   !!!!!
#
#            Edit mktests.PL and/or parts/inc/grok instead.
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

  if (10) {
    load();
    plan(tests => 10);
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

ok(&Devel::PPPort::grok_number("42"), 42);
ok(!defined(&Devel::PPPort::grok_number("A")));
ok(&Devel::PPPort::grok_bin("10000001"), 129);
ok(&Devel::PPPort::grok_hex("deadbeef"), 0xdeadbeef);
ok(&Devel::PPPort::grok_oct("377"), 255);

ok(&Devel::PPPort::Perl_grok_number("42"), 42);
ok(!defined(&Devel::PPPort::Perl_grok_number("A")));
ok(&Devel::PPPort::Perl_grok_bin("10000001"), 129);
ok(&Devel::PPPort::Perl_grok_hex("deadbeef"), 0xdeadbeef);
ok(&Devel::PPPort::Perl_grok_oct("377"), 255);

