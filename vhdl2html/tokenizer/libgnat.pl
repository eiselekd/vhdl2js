#!/bin/perl

while (<>) {
  $m .= $_;
}

#print $m;
if ($m =~ /Object Search Path:\n/m) {
  my $r = $';
  my @r = split("\n",$r );
  while ($l = shift @r) {
    next if ($l =~ /<Current_Directory>/);
    $l =~ s/^\s*//;
    if (-f "$l/libgnat.a") {
      print $l; exit 0;
    }
  }
}
