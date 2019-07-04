use strict;

use Test::More;
use Config;
use CPAN::Distroprefs;
use File::Spec;

my $yamlclass = $^V =~ /c$/
  ? ($] >= 5.030 ? 'YAML::Safe' : 'YAML::XS')
  : 'YAML';
my %ext = (
  yml => $yamlclass,
);
eval "require $ext{yml}; 1"
  or plan skip_all => "$ext{yml} required";
plan tests => 4;

my $finder = CPAN::Distroprefs->find(
  './distroprefs', \%ext,
);
my $LoadFile = sub {
  no strict 'refs';
  my $m = "${yamlclass}::LoadFile";
  if ($yamlclass eq 'YAML::Safe') {
    my $c = $yamlclass;
    my $o = $c->new->nonstrict;
    $o->SafeLoadFile(@_);
  } elsif ($^V =~ /c$/ && $yamlclass eq 'YAML::XS') { # only the cperl variant
    local $YAML::XS::NonStrict = 1;
    $m->LoadFile(@_);
  } else {
    $m->(@_);
  }
};

my $last = '0';
my (@errors, @ymlerrors);
while (my $next = $finder->next) {
  if ( $next->file lt $last ) {
      push @errors, $next->file . " lt $last\n";
  }
  $last = $next->file;
  if ($last =~ /\.ya?ml/) {
    my $result;
    eval { $result = $LoadFile->("distroprefs/$last") };
    push @ymlerrors, $next->file . " $@\n" if !$result or $@;
  }
}
is(scalar @errors, 0, "finder traversed alphabetically") or diag @errors;
is(scalar @ymlerrors, 0, "all yml parsed") or diag @ymlerrors;

sub find_ok {
  my ($arg, $expect, $label) = @_;
  my $finder = CPAN::Distroprefs->find(
    './distroprefs', \%ext,
  );

  isa_ok($finder, 'CPAN::Distroprefs::Iterator');

  my %arg = (
    env => \%ENV,
    perl => $^X,
    perlconfig => \%Config::Config,
    module => [],
    %$arg,
  );

  my $found;
  while (my $result = $finder->next) {
    next unless $result->is_success;
    for my $pref (@{ $result->prefs }) {
      if ($pref->matches(\%arg)) {
        $found = {
          prefs => $pref->data,
          prefs_file => $result->abs,
        };
      }
    }
  }
  is_deeply(
    $found,
    $expect,
    $label,
  );
}

find_ok(
  {
    distribution => 'HDP/Perl-Version-1',
  },
  {
    prefs => $LoadFile->('distroprefs/HDP.Perl-Version.yml'),
    prefs_file => File::Spec->catfile(qw/distroprefs HDP.Perl-Version.yml/),
  },
  'match .yml',
);

%ext = (
  dd  => 'Data::Dumper',
);
find_ok(
  {
    distribution => 'INGY/YAML-0.66',
  },
  {
    prefs => do './distroprefs/INGY.YAML.dd',
    prefs_file => File::Spec->catfile(qw/distroprefs INGY.YAML.dd/),
  },
  'match .dd',
) if 0;

# Local Variables:
# mode: cperl
# cperl-indent-level: 2
# End:
