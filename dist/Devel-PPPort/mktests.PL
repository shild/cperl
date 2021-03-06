################################################################################
#
#  mktests.PL -- generate test files for Devel::PPPort
#
################################################################################
#
#  Version 3.x, Copyright (C) 2004-2013, Marcus Holland-Moritz.
#  Version 2.x, Copyright (C) 2001, Paul Marquess.
#  Version 1.x, Copyright (C) 1999, Kenneth Albanowski.
#
#  This program is free software; you can redistribute it and/or
#  modify it under the same terms as Perl itself.
#
################################################################################

use strict;
$^W = 1;
my $SILENT;

if (@ARGV and $ARGV[0] =~ /--quiet/) {
  $SILENT++;
  shift;
}
elsif (defined $ENV{MAKEFLAGS}
       and $ENV{MAKEFLAGS} =~ /\b(s|silent|quiet)\b/) {
  $SILENT++;
}
elsif ($ENV{PERL_CORE}) {
  $SILENT++;
}

require "./parts/ppptools.pl";

my $template = do { local $/; <DATA> };

generate_tests();

sub generate_tests
{
  my @tests;
  my $file;

  for $file (all_files_in_dir('parts/inc')) {
    my($testfile) = $file =~ /(\w+)\.?$/;  # VMS has a trailing dot
    $testfile = "t/$testfile.t";

    my $spec = parse_partspec($file);
    my $plan = 0;

    if (exists $spec->{tests}) {
      if (!exists $spec->{OPTIONS}{tests} ||
          !exists $spec->{OPTIONS}{tests}{plan}) {
        $spec->{OPTIONS}{tests}{plan} = 'no_plan';
      }
      if ($spec->{OPTIONS}{tests}{plan} eq 'no_plan') {
        $spec->{tests} .= "\ndone_testing();\n";
      }

      print "generating $testfile\n" unless $SILENT;

      my $tmpl = $template;
      $tmpl =~ s/__SOURCE__/$file/mg;
      $tmpl =~ s/__PLAN__/$spec->{OPTIONS}{tests}{plan}/mg;
      $tmpl =~ s/^__TESTS__$/$spec->{tests}/mg;

      if ($] >= 5.006) {
        open FH, ">", $testfile or die "$testfile: $!\n";
      } else {
        open FH, ">$testfile" or die "$testfile: $!\n";
      }
      print FH $tmpl;
      close FH;

      push @tests, $testfile;
    }
  }

  return @tests;
}

__DATA__
################################################################################
#
#            !!!!!   Do NOT edit this file directly!   !!!!!
#
#            Edit mktests.PL and/or __SOURCE__ instead.
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

  if (__PLAN__) {
    load();
    plan(tests => __PLAN__);
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

__TESTS__
