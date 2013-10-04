#!/usr/bin/perl
use File::Basename;
use File::Path;
use FindBin qw($Bin);
use FindBin qw($Bin);
use lib "$Bin/../lib";
require "$Bin/disp_data.pl";
use Data::Dumper;

$RE_comment_Cpp =                q{(?:\/\*(?:(?!\*\/)[\s\S])*\*\/|\/\/[^\n]*\n)};
$RE_string =                     qr{"((?:\\.|[^\\"])*)"};
$RE_string_one =                 qr{'((?:\\.|[^\\'])*)'}; #"
$id =                            qr{(?:[a-zA-Z_][a-zA-Z_0-9]*)};
$RE_balanced_squarebrackets =    qr'(?:[\[]((?:(?>[^\[\]]+)|(??{$RE_balanced_squarebrackets}))*)[\]])'s;
$RE_balanced_smothbrackets =     qr'(?:[\(]((?:(?>[^\(\)]+)|(??{$RE_balanced_smothbrackets}))*)[\)])'s;
$RE_if = qr'(?:(?:if)((?:(?>(?:(?!\b(?:end\s+)?if\b).)+)|(??{$RE_if}))*)(?:end\s+if))'s;
$RE_h  = qr"(?:\b(Header)\s*($RE_balanced_smothbrackets)\s*;?)";
$RE_d  = qr"(?:\b((?:Disp[a-zA-Z0-9_]*))\s*($RE_balanced_smothbrackets)\s*;?)";

sub filename {
    my ($str) = @_;
    $str =~ s/([<>])/sprintf("_%02X_",ord($1))/eg;
    return $str;
}

sub readfile {
    my ($in) = @_;
    usage(\*STDOUT) if (length($in) == 0) ;
    open IN, "$in" or die "Reading \"$in\":".$!;
    local $/ = undef;
    $m = <IN>;
    close IN;
    return $m;
}

sub writefile {
    my ($out,$re,$temp) = @_;
    $out = filename($out);
    my $dir = dirname($out);
    if ($dir) {
        mkpath($dir);
    }
    open OUT, ">$out" or die ($out.$!);
    print OUT ($re);
    close OUT;
}
$d = 0;
$ln = 1;
sub peel    { my ($m) = @_; $m =~ s/^\s*\(//; $m =~ s/\)\s*$//; return $m; }
sub pre     { my ($m,$pre,$c) = @_; my $l = $pre.$c; $ln += ($l =~ tr/\n//); return (substr($m,length($pre.$c)),$pre,$c); }
sub dbg     { my $m = substr($_[0],0,64); $m =~ s/\n/\\n/g; return "(ln:$ln) ".'"'.$m.'"'; }
sub rmspace { my $m = $_[0]; $m =~ s/^[;\s]+//; return $m; }
sub delspace { my $m = $_[0]; $m =~ s/^[\s]+//; $m =~ s/[\s]+$//; return $m; }

$typcase = "\n";

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
        $n0 = delspace($n0);
	$n0 =~ s/\s/_/g; $n0 =~ s/[,:]//g;
        $typcase .= ("            typ := +\"$n0\";\n");
        $typcase .= ("            val := +$v0 ;\n") if (length($v0));
      } else {
        die ("Cannot find string") if (scalar(@b) != 1);
        $v0 = $b[0];
        $typcase .= ("            typ := +$v0;\n");
        #$typcase .= ("            val := +$v0 ;\n") if (length($v0));
      }
    } elsif (scalar(@str) == 2 && $str[0]{'typ'} eq 'Put') {
      my $b = peel($str[0]{'b'});
      if ($b =~ /^$RE_string/) {
        $n0 = $1;
      }
      $n0 = delspace($n0);
      $n0 =~ s/\s/_/g; $n0 =~ s/[,:]//g;
      $typcase .= ("            typ := +\"$n0\";\n");
      $typcase .= ("            val :=  +$v0 ;\n") if (length($v0));
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

$state = 0;

#todo: enable again: 
#$typ = "";
$n = "";

sub parse_typ {
  my ($typ) = @_; my @disp, @str;
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
parse_typ($typ);
#print($typ);
#exit(1);

sub scanheaderline {
  my ($m) = @_;
  $m = rmspace($m);
  if (($m = rmspace($m)) =~ /^$RE_string/) {
    print ($1);
  }
  return undef;
}
sub scanheader {
  my ($_m, $n) = @_; my $d = 0, $multi = 0;
  my @b = split("&",$_m); my @r = ();
  for (my $i = 0; $i < scalar(@b); $i++) {
    $m = rmspace($b[$i]);
    if ((($m = rmspace($m)) =~ /^$RE_string/) &&
        ($l = $1) &&
        ($l =~ /^((?:flags: |staticness: ))?([^:]+)\s*:?\s*('?)$/)) {
      my ($n,$pre,$post) = ($2,$1,$3);
      $n =~ s/[,:]//g; $n = delspace($n); $n =~ s/\s/_/g;
      push(@r,{'n'=>$n,'b'=>[],'pre'=>$pre,'post'=>$post});
    } else {
      if ($#r < 0 || !defined($r[$#r]{'b'})) {
        if (($m =~ /^$RE_string/) &&
            ($l = $1) &&
            ($l =~ /^?([^:]+)\s*:\s*(.*)$/)) { # Header("guard: guarded");
          push(@r,{'n'=>$1,'b'=>["\"".$2."\""]});
        } else {
          die("First headerstring must be ident: $m\n");
        }
      }
      if (!($m eq "'''" || $m eq "\"\"\"\"") ) {
        push(@{$r[$#r]{'b'}},$m); 
      }
      $multi = 1;
    }
  }
  if($multi) {
  }
  return (\@r,$multi);
}

$out = 1;
sub merge {
  my ($str) = @_; my ($typ,$f);;
  my @r = ();
  
  for (my $i = 0; $i < scalar(@$str); $i++) {
    
    my @p = (); my $multi = 0;
    if ($$str[$i]{'typ'} eq 'Header') {
      my $p; ($p,$multi) = scanheader(peel($$str[$i]{'l'}));
      @p = @$p;      
    }
    if ($multi) {
      die ("Cannot find promary flag\n") if (!scalar(@p));
      foreach my $b (@p)  {
        push(@r,{'typ'=>'flags', 'n'=>$$b{'n'}, 'v'=>"(".join(" & ",@{$$b{'b'}}).")"});
      }
    } elsif ($$str[$i]{'typ'} eq 'null') {
      push(@r,$$str[$i]);
    } elsif ($$str[$i]{'typ'} eq 'if') {
      push(@r,$$str[$i]);
    } elsif ($$str[$i]{'typ'} eq 'return') {
      push(@r,$$str[$i]);
    } elsif ($$str[$i]{'typ'} eq 'psl') {
    } elsif ($$str[$i]{'typ'} eq 'Header' &&
             $$str[$i+1]{'typ'} eq 'decl') {
        push(@r,{'typ'=>'decl', 'n'=>$p[0]{'n'} });
      $i++;
    } elsif ($$str[$i]{'typ'} eq 'Disp_Label') {
      push(@r,$$str[$i]);
    } elsif (($i+1 < scalar(@$str)) &&
             ($$str[$i]{'typ'} eq 'Header') &&
             (($typ = $$str[$i+1]{'typ'}) =~ /^Disp/) 
            ) {
      
      my $di = $$str[$i+1];
      $f = $p[0]{'n'};
      $l = peel($$di{'l'});
      
      if ($typ eq 'Disp_Xml') {
        
        print("Disp_Xml            : ".$f.":$l\n") if ($d);
        push(@r,{'typ'=>'Disp_Xml', 'n'=>$f, 'v'=>$l});

      } elsif ($typ eq 'Disp_Xml_List') {

        print("Disp_Xml_List       : ".$f.":$l\n") if ($d);
        push(@r,{'typ'=>'Disp_Xml_List', 'n'=>$f, 'v'=>$l});
        
      } elsif ($typ eq 'Disp_Xml_Chain') {

        print("Disp_Xml_Chain      : ".$f.":$l\n") if ($d);
        push(@r,{'typ'=>'Disp_Xml_Chain', 'n'=>$f, 'v'=>$l});

      } elsif ($typ eq 'Disp_Xml_Flat') {
        
        print("Disp_Xml_Flat       : ".$f.":$l\n") if ($d);
        push(@r,{'typ'=>'Disp_Xml_Flat', 'n'=>$f, 'v'=>$l});
        
      } elsif ($typ eq 'Disp_Xml_List_Flat') {
        
        print("Disp_Xml_List_Flat  : ".$f.":$l\n") if ($d);
        push(@r,{'typ'=>'Disp_Xml_List_Flat', 'n'=>$f, 'v'=>$l});
        
      } elsif ($typ eq 'Disp_Xml_Flat_Chain') {
        
        print("Disp_Xml_Flat_Chain : ".$f.":$l\n") if ($d);
        push(@r,{'typ'=>'Disp_Xml_Flat_Chain', 'n'=>$f, 'v'=>$l});
        
      } elsif ($typ eq 'Disp_Flag') {
        
        print("Disp_Flag           : ".$f.":$l\n") if ($d);
        push(@r,{'typ'=>'flags', 'n'=>$f, 'v'=>"Disp_Flag($l)"});

        
      } elsif ($typ eq 'Disp_Expr_Staticness') {
        
        print("Disp_Expr_Staticness: ".$f.":$l\n") if ($d);
        push(@r,{'typ'=>'flags', 'n'=>$f, 'v'=>"Disp_Expr_Staticness($l)"});
        
      } elsif ($typ eq 'Disp_Staticness') {
        
        (($$str[$i+2]{'typ'}) =~ /^Disp_Expr_Staticness/) or die("Cannot parse Disp_Staticness\n");
        push(@r,{'typ'=>'flags', 'n'=>$f, 'v'=>"Disp_Staticness($l)"});
        my $l2 = peel($$str[$i+2]{'l'});
        push(@r,{'typ'=>'flags', 'n'=>'staticness-expr', 'v'=>"Disp_Expr_Staticness($l2)"});
        $i++;
        
      } elsif ($typ eq 'Disp_Choice_Staticness') {
        
        print("Disp_Choice_Staticness: ".$f.":$l\n") if ($d);
        push(@r,{'typ'=>'flags', 'n'=>$f, 'v'=>"Disp_Choice_Staticness($l)"});
        
      } elsif ($typ eq 'Disp_Name_Staticness') {
        
        print("Disp_Name_Staticness: ".$f.":$l\n") if ($d);
        push(@r,{'typ'=>'flags', 'n'=>$f, 'v'=>"Disp_Name_Staticness($l)"});
        
      } elsif ($typ eq 'Disp_Type_Staticness') {
        
        print("Disp_Type_Staticness: ".$f.":$l\n") if ($d);
        push(@r,{'typ'=>'flags', 'n'=>$f, 'v'=>"Disp_Type_Staticness($l)"});
        
      } elsif ($typ eq 'Disp_Lexical_Layout') {
        
        print("Disp_Lexical_Layout : ".$f.":$l\n") if ($d);
        push(@r,{'typ'=>'flags', 'n'=>$f, 'v'=>"Disp_Lexical_Layout($l)"});
        
      } elsif ($typ eq 'Disp_State') {
        
        print("Disp_State           : ".$f.":$l\n") if ($d);
        push(@r,{'typ'=>'flags', 'n'=>$f, 'v'=>"Disp_State($l)"});

      } elsif ($typ eq 'Disp_Purity_State') {
        
        print("Disp_Purity_State    : ".$f.":$l\n") if ($d);
        push(@r,{'typ'=>'flags', 'n'=>$f, 'v'=>"Disp_Purity_State($l)"});

      } elsif ($typ eq 'Disp_Type_Resolved_Flag') {
        
        print("Disp_Type_Resolved_Flag: ".$f.":$l\n") if ($d);
        push(@r,{'typ'=>'flags', 'n'=>$f, 'v'=>"Disp_Type_Resolved_Flag($l)"});
        
      } elsif ($typ eq 'Disp_Depth') {

        print("Disp_Depth           : ".$f.":$l\n") if ($d);
        push(@r,{'typ'=>'flags', 'n'=>$f, 'v'=>"Disp_Depth($l)"});

      } elsif ($typ eq 'Disp_Ident') {
        
        print("Disp_Ident           : ".$f.":$l\n") if ($d);
        push(@r,{'typ'=>'flags', 'n'=>$f, 'v'=>"Disp_Ident($l)"});

      } else {
        die("Unknown disp $typ");
      }
      $i++;

    } else {
      die("Error: cannot merge: ".$$str[$i]{'typ'}." $i of ".scalar(@$str)."\n".Dumper($str));
    } 
  }
  return \@r;
}

sub parse_disp_block {
  my ($disp,$n) = @_;
  my $state = 0; my @n = (); my @pren = (); my @str = (); my $pre,$c,$n, $str, $block;
  my @n = @$n;
  my @b = ();
  while(length($disp = rmspace($disp))) {
    if ($disp =~ /^null/) {
      ($disp,$pre,$c) = (pre($disp, $`, $&));
      push(@str, {'typ'=>'null'});
      print("                \"".join("|",@n)."\":null\n") if ($d);
    } elsif ($disp =~ /^return/) {
      ($disp,$pre,$c) = (pre($disp, $`, $&));
      push(@str, {'typ'=>'return'});
      print("                \"".join("|",@n)."\":null\n") if ($d);
    } elsif ($disp =~ /^$RE_h/) {
      ($disp,$pre,$c,$p,$str) = (pre($disp, $`, $&),$1,$2);
      push(@str, {'typ'=>$p, 'l'=>$str});
      print("                \"".join("|",@n)."\":found header\n") if ($d);
    } elsif ($disp =~ /^$RE_d/) {
      ($disp,$pre,$c,$p,$str) = (pre($disp, $`, $&),$1,$2);
      push(@str, {'typ'=>$p, 'l'=>$str});
      print("                \"".join("|",@n)."\":found disp\n") if ($d);
    } elsif (($disp=rmspace($disp)) =~ /^($RE_if)/s) {
      ($disp,$pre,$c,$block) = (pre($disp, $`, $&),$1);
      my $t,$f = undef,$_block=$block,$case; 
      $block =~ /^\s*if.*?(?<!and )then/s or die("No if statment at beginning of $block\n");
      $case = substr($block,0,length($`. $&));
      $block = substr($block,length($`. $&));
      ($block,$t) =  parse_disp_block($block,$n);
      if (($block = rmspace($block)) =~ /^else/) {
        ($block,$pre,$c) = (pre($block, $`, $&));
        ($block,$f) =  parse_disp_block($block,$n);
      }
      $block =~ s/\s*end\s*if// or die("No end if statment at end: $block\n");
      
      push(@str, {'typ'=>'if', 'l'=>$c, 't'=>$t, 'f'=>$f, 'case' =>$case});
      print("                \"".join("|",@n)."\":found if\n") if ($d);
      
    } elsif (($disp=rmspace($disp)) =~ /^declare.*begin.*end;/s) {
      ($disp,$pre,$c) = (pre($disp, $`, $&));
      push(@str, {'typ'=>'decl', 'l'=>$c});
      print("                \"".join("|",@n)."\":found $c\n") if ($d);
    } elsif (($disp=rmspace($disp)) =~ /^PSL.Dump_Tree.Dump_Tree\s*$RE_balanced_smothbrackets\s*;/s) {
      ($disp,$pre,$c) = (pre($disp, $`, $&));
      push(@str, {'typ'=>'psl', 'l'=>$c});
      print("                \"".join("|",@n)."\":found $c\n") if ($d);
    } else {
      last;
    }
  }
  my $a = merge(\@str);
  return ($disp,$a);
}

sub parse_disp {
  my ($disp) = @_;
  my $state = 0; my @n = (); my @pren = (); my @str = (); my $pre,$c,$n, $str;
  my @dec = ();
  while(length($disp = rmspace($disp))) {
    if ($state == 0) {
      if ($disp =~ /case[^\n]+is/) {
        ($disp,$pre,$c) = pre($disp, $`, $&);
        $state = 1;
      } else {
        die ("Expecting case in ".dbg($disp)."\n");
      }
    } elsif ($state == 1) {
      if ($disp =~ /^when\s+($id(?:\s*\|\s*$id)*)\s*=>/) {
        ($disp,$pre,$c,$n) = (pre($disp, $`, $&),$1);
        my @n = split('\s*\|\s*',$n);
        undef(@disp); undef(@str);
        print("Found type case \"".join("|",@n)."\"".dbg($n)."\n") if ($d);
        push(@dec,{'n'=>\@n});
      } elsif ($disp =~ /^end\s+case/) {
        undef(@disp); undef(@str);
        print("Finished type parse\n") if ($d);
        last;
      } else {
        my $b;
        ($disp,$b) = parse_disp_block($disp,\@n);
        $dec[$#dec]{'b'} = $b;
        #die ("Cannot scan in disp ".dbg($disp)."\n") if (scalar(@$b) <= 0);
      }
    } elsif ($state == 2) {
      
    }
  }
  return \@dec;
}

@dec = @{parse_disp($disp)};

sub tabs { my ($n) = @_; my $r = ""; for (my $i = 0; $i < $n; $i++) { $r = $r.'   '; } return $r; }
sub ntab { my ($n) = @_; $n =~ s/, Ntab//; return $n; }

sub out_block {
  my ($b,$t) = @_;
  my @b = @{$b}; my $f = "";
  foreach my $b (@b) {
    if ($$b{'typ'} eq 'if') {
      $f .= (ntab(tabs($t)."   ".rmspace($$b{'case'})."\n"));
      $f .=out_block($$b{'t'},$t+1);
      if ($$b{'f'}) {
        $f .= (ntab(tabs($t)."   else\n"));
        $f .=out_block($$b{'f'},$t+1);
      }
      $f .= (ntab(tabs($t)."   end if;\n"));
    } elsif ($$b{'typ'} eq 'return') {
      $f .=(ntab(tabs($t)."   return;\n"));
    } elsif ($$b{'typ'} eq 'null') {
      $f .=(ntab(tabs($t)."   null;\n"));
    } elsif ($$b{'typ'} eq 'flags') {
      my $pre = "+";
      $pre = "" if ($$b{'v'} =~ /^\s*Disp/);
      my $n = $$b{'n'}; $n =~ s/ /_/g;
      $f .=(ntab(tabs($t)."   flag(e,+\"".$n."\",$pre ".$$b{'v'}.");\n"));
    } elsif ($$b{'typ'} eq 'Disp_Label') {
      $f .=(ntab(tabs($t)."   ".$$b{'typ'}."(e,Tree);\n"));
    } elsif ($$b{'typ'} =~ /^Disp/) {
      my $pre = "";
      if ($$b{'typ'} =~ /^Disp_Xml_Flat\s*$/) {
        $pre = "child := ";
      }
      $f .=(ntab(tabs($t)."   $pre".$$b{'typ'}."(e,+\"".$$b{'n'}."\",".$$b{'v'}.");\n"));
    } elsif ($$b{'typ'} eq 'decl') {

        $f .= <<DEC;
            declare
               Base : constant Iir := Get_Base_Type (Tree);
               Fl : Boolean;
            begin
               if Base /= Null_Iir
                 and then Get_Kind (Base) = Iir_Kind_Array_Type_Definition
               then
                  Fl := Get_Type_Declarator (Base)
                    /= Get_Type_Declarator (Tree);
               else
                  Fl := False;
               end if;
               Disp_Xml (e,+"base", Base, Fl);
            end;
DEC
      #$f .=(ntab(tabs($t)."    ".$$b{'typ'}."(e,\"".$$b{'n'}."\",".$$b{'v'}.");\n"));
    } else {
        die("Error:".$$b{'typ'});
    }
  }
  return $f;
}

my $f = "";
foreach my $d (@dec) {
  my @n = @{$$d{'n'}};
  $f .= ("         when ".join("|\n           ",@n)." =>\n"); 
  $f .= out_block($$d{'b'},3);
  
}

@_f = ();
@f = split("\n",$f);
foreach my $f (@f) {
    my $fl = $f;
    if (length($f) > 60) {
        my @l = split(",",$f);
        my @fl = ();
        while(scalar(@l) && length(join(",",(@fl,$l[0]))) < 60) {
            push(@fl,shift(@l));
        }
        $fl = join(",", @fl);
        if (scalar(@l) > 0) {
            if (length($fl)) {
                $fl .= ",\n            ";
            }
            $fl .= join(",\n            ", @l);
        }
        #print($f."\n".$fl."\n");
    }
    push(@_f,$fl);
}
$f = join("\n",@_f);
$tmp = readfile("disp_xml_template.adb");
$tmp =~ s/\@typ\@/$typcase/;
$tmp =~ s/\@disp\@/$f/;
writefile("disp_xml.adb",$tmp);

# Local Variables:
# c-basic-offset:4
# indent-tabs-mode:nil
# End:
