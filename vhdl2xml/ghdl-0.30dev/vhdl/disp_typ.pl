$typcase = "";

sub case {
    my ($n,$str) = @_; my $pre,$c, $str0, $n0 = "", $v0 = "", $shared = 0;
    my @str = @{$str};
    
    print("                $n: ***** Process ".length(@str)."\n") if ($d);
    
    $typcase .= ("         when $n =>\n");
    if (scalar(@str) == 1 && ($str[0]{'typ'} eq 'Put_Line' || $str[0]{'typ'} eq 'Put')) {
    put:
      my $b = peel($str[0]{'b'});
      my @b = split("&",$b);
      if ($b =~ /^$RE_string/) {
        ($b,$pre,$c,$str0) = (pre($typ, $`, $&),$1);
        if (($n0 = $str0) =~ /^(.*):/) {
          $n0 = $1;
          ($str0) = pre($str0, $`, $&);
          $str0 = rmspace($str0);
          die ("String left: error: $str0") if (length($str0)) ;
          $v0 = $b[1];
        } elsif (($n0 = $str0) =~ /^(.*)'/) {
          $n0 = $1;
          $v0 = $b[1];
        }
	$n0 = lc(delspace($n0));
	$n0 =~ s/\s/_/g; $n0 =~ s/://g;
        $typcase .= ("            SetTag(E.all,+\"$n0\");\n");
        $typcase .= ("            AddAttr(E,+\"val\",+$v0);\n") if (length($v0));
      } else {
        die ("Cannot find string") if (scalar(@b) != 1);
        $v0 = $b[0];
	#$v0 =~ s/\s/_/g;
        $typcase .= ("            SetTag(E.all,+$v0);\n");
        #$typcase .= ("            val := +$v0 ;\n") if (length($v0));
      }
    } elsif (scalar(@str) == 2 && $str[0]{'typ'} eq 'Put') {
      my $b = peel($str[0]{'b'});
      if ($b =~ /^$RE_string/) {
        $n0 = $1;
      }
      $n0 = lc(delspace($n0));
      $n0 =~ s/\s/_/g; $n0 =~ s/://g;
      $typcase .= ("            SetTag(E.all, +\"$n0\");\n");
      $typcase .= ("            AddAttr(E,+\"val\",+$v0);\n") if (length($v0));
    } elsif (scalar(@str) == 3 && $str[0]{'typ'} eq 'if') {
      $shared = shift(@str);
      $shared = 1;
      goto put;
    } elsif (scalar(@str) == 4 && $str[0]{'typ'} eq 'Put' && $str[1]{'typ'} eq 'Name_Table.Image') {
      goto put;
    } else {
      die("Unknown combination\nlen:".scalar(@str)." typ:".$str[0]{'typ'}."\n"); 
    }
}

sub parse_typ {
  my ($typ) = @_; my @disp, @str, $n = "";
  my ($state) = (0);
  while(length($typ = rmspace($typ))) {
    if ($state == 0) {
      if ($typ =~ /case[^\n]+is/) {
        ($typ,$pre,$c) = pre($typ, $`, $&);
        $state = 1;
      } else {
        die ("Expecting case in ".dbg($typ)."\n");
      }
    } elsif ($state == 1) {
      if ($typ =~ /^when\s+($id)\s*=>/) {
        $pren = $n;
        ($typ,$pre,$c,$n) = (pre($typ, $`, $&),$1);
        case($pren, \@str) if (length($pren));
        undef(@disp); undef(@str);
        print("Found type case $n\n") if ($d);
      } elsif ($typ =~ /^end\s+case/) {
        case($n, \@str);
        undef(@disp); undef(@str);
        print("Finished type parse\n") if ($d);
        last;
      } elsif ($typ =~ /^((?:Put|Put_Line))\s*($RE_balanced_smothbrackets)\s*;?/) {
        ($typ,$pre,$c,$p,$str) = (pre($typ, $`, $&),$1,$2);
        push(@str, {'typ'=>$p, 'l'=>$c, 'b'=>$str});
        print("                $n:$str (".scalar(@str).")\n") if ($d);
      } elsif (($typ=rmspace($typ)) =~ /^((?:Disp_Identifier|Disp_Ident))\s*($RE_balanced_smothbrackets)\s*;?/) {
        ($typ,$pre,$c,$p,$_disp) = (pre($typ, $`, $&),$1,$2);
        push(@str, {'typ'=>$p, 'l'=>$c, 'd'=>$_disp});
        print("                $n:$_disp (".scalar(@str).")\n") if ($d);
      } elsif (($typ=rmspace($typ)) =~ /^Disp_Decl_Ident\s*;?/) {
        ($typ,$pre,$c) = (pre($typ, $`, $&));
        push(@str, {'typ'=>'Disp_Decl_Ident', 'l'=>$c});
        print("                $n:Disp_Decl_Ident (".scalar(@str).")\n") if ($d);
      } elsif (($typ=rmspace($typ)) =~ /^Name_Table.Image\s*$RE_balanced_smothbrackets/ms) {
        ($typ,$pre,$c) = (pre($typ, $`, $&));
        push(@str, {'typ'=>'Name_Table.Image', 'l'=>$c});
        print("                $n:Name_Table.Image (".scalar(@str).")\n") if ($d);
      } elsif (($typ=rmspace($typ)) =~ /^$RE_if/s) {
        ($typ,$pre,$c) = (pre($typ, $`, $&));
        push(@str, {'typ'=>'if', 'l'=>$c});
        print("                $n:found if\n") if ($d);
      } else {
        die ("Cannot scan typ in ".dbg($typ)."\n");
      }
    } elsif ($state == 2) {
      
    }
  }
}

1;
