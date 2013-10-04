#!/usr/bin/perl
use File::Basename;
use File::Path;
use FindBin qw($Bin);
use FindBin qw($Bin);
use lib "$Bin/../lib";
require "$Bin/disp_vhdl_data.pl";
require "$Bin/disp_data.pl";
use Data::Dumper;
use Storable qw(dclone);

$RE_comment_Cpp =                q{(?:\/\*(?:(?!\*\/)[\s\S])*\*\/|\/\/[^\n]*\n)};
$RE_string =                     qr{"((?:\\.|[^\\"])*)"};
$RE_string_one =                 qr{'((?:\\.|[^\\'])*)'}; #"
$id =                            qr{(?:[a-zA-Z_][a-zA-Z_0-9]*)};
$RE_balanced_squarebrackets =    qr'(?:[\[]((?:(?>[^\[\]]+)|(??{$RE_balanced_squarebrackets}))*)[\]])'s;
$RE_balanced_smothbrackets =     qr'(?:[\(]((?:(?>[^\(\)]+)|(??{$RE_balanced_smothbrackets}))*)[\)])'s;

$RE_b  = qr'(?:[\(]((?:(?>[^\(\)]+)|(??{$RE_b}))*)[\)])'s;

$RE_if = qr'(?:(?:if)((?:(?>(?:(?!\b(?:end\s+)?if\b).)+)|(??{$RE_if}))*)(?:end\s+if))'s;
$RE_d  = qr"(?:\b((?:Disp[a-zA-Z0-9_]*))\s*($RE_b)\s*;?)";

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
sub peel     { my ($m) = @_; $m =~ s/^\s*\(//; $m =~ s/\)\s*$//; return $m; }
sub pre      { my ($m,$pre,$c) = @_; my $l = $pre.$c; $ln += ($l =~ tr/\n//); return (substr($m,length($pre.$c)),$pre,$c); }
sub dbg      { my $m = substr($_[0],0,64); $m =~ s/\n/\\n/g; return "(ln:$ln) ".'"'.$m.'"'; }
sub rmspace  { my $m = $_[0]; $m =~ s/^[;\s]+//; $m =~ s/\r\n/\n/g; return $m; }
sub delspace { my $m = $_[0]; $m =~ s/^[\s]+//; $m =~ s/[\s]+$//; return $m; }
require "$Bin/disp_typ.pl";
parse_typ($typ);

$vhdl = readfile ("$Bin/disp_vhdl_template.adb");

sub bracket {
  my ($vhdl) = @_;
  my $open = 1, $l = "";;
  my $c = substr($vhdl,0,1);
  die ("No brachet open at:".dbg($vhdl)) if ($c ne "(");
  {
    $l .= $c; $vhdl = substr($vhdl,1);
    while (length($vhdl)) {
      $c = substr($vhdl,0,1);
      if ($c eq ")") {
        $l .= $c; $vhdl = substr($vhdl,1);
        if ((--$open) <= 0) {
          last;
        }
      } elsif ($c eq "(") {
        $l .= $c; $vhdl = substr($vhdl,1);
        $open++
      } elsif ($c eq "\"") {
        ($vhdl =~ /^($RE_string)/s) or die("Cannot scan string \"$c\":".dbg($vhdl));
        $l .= $&; $vhdl = substr($vhdl,length($&));
      } elsif ((!($l=~ /$id$/)) && ($c eq "'")) {
        ($vhdl =~ /^($RE_string_one)/s) or die("Cannot scan char \"$c\":".dbg($vhdl));
        $l .= $&; $vhdl = substr($vhdl,length($&));
      } else {
        $l .= $c;
        $vhdl = substr($vhdl,1);
      }
    }
  }
  return ($vhdl, $l);
}

sub eatline {
    my ($vhdl,$hint) = @_;
    my $l = "", $c = "", $last = "";
    while (length($vhdl) && 
           ((($c = substr($vhdl,0,1)) ne "\n") ||
            length($l) < length($hint))) {
        if ($c eq "\"" ) {
            ($vhdl =~ /^($RE_string)/s) or die("Cannot scan string \"$c\":".dbg($vhdl));
            #die("\nscan: \"$c\":".dbg($vhdl));
            $l .= $&;
            $vhdl = substr($vhdl,length($&));
        } elsif ((!($l=~ /$id$/)) && ($c eq "'") ) {
            ($vhdl =~ /^($RE_string_one)/s) or die("Cannot scan char \"$c\":".dbg($vhdl));
            #print($vhdl);
            #die("\nscan: \"$c\":".dbg($vhdl));
            $l .= $&;
            $vhdl = substr($vhdl,length($&));
        } elsif ($c eq "(") {
          my $_l = "";
          ($vhdl,$_l) = bracket($vhdl);
          $l .= $_l;
        } else {
            $l .= $c;
            $vhdl = substr($vhdl,1);
        }
    }
    if ($c eq "\n") {
        $vhdl = substr($vhdl,1);
        $l .= $c;
    }
    return ($vhdl,$l);
}

my @l = ();
my $s = {'n'=>'top','l'=>[],'childs'=>[],'typ'=>'root'};
my @state = ($s); my $ls;
my $root = $s;
my %procs = (); my @procs = ();

while (length($vhdl)) {
    my $state = $$s{'s'}, $n = $$s{'n'}; $ls=$$s{'childs'};
    #print(":".dbg($vhdl)."\n");
    if ($vhdl =~ /^\s*--/) {
        ($vhdl,$l) = eatline($vhdl);
        push(@{$ls},{'typ'=>'comment','o'=>$l});
    } elsif ($vhdl =~ /^\s*\n/) {
        ($vhdl,$l) = eatline($vhdl);
        push(@{$ls},{'typ'=>'space','o'=>$l});
    } elsif ($vhdl =~ /^\s*package\s+body\s+($id)/) {          ### package body ###
        ($vhdl,$l) = eatline($vhdl);
        push(@state,$s); $ls=$$s{'childs'}; push(@{$ls},$s={'s'=>'package_body','n'=>$1,'l'=>[],'childs'=>[],'typ'=>'package','o'=>$l});
    } elsif ($vhdl =~ /^\s*procedure\s+$id\s*$RE_b\s*;/s) {    ### procedure ###
        ($vhdl,$l) = eatline($vhdl,$&);
        push(@{$ls},{'typ'=>'procedure_declare','o'=>$l});
    } elsif ($vhdl =~ /^\s*procedure\s+($id)\s*$RE_b\s*is/s) { ### procedure ###
        ($vhdl,$l) = eatline($vhdl,$&);
        push(@state,$s); $ls=$$s{'childs'}; push(@{$ls},$s={'s'=>'procedure_decl','n'=>$1,'l'=>[],'childs'=>[],'typ'=>'procedure','o'=>$l});
        $procs{$1} = $s; push(@procs, $s);
    } elsif ($vhdl =~ /^\s*function\s+($id)\s*$RE_b\s*return\s+$id\s+is/s) { ### function ###
        ($vhdl,$l) = eatline($vhdl,$&);
        push(@state,$s); $ls=$$s{'childs'}; push(@{$ls},$s={'s'=>'function_decl','n'=>$1,'l'=>[],'childs'=>[],'typ'=>'function','o'=>$l});
    } elsif ($vhdl =~ /^\s*begin\b/s) {            ### begin ###
        ($vhdl,$l) = eatline($vhdl);
        die("If stack out of sync, expecting procedure_decl|declare_decl|function_decl, got: $state\n") if 
            !($state eq 'procedure_decl' || $state eq 'declare_decl' || $state eq 'function_decl');
        if ($state eq 'procedure_decl') {
            $$s{'s'} = 'procedure_body';
            $$s{'decl'} = $$s{'childs'};
            $$s{'childs'} = ($ls = []);
        } elsif ($state eq 'declare_decl') {
            $$s{'s'} = 'declare_body';
            $$s{'decl'} = $$s{'childs'};
            $$s{'childs'} = ($ls = []);
        } elsif ($state eq 'function_decl') {
            $$s{'s'} = 'function_body';
            $$s{'decl'} = $$s{'childs'};
            $$s{'childs'} = ($ls = []);
        }
        $$s{'close_decl'} = $l;

    } elsif ($vhdl =~ /^\s*declare\b/s) {          ### declare ###
        ($vhdl,$l) = eatline($vhdl,$&);
        push(@state,$s); $ls=$$s{'childs'}; push(@{$ls},$s={'s'=>'declare_decl','n'=>$1,'l'=>[],'childs'=>[],'typ'=>'declare','o'=>$l});

    } elsif ($vhdl =~ /^\s*if[^\n]+then\b/s) {     ### if then ###
        ($vhdl,$l) = eatline($vhdl);
        push(@state,$s); $ls=$$s{'childs'}; push(@{$ls},$s={'s'=>'if','n'=>$1,'l'=>[],'childs'=>[],'typ'=>'if','o'=>$l, 'true' => []});
    } elsif ($vhdl =~ /^\s*if\b/s) {               ### if ###
        ($vhdl,$l) = eatline($vhdl);
        push(@state,$s); $ls=$$s{'childs'}; push(@{$ls},$s={'s'=>'if_clause','n'=>$1,'l'=>[],'childs'=>[],'typ'=>'if','o'=>$l});
        
    } elsif ($vhdl =~ /^\s*end\s+if\b/s) {         ### end if ###
        ($vhdl,$l) = eatline($vhdl);
        die("If stack out of sync, expecting if|else, got: $state at \"$l\"\n") if 
            !($state eq 'if' || $state eq 'else');
        if ($state eq 'if') {
            push(@{$$s{'true'}},[ $$s{'o'}, $$s{'childs'}]);
        } elsif ($state eq 'else') {
            push(@{$$s{'false'}},[ $$s{'o'}, $$s{'childs'}]);
        }
        $$s{'childs'} = [];
        $$s{'close'} = $l;
        $s = pop(@state);$ls=$state[$#state]{'childs'}; 
    } 
    
      elsif ($vhdl =~ /^\s*and\s+then\b/s) {       ### and then ###
        ($vhdl,$l) = eatline($vhdl);
        die("If stack out of sync, expecting if_clause, got: $state\n") if 
            !($state eq 'if_clause');
        $$s{'o'} .= $l;

    } elsif ($vhdl =~ /^\s*then\b/s) {             ### then ###
        ($vhdl,$l) = eatline($vhdl);
        
        die("If stack out of sync, expecting if_clause, got: $state\n") if 
            !($state eq 'if_clause');
        $$s{'s'} = 'if'; 
        $$s{'o'} .= $l;

    } elsif ($vhdl =~ /^\s*or\s+else\b/s) {        ### or else ###
        ($vhdl,$l) = eatline($vhdl);
        die("If stack out of sync, expecting if_clause, got: $state\n") if 
            !($state eq 'if_clause');
        if ($l =~ /\bthen\s*$/) {
            $$s{'s'} = 'if'; 
        }
        $$s{'o'} .= $l;
        
    } elsif ($vhdl =~ /^\s*else\b/s) {             ### else ###
        ($vhdl,$l) = eatline($vhdl);
        die("If stack out of sync, expecting if, got: $state at \"$l\"\n") if 
            !($state eq 'if');
        $$s{'s'} = 'else'; 
        push(@{$$s{'true'}},[ $$s{'o'}, $$s{'childs'}]);
        $$s{'o'} = $l;
        $$s{'childs'} = ($ls = []);
   } 
    
      elsif ($vhdl =~ /^\s*end\s+loop\b/s) {       ### end loop ###
        ($vhdl,$l) = eatline($vhdl);
        die("If stack out of sync, expecting case, got: $state\n") if 
            !($state eq 'loop');
        $$s{'close'} = $l;
        $s = pop(@state); $ls=$state[$#state]{'childs'}; 
        
    } elsif ($vhdl =~ /^\s*end\s+case\b/s) {       ### end case ###
        ($vhdl,$l) = eatline($vhdl);
        die("If stack out of sync, expecting case, got: $state\n") if 
            !($state eq 'case' || $state eq 'when');
        $s = pop(@state) if ($state eq 'when');
        $ls=$$s{'childs'}; 
        $state = $$s{'s'};
        #print(Dumper($ls));
        die("If stack out of sync, expecting case, got: $state\n") if 
            !($state eq 'case');
        $$s{'close'} = $l;
        $s = pop(@state); $ls=$$s{'childs'};
    } elsif ($vhdl =~ /^\s*end\s+($id)\s*;/s) {    ### end id ###
        ($vhdl,$l) = eatline($vhdl);
        if (($n = $$s{'n'}) ne $1) {
            die("State stack out of sync. Expect $n($state) got :$l\n");
        }
        $$s{'close'} = $l;
        $s = pop(@state); $ls=$$s{'childs'};
        
    } elsif ($vhdl =~ /^\s*end\s*;/s) {            ### end ###
        ($vhdl,$l) = eatline($vhdl);
        die("If stack out of sync, expecting declare_body, got: $state\n") if 
            !($state eq 'declare_body');
        $$s{'close'} = $l;
        $s = pop(@state); $ls=$$s{'childs'};
        
        
    } 
      elsif ($vhdl =~ /^\s*for\b/s) {              ### for ###
        ($vhdl,$l) = eatline($vhdl);
        push(@state,$s); $ls=$$s{'childs'}; push(@{$ls},$s={'s'=>'loop','l'=>[],'childs'=>[],'typ'=>'for','o'=>$l});
    } elsif ($vhdl =~ /^\s*loop\b/s) {             ### loop ###
        ($vhdl,$l) = eatline($vhdl);
        push(@state,$s); $ls=$$s{'childs'}; push(@{$ls},$s={'s'=>'loop','l'=>[],'childs'=>[],'typ'=>'loop','o'=>$l});
    } elsif ($vhdl =~ /^\s*while\b/s) {            ### while ###
        ($vhdl,$l) = eatline($vhdl);
        push(@state,$s); $ls=$$s{'childs'}; push(@{$ls},$s={'s'=>'loop','l'=>[],'childs'=>[],'typ'=>'while','o'=>$l});
    } 

      elsif ($vhdl =~ /^\s*exit\s+when\b/s) {      ### exit when ###
        ($vhdl,$l) = eatline($vhdl);
        push(@{$ls},{'typ'=>'exit','o'=>$l});
    } elsif ($vhdl =~ /^\s*elsif\b/s) {            ### elsif ###
        ($vhdl,$l) = eatline($vhdl);
        die("If stack out of sync, expecting if, got: $state at \"$l\"\n") if 
            !($state eq 'if');
        push(@{$$s{'true'}},[ $$s{'o'}, $$s{'childs'}]);
        $$s{'o'} = $l;
        $$s{'childs'} = ($ls = []);

    } elsif ($vhdl =~ /^\s*return\b/s) {           ### return ###
        ($vhdl,$l) = eatline($vhdl);
        push(@{$ls},{'typ'=>'return','o'=>$l});
    } elsif ($vhdl =~ /^\s*use\s+(?:$id|\.)+\s*;/s) { ### use ###
        ($vhdl,$l) = eatline($vhdl);
        push(@{$ls},{'typ'=>'use','o'=>$l});
    } elsif ($vhdl =~ /^\s*with\s+(?:$id|\.)+\s*;/s) { ### with ###
        ($vhdl,$l) = eatline($vhdl);
        push(@{$ls},{'typ'=>'with','o'=>$l});
    } 
      elsif ($vhdl =~ /^\s*case\s+$id(?:\s*$RE_b)?\s+is/s) { ### case ###
        ($vhdl,$l) = eatline($vhdl);
        push(@state,$s); $ls=$$s{'childs'}; push(@{$ls},$s={'s'=>'case','l'=>[],'childs'=>[],'typ'=>'case','o'=>$l});
    } elsif ($vhdl =~ /^\s*when\s+($id)\s+/s) {              ### when ###
        ($vhdl,$l) = eatline($vhdl);
        die("If stack out of sync, expecting case,when, got: $state at \"$l\"\n") if
            !($state eq 'case' | $state eq 'when');
        $s = pop (@state) if ($state eq 'when');
        die("If stack out of sync, expecting case, got: $state at \"$l\"\n") if
            !($$s{'s'} eq 'case' );
        push(@state,$s); $ls=$$s{'childs'}; push(@{$ls},$s={'s'=>'when_case','c'=>[$1],'l'=>[],'childs'=>[],'typ'=>'when','o'=>$l});
        if ($l =~ /=>/) {
            $$s{'s'} = 'when';
        }
    } elsif ($vhdl =~ /^\s*\|\s+($id)/s) {                   ### when continue ###
        ($vhdl,$l) = eatline($vhdl);
        die("If stack out of sync, expecting when_case, got: $state at \"$l\"\n") if
            !($state eq 'when_case');
        push(@{$$s{'c'}},$1);
        if ($l =~ /=>/) {
            $$s{'s'} = 'when'; 
        }
        $$s{'o'} .= $l;

    } else {
        ($vhdl,$l) = eatline($vhdl);

        if ($state eq 'if_clause') {
            $$s{'o'} .= $l;
        } else {
            #print(":".$l);
            push(@{$ls},{'s'=>'line','o'=>$l,'typ'=>'line'});
        }
    }
    push(@l,$l);
}

sub toproc_ar {
    my ($a,$ctx) = @_;
    foreach my $l (@$a) {
      toproc($l,$ctx);
    }
    return $f;
}

sub extract_attr {
  my ($o) = @_;
  my %attr = (); 
  if ($o =~ /\-\-\s*([^\n]+)$/m ) {
    my $attr = $1;
    #print(":\"$attr\":"."\n");
    foreach my $a (split(",",$attr)) {
      if ($a =~ /($id)\s*:\s*(.*)/) {
        my ($n,$v) = ($1,$2);
        $attr{rmspace($n)} = rmspace($v);
      }
    }
  }
  return \%attr;
}

sub spof { my ($m) = @_; $m =~ /^(\s*)/; return $1;}

sub mergectx {
  my ($a,$b) = @_;
  my $h = dclone($a);
  foreach my $k (keys %$b) { $$h{$k} = $$b{$k};}
  return $h;
}

sub splitb {
  my ($_a) = @_;
  my %a = ();
  if ($_a =~ /$RE_balanced_squarebrackets/) {
    my $b = $1;
    foreach my $a (split("\\|",$b)) {
      if ($a =~ /($id)\s*=\s*(.*)/) {
        my ($n,$v) = ($1,$2);
        $v =~ s/[\r\n]//g;
        $a{$n} = delspace($v);
      }
    }
  }
  return \%a;
}

sub addFlags {
  my ($a, $sp, $ctx) = @_;
  my $r = "";
  if (defined($$a{'flags'})) {
    if ($$a{'flags'} =~ /$RE_balanced_squarebrackets/) {
      my $b = $1;
      foreach my $a (split("\\|",$b)) {
        if ($a =~ /($id)\s*=\s*(.*)/) {
          my ($n,$v) = ($1,$2);
          $r .= "${sp}AddAttr(".$$ctx{'e'}.",+\"$n\",+\"$v\");\n";
        }
      }
    }
  }
  return $r;
}

%mapn = ('Disp_Name_Of' => 'Str_Name_Of',
         'Disp_Name' => 'Str_Name',
         'Disp_Ident' => 'Str_Ident',
         'Disp_Identifier' => 'Str_Identifier',
         'Disp_Label' => 'Str_Label',
         'Disp_Signal_Kind' => 'Str_Signal_Kind',
         'Disp_Mode' => 'Str_Mode',
         'Disp_String_Literal' => 'Str_String_Literal',
         'Disp_Function_Name' => 'Str_Function_Name',
         'Disp_Int64' => 'Str_Int64',
         'Disp_Fp64' => 'Str_Fp64',
         'Disp_Entity_Kind' => 'Str_Entity_Kind' );

sub toproc_line {
  my ($id,$b,$_d,$o,$ctx,$typ) = @_;
  my $e = $$ctx{'e'}, $m = "";
  my $a = extract_attr($o);
  if (defined($$a{'reent'})) {
    $_d = "P,$e,";
  }
  if ($typ eq 'line' && 
      defined($mapn{delspace($id)}) &&
      defined($$a{'f'})) {
    my $f = $$a{'f'};
    $id = $mapn{delspace($id)};
    $_d = "";
    return "AddAttr($e,+\"$f\",$id($b))";
  } else {
    return "$id($_d$b)";
  }
}

sub toproc_sub {
  my ($o,$typ,$ctx) = @_; my $old = $o;
  my $sp = spof($o);  my $e = $$ctx{'e'}, $ec = "ec";
  my $a = extract_attr($o);
  my $n = defined($$a{'p'}) ? $$a{'p'} : "-";
  my $_d = ($typ eq 'procedure_declare') ?  "P,N:X;" : "$e,NewN($e,+\"$n\"),";
  $o =~ s/((?:Disp[a-zA-Z0-9_]*)\s*)$RE_b/toproc_line($1,$2,$_d,$o,$ctx,$typ)/egs;
  my $pre = "";

  if ($typ eq 'line') {
    if (defined($$a{'open'}) || defined($$a{'reopen'})) {
      my $n = splitb(defined($$a{'open'}) ? $$a{'open'} : $$a{'reopen'});
      my ($ec,$n) = ($$n{'v'},$$n{'n'});
      $e = $$ctx{'_e'}[0] if defined($$a{'reopen'});
      $pre = "${sp}$ec := NewN($e,+\"-\");\n${sp}SetTag($ec.all,+\"$n\");\n";
      if (defined($$a{'open'})) {
        push(@{$$ctx{'_e'}}, $$ctx{'e'});
        $$ctx{'e'} = $e = $ec;
      }
    } elsif (defined($$a{'reopen'})) {
      $$ctx{'e'} = shift(@{$$ctx{'_e'}});
    } elsif (defined($$a{'close'})) {
      my $v = $$ctx{'e'};
      $e = $$ctx{'e'} = shift(@{$$ctx{'_e'}});
    } 
    
    my $f = $$a{'f'}; $f =~ s/\r//g;
    if ($o =~ /^(\s*)(?:Put|Put_Line)\s*\(/  ) {
      my $b = substr($o,length($&)-1), $l, $sp = $1;
      ($b,$l) = bracket($b);
      if (defined($$a{'f'})) {
        $l =~ s/' '\s*\&//;
        $l =~ s/\&\s*' '//;
        $l =~ s/\s+"\)$/")/; # remove last whitespace in Put(_Line)
        $o = "${sp}AddAttr($e,+\"$f\",+$l);\n";
      } elsif (defined($$a{'nop'}) ||
               $l =~ /^\(\s*$RE_string\s*\)/ ||
               $l =~ /^\(\s*$RE_string_one\s*\)/)  {
        $o = "${sp}null;--$o";
      }
    } elsif ($o =~ /^(\s*)(?:New_Line)\s*/  ) {
      $o = "${sp}null;--$o";
    } elsif ($o =~ /^(\s*)(?:Set_Col)\s*/  ) {
      $o = "${sp}null;--$o";
    } elsif (defined($$a{'s'})) { 
      my $n = splitb( $$a{'s'} );
      my @k = keys(%$n);
      my ($ec,$n) = ($k[0], $$n{$k[0]});
      $o = "${sp}AddAttr($e,+\"$ec\",+\"$n\");\n$o\n";
    }
    $o = $pre.$o;
  } elsif ($typ eq 'exit') {
    my $epre = $$ctx{'_e'}[0];
    if (defined($$a{'exitchain'})) {
      my $n = $$a{'exitchain'};
      if ($o =~ /^\s*exit\s+when\s+(.*);/) {
        $o = "${sp}if $1 then\n${sp}   RemFrom(${epre},$e);\n${sp}end if;\n$o";
      }
    }
  }
  return $o;
}

sub toproc {
    my ($d,$ctx) = @_;
    my $typ = $$d{'typ'};
    my $f = "";
    if ($typ eq 'root') {
        $f .= toproc_ar($$d{'childs'},$ctx);
    } elsif ($typ eq 'comment') {
       $$d{'o'} = toproc_sub($$d{'o'},$typ,$ctx);
    } elsif ($typ eq 'space') {
       $$d{'o'} = toproc_sub($$d{'o'},$typ,$ctx);
    } elsif ($typ eq 'package') {
       $$d{'o'} = toproc_sub($$d{'o'},$typ,$ctx);
        $f .= toproc_ar($$d{'childs'},$ctx);
       $$d{'close'} = toproc_sub($$d{'close'},$typ,$ctx);
    } elsif ($typ eq 'procedure' || $typ eq 'function') {
       $_ctx = mergectx($ctx, {'p',$d});
       $$d{'o'} = ($$d{'o'});
       toproc_ar($$d{'decl'},$_ctx);
       $$d{'close_decl'} = toproc_sub($$d{'close_decl'},$typ,$ctx);
       toproc_ar($$d{'childs'},$_ctx);
       $$d{'close'} = toproc_sub($$d{'close'},$typ,$ctx);
    } elsif ($typ eq 'declare') {
       $$d{'o'} = toproc_sub($$d{'o'},$typ,$ctx);
       toproc_ar($$d{'decl'},$ctx);
       $$d{'close_decl'} = toproc_sub($$d{'close_decl'},$typ,$ctx);
       toproc_ar($$d{'childs'},$ctx);
       $$d{'close'} = toproc_sub($$d{'close'},$typ,$ctx);
    } elsif ($typ eq 'if') {
        foreach my $c (@{$$d{'true'}}) {
            my ($o,$l) = @$c;
            $$c[0] = toproc_sub($o,$typ,$ctx);
            toproc_ar($l,$ctx);
        }
        foreach my $c (@{$$d{'false'}}) {
            my ($o,$l) = @$c;
            $$c[0] = toproc_sub($o,$typ,$ctx);
            toproc_ar($l,$ctx);
        }
       $$d{'close'} = toproc_sub($$d{'close'},$typ,$ctx);
        
    } elsif ($typ eq 'case') {
       my $a = extract_attr($$d{'o'});
       if (defined($$a{'rename'})) {
         my ($v,$sp) = ($$a{'rename'},spof($$d{'o'}));
         $$d{'o'} = "${sp}ChangeTag(".$$ctx{'e'}.",$v);\n".addFlags($a,$sp,$ctx).$$d{'o'};
       }
       $$d{'o'} = toproc_sub($$d{'o'},$typ,$ctx);
       toproc_ar($$d{'childs'},$ctx);
       $$d{'close'} = toproc_sub($$d{'close'},$typ,$ctx);
        
    } elsif ($typ eq 'when') {
       $$d{'o'} = toproc_sub($$d{'o'},$typ,$ctx);
       toproc_ar($$d{'childs'},$ctx);
        
    } elsif ($typ eq 'procedure_declare') {
      my $a = extract_attr($$d{'o'});
      $$d{'o'} = toproc_sub($$d{'o'},$typ,$ctx);
    } elsif ($typ eq 'for' || $typ eq 'loop' || $typ eq 'while') {
       my $_ctx = $ctx, $o = "";
       my $a = extract_attr($$d{'o'});
       if (defined($$a{'chain'})) {
         my $sp = spof($$d{'o'}); $ctx = dclone($ctx); my $e = $$ctx{'e'};
         my $n = splitb( $$a{'chain'} );
         my ($ec,$n) = ($$n{'v'},$$n{'n'});
         $o = "${sp}   $ec := NewN($e,+\"-\");\n${sp}   SetTag($ec.all,+\"$n\");\n";
         push(@{$$ctx{'_e'}}, $$ctx{'e'});
         $$ctx{'e'} = $ec;
       }
      
       $$d{'o'} = toproc_sub($$d{'o'},$typ,$ctx). $o;
        $f .= toproc_ar($$d{'childs'},$ctx);
       $$d{'close'} = toproc_sub($$d{'close'},$typ,$ctx);
       $ctx = $_ctx;
    } elsif ($typ eq 'return' || $typ eq 'exit' || $typ eq 'use' || $typ eq 'with') {
       $$d{'o'} = toproc_sub($$d{'o'},$typ,$ctx);
    } elsif ($typ eq 'line') {
       $$d{'o'} = toproc_sub($$d{'o'},$typ,$ctx);
    } else {
        die("Cannot dump \"$typ\"\n");
    }
    return $f;
}


$process = 1;
$process_add = 1;
if ($process) {
  my $ctx = {'e'=>'N'};
  toproc($root,$ctx);
  
  if ($process_add) {
    for my $s (@procs) {
      my $o = $$s{'o'};
      if ($o =~ /^(\s*)(procedure\s+)($id\s*)$RE_b(.*)$/s) {
        my ($sp,$pre,$i,$b,$post) = ($1,$2,$3,$4,$5);
        if ($i =~ /^Disp/) {
          $$s{'o'} = $sp.$pre.$i."(P,N:X;".$b.")".$post;
          $i =~ /Disp_($id)/;
          my $in = $1, $iid = "";;
          my @b = split("\\s*;\\s*",$b);
          if ($b[0] =~ /([^:]+)\s*:\s*Iir\b/is) {
            my $_in = delspace($1);
            my @ids = split("\\s*,\\s*",$_in);
            $iid = "$sp   SetId(N,".$ids[0].");\n";
          }
          

          # unshift(@{$$s{'decl'}},{'typ'=>'line','o'=>"$sp   N: constant X := X(Create_Xml_Node_Pretty(P,+\"$1\"));\n"});
          
          
          unshift(@{$$s{'childs'}},{'typ'=>'line','o'=>"$iid$sp   SetTag(N.all,+\"".lc($in)."\");\n"});
          if ('Expression' ne $in && 'Range' ne $in && 
              'Element_Constraint' ne $in &&
              'Array_Element_Constraint' ne $in &&
              'Concurrent_Statement' ne $in) {
            unshift(@{$$s{'decl'}},{'typ'=>'line','o'=>"$sp   pragma Unreferenced (P);\n"});
          }
        }
      }
    }
  }
}

sub todump_ar {
    my ($a) = @_;
    my $f = "";
    foreach my $l (@$a) {
        $f .= todump($l);
    }
    return $f;
}

sub todump {
    my ($d) = @_;
    my $typ = $$d{'typ'};
    my $f = "";
    if ($typ eq 'root') {
        $f .= todump_ar($$d{'childs'});
    } elsif ($typ eq 'comment') {
        $f .= $$d{'o'};
    } elsif ($typ eq 'space') {
        $f .= $$d{'o'};
    } elsif ($typ eq 'package') {
        $f .= $$d{'o'};
        $f .= todump_ar($$d{'childs'});
        $f .= $$d{'close'};
    } elsif ($typ eq 'procedure' || $typ eq 'function') {
        $f .= $$d{'o'};
        $f .= todump_ar($$d{'decl'});
        $f .= $$d{'close_decl'};
        $f .= todump_ar($$d{'childs'});
        $f .= $$d{'close'};
    } elsif ($typ eq 'declare') {
        $f .= $$d{'o'};
        $f .= todump_ar($$d{'decl'});
        $f .= $$d{'close_decl'};
        $f .= todump_ar($$d{'childs'});
        $f .= $$d{'close'};
    } elsif ($typ eq 'if') {
        foreach my $c (@{$$d{'true'}}) {
            my ($o,$l) = @$c;
            $f .= $o;
            $f .= todump_ar($l);
        }
        foreach my $c (@{$$d{'false'}}) {
            my ($o,$l) = @$c;
            $f .= $o;
            $f .= todump_ar($l);
        }
        $f .= $$d{'close'};
        
    } elsif ($typ eq 'case') {
        $f .= $$d{'o'};
        $f .= todump_ar($$d{'childs'});
        $f .= $$d{'close'};
        
    } elsif ($typ eq 'when') {
        $f .= $$d{'o'};
        $f .= todump_ar($$d{'childs'});
        
    } elsif ($typ eq 'procedure_declare') {
        $f .= $$d{'o'};
    } elsif ($typ eq 'for' || $typ eq 'loop' || $typ eq 'while') {
        $f .= $$d{'o'};
        $f .= todump_ar($$d{'childs'});
        $f .= $$d{'close'};
    } elsif ($typ eq 'return' || $typ eq 'exit' || $typ eq 'use' || $typ eq 'with') {
        $f .= $$d{'o'};        
    } elsif ($typ eq 'line') {
        $f .= $$d{'o'};        
    } else {
        die("Cannot dump \"$typ\"\n");
    }
    return $f;
}

sub slit_len {
  my ($m) = @_; my $post = "";
  if (length($m) >= 78) {
    while (length($m) >= 78) {
      last if !($m =~ /([;])([^;]+)$/s || $m =~ /([,])([^,]+)$/s);
      $post = $1.$2.$post;
      $m = $`;
    }
    $m =~ s/[\s]+$//;
    if ($m =~ /^[\s]+/) {
      $post = $1.$post;
    }
    $m = $m."\n".$post;
  }
  return $m;
}

my $m = todump($root);

@_f = ();
@f = split("\n",$m);
foreach my $f (@f) {
    my $fl = slit_len($f);
    push(@_f,$fl);
}
$m = join("\n",@_f);

$m =~ s/\@typ\@/$typcase/;
$m =~ s/\r\n/\n/g;
$m =~ s/\r//g;

writefile("disp_xml_vhdl.adb",$m);


# Local Variables:
# c-basic-offset:4
# indent-tabs-mode:nil
# End:
