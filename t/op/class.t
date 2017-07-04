#!./perl
# mpb -Dx t/op/class.t 2>&1 | grep -A1 Foo::
BEGIN {
    #chdir 't' if -d 't';
    #require './test.pl';
}
local($\, $", $,) = (undef, ' ', '');
print "1..10\n";
my $test = 1;

class Foo {
  #has $a = 0; # no has -> %FIELDS syntax yet
  my $a = 0;
  method a($v?)       { defined $v ? $a = $v : $a }
  method new          { bless [], 'Foo' }

  method meth1 {
    print "ok $test\n"; $test++; 
    # $self->a + 1
  }
  # quirks: just multi, not perl6-style multi method yet
  multi mul1 ($self, Int $a) :method {
    print "ok $test\n"; $test++;
    $self->a * $a
  }
  # no multi decl and dispatch yet
  #multi method mul1 (Int $a) { print "ok $test\n"; $test++; $self->a * $a }
  #multi method mul1 (Num $a) { $self->a * $a; print "ok $test\n"; $test++ }
  #multi method mul1 (Str $a) { $self->a . $a; print "ok $test\n"; $test++ }

  sub sub1 ($b)              { print "ok $test\n"; $test++; Foo->a - $b }
}

my $c = new Foo;
$c->meth1;
$c->mul1(0);
Foo::sub1(1);
eval "Foo->sub1(1);";
print $@ =~ /Invalid method/ ? "" : "not ",
  "ok $test # class sub as method should error\n"; $test++;
eval "Foo::meth1('Foo');";
print $@ =~ /Invalid subroutine/ ? "" : "not ",
  "ok $test # class method as sub should error also\n"; $test++;

# allow class as methodname (B), deal with reserved names: method, class, multi
package Baz;
sub class { print "ok $test\n"; $test++ }
package main;
sub Bar::class { print "ok $test\n"; $test++ }
Bar::class();
Baz->class();
Bar->class();

class Baz1 is Foo {
  method new {}
}
print scalar @Baz1::ISA != 1 ? "not " : "", "ok ", $test++, "\n";
print $Baz1::ISA[0] ne "Foo" ? "not " : "", "ok ", $test++, "\n";
