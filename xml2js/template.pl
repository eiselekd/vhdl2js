use Data::Dumper;
use Getopt::Long;

# {* ... perl code *}  => copy as is
# [* ... perl subblock *}  => $out .= &{sub {... }}();
# {* ... perl forloop start *-}  ...  {-* ... forloop end  ... *} => transformed into a loop (real code yourself)

$::idre = $id = qr'(?:[a-zA-Z_][a-zA-Z_0-9]*)';
$RE_template_b_squarebrackets        =    qr'(?:[\[]((?:(?>[^\[\]]+)|(??{$RE_template_b_squarebrackets}))*)[\]])';
$RE_template_balanced_squarebrackets =    qr'(?:\[\*((?:(?>(?:(?:(?!\[\*)(?!\*\])[\s\S]))+)|(??{$RE_template_balanced_squarebrackets}))*)\*\])';
$RE_template_balanced_brackets       =    qr'(?:\{\*((?:(?>(?:(?:(?!\{\*)(?!\*\})[\s\S]))+)|(??{$RE_template_balanced_brackets}))*)\*\})';
$RE_template_balanced_brackets_inner =    qr'(?:\*-\}((?:(?>(?:(?:(?!\{-\*)(?!\*-\})[\s\S]))+)|(??{$RE_template_balanced_brackets_inner}))*)\{-\*)';
$RE_template_balanced_call           =    qr'(?:\{\(((?:(?>(?:(?:(?!\{\()(?!\)\})[\s\S]))+)|(??{$RE_template_balanced_call}))*)\)\})';
$RE_template_balanced_prop           =    qr'(?:\{\.((?:(?>(?:(?:(?!\{\.)(?!\.\})[\s\S]))+)|(??{$RE_template_balanced_prop}))*)\.\})';
$RE_template_ar                      =    qr'(?:\{@\s*([a-zA-Z_0-9]+)\s*,\s*([a-zA-Z_0-9,\"\'\s]+)\s*@\})';
$RE_template_si                      =    qr'(?:\{\(\s*([a-zA-Z_0-9]+)\s*,\s*([a-zA-Z_0-9,\"\'\s:\(\)\[\]\{\}]+)\s*\)\})';
$RE_template_se                      =    qr'(?:\{\(\s*([a-zA-Z_0-9]+)\s*\)\})';
$RE_string =                     qr{"((?:\\.|[^\\"])*)"};
$RE_string_one =                 qr{'((?:\\.|[^\\'])*)'}; #"

sub convert_template {
    my ($n,$a) = @_;
    my $c = "";
    while(length($a)) {
        #if ($a =~ /^$RE_template_balanced_call/s ) {
        #    my ($all,$b) = ($&,$1);
        #    print (STDERR "Found call '$all'\n") if ($::d);
        #    $a = substr($a,length($all));
        #    $c .= "\$out .= \$self->${b}(\@_);\n";
        #} els
        if ($a =~ /^$RE_template_balanced_prop/s ) {    # {. .} 
            my ($all,$b) = ($&,$1);
            print ($::LOG "Found prop '$all'\n") if ($::d);
            $a = substr($a,length($all));
            $c .= "\$out .= \$self->{${b}};\n";
        } elsif ($a =~ /^$RE_template_balanced_squarebrackets/s ) { # [( )] 
            my ($all,$b) = ($&,$1);
            print ($::LOG "Found balanced '$all'\n") if ($::d);
            $a = substr($a,length($all));
            $c .= "\$out .= &{sub { $b }}();\n";
        } elsif ($a =~ /^$RE_template_balanced_brackets/s ) {
            my ($all,$b) = ($&,$1);
            print ($::LOG "Found bracket '$all'\n") if ($::d);
            $a = substr($a,length($all));
            if ($b =~ /$RE_template_balanced_brackets_inner/) {
                my ($pre,$b2,$post) = ($`,$1,substr($b,length($`.$&)));
                $c .= "my \@_a = (); $pre";
                $c .= "push(\@_a,&{".convert_template('',$b2)."}(\@_));\n";
                $c .= $post;
                $c .= "\$out .= join_template(\$out,\@_a);\n";
dl.pl
                $a =~ s/^\s*\n//;
            } else {
                $c .= $b;
            }
        } elsif ($a =~ /^$RE_template_ar/) {   # {@ ar,fn @}
            my ($all,$ar,$fn) = ($&,$1,$2); my $sep = "\\n"; my $it;
            #print $::LOG $a."\n";
            $a = substr($a,length($all));
            if ($fn =~ /\s*([a-zA-Z_0-9]+)\s*,\s*(.*)/) {
                ($fn, $it) = ($1,$2);
                if ($it =~ /$RE_string/ || $it =~ /$RE_string_one/) {
                    $sep = $1;
                } else {
                    confess("Cannot scan $fn");
                }
            } else {
                print ($::LOG "Found ar '$all'\n") if ($::d);
            }
            $c .= "my \@_a = \$self->$ar(); \$out .=  (scalar(\@_a) ? join(\"$sep\", map { \$_->$fn(\@_) } \@_a) : \"undef\") ;\n";
        } elsif ($a =~ /^$RE_template_si/) { # {( obj,fn,... )}
            my ($all,$ar,$fn) = ($&,$1,$2); my $it;
            $a = substr($a,length($all));
            print ($::LOG "Found si '$all'\n") if ($::d);
            if ($fn =~ /\s*([a-zA-Z_0-9]+)\s*,\s*(.*)/) { # {( ar,fn , )}
                die("todo");
            } elsif ($fn =~ /\s*([a-zA-Z_0-9]+)\s*:\s*(.*)/) { # {( ar,fn : undef )}
                ($fn, $it) = ($1,$2);
                $c .= "\$out .= defined(\$self->{$ar}) ? \$self->{$ar}->$fn(\@_) : $it;\n";
            } else {
                $c .= "\$out .= \$self->{$ar}->$fn(\@_);\n";
            }
        } elsif ($a =~ /^$RE_template_se/) {  # {( fn )}
            my ($all,$fn) = ($&,$1);
            print ($::LOG "Found si '$all'\n") if ($::d);
            $a = substr($a,length($all));
            $c .= "\$out .= \$self->$fn(\@_);\n";
            
        } elsif ($a =~ /^.+?(?=\{\(|\{\.|\{\*|\[\*|\{\@|\{\(|$)/s)  {
            my ($all,$b) = ($&,$1);
            print ($::LOG "Found txt '$all'\n") if ($::d);
            $a = substr($a,length($all));
            $c .= "\$out .= \"$all\";\n";
        } else {
            die("Cant decode '$a'");
        }
    }
    return "sub $n { my (\$out,\$self) = ('',shift(\@_)); $c; return \$out; }";
}

sub join_template {
    my ($out) = @_;
    my $post = 0;
    $post = length($1) if ($out =~ /([^\n]*)$/);
    $pre = sprintf('%*s',$post,"");
    my $c = join("\n", map { $_=~ s/^\s*\n//; $_=~ s/\s*\n\s*$//; $_ } @a);
    $c .= "\n" if (scalar(@a));
    return $c;
}

################################################################################################
################################################################################################
################################################################################################
################################################################################################
################################################################################################
package Hdl::Template;
use Scalar::Util 'blessed'; 
use Data::Dumper; use Carp;

sub delspace { my ($m) = @_; $m =~ s/^\s+//s; $m; }
sub dbgstr   { my ($m,$l) = @_; $m =~ s/\n/\\n/g; return substr($m, 0, $l).(length($m)>$l?"...":""); }
sub ident    { my ($ctx) = @_; my $r = ""; for (my $i = 0; $i < $$ctx{'i'}; $i++) { $r .= " "; }; return $r; }
$RE_string =     qr{"((?:\\.|[^\\"])*)"};
$RE_string_one = qr{'((?:\\.|[^\\'])*)'}; #"

sub parse_token {
    my ($m,$c) = @_; $m = delspace($m); $ctx = {} if (!defined($ctx));
    my %ctx = %$ctx; my $post = 0, $tag = 0; my $dobless="";
    ($m = substr($m,length($&)),$ctx{'local'} = 1) if ($m =~ /^\s*\./);
    ($m = substr($m,length($&)),$ctx{'ar'} = 1) if ($m =~ /^\s*@/);
    ($m = substr($m,length($&)),$ctx{'sc'} = 1) if ($m =~ /^\s*\$/);
    if ($m =~ /^\.($::id)/) {
        $m = substr($m,length($&)); %ctx = ( %ctx, 'typ'=>'attr', 'id'=>$1 );      # .attr
        print $::LOG (ident($c)."Got Attr\n");
    } elsif ($m =~ /^([0-9]+)/ ) {
        $m = substr($m,length($&)); %ctx = ( %ctx, 'typ'=>'num', 'n'=>$1, 'id'=>$1 );# num
        print $::LOG (ident($c)."Got Num '$1'\n"); $dobless = "Id";
    } elsif ($m =~ /^$RE_string/ || $m =~ /^$RE_string_one/ ) {
        $m = substr($m,length($&)); %ctx = ( %ctx, 'typ'=>'str', 'n'=>$1, 'id'=>$1 );# num
        print $::LOG (ident($c)."Got Num '$1'\n"); $dobless = "Id";
    } elsif ($m =~ /^(\?:|;;|\|\||&&|==|\?|:|=|,)/) {
        $m = substr($m,length($&)); %ctx = ( %ctx, 'typ'=>'tok',  'tok'=>$1, 'id'=>$1 );;    # tokens
        print $::LOG (ident($c)."Got Tokens '$1'\n"); $dobless = "Id";
    } elsif ($ctx{'ar'} && $m =~ /^\#/) { 
        $m = substr($m,length($&)); %ctx = ( %ctx, 'typ'=>'arsz' );                # array size
        print $::LOG (ident($c)."Got Arraysize @#".($ctx{'local'}?"(.)":"")."\n");
    } elsif (($ctx{'local'} && $m =~ /^((?:\/$::id)+)/) || $m =~ /^\.((?:\/$::id)+)/) { 
        $m = substr($m,length($&)); %ctx = ( %ctx, 'typ'=> 'xpath', 'path'=>$& );  # xpath: ./...
        print $::LOG (ident($c)."Got XPath '$&'".($ctx{'local'}?"(.)":"").($ctx{'ar'}?"(@)":"").($ctx{'sc'}?"(\$)":"")."\n"); $post=1;
    } elsif ($m =~ /^($::id(?:::$::id)*)/) { 
        $m = substr($m,length($&)); %ctx = ( %ctx, 'typ'=> 'class', 'id' => $& );  # class: a::b
        $dobless = "Id";
        print $::LOG (ident($c)."Got Class '$&' ".($ctx{'local'}?"(.)":"").($ctx{'ar'}?"(@)":"").($ctx{'sc'}?"(\$)":"")."\n");
    } elsif ($m =~ /^@($::id)\[/) { 
        $m = substr($m,length($&)); %ctx = ( %ctx, 'typ'=> 'map', 'n' => $1 );     # map array: @c[<op>]
        print $::LOG (ident($c)."Got Maparray\n");
    } elsif ($m =~ /^@($::id)\[([0-9]+)\]/) { 
        $m = substr($m,length($&)); %ctx = ( %ctx, 'typ'=> 'idx', 'n' => $1 );     # index: @c[idx]
        print $::LOG (ident($c)."Got Index\n");
    } elsif ($m =~ /^(\{\{|\{|\(|\[)/) {    
        $m = substr($m,length($&));                                                # open bracket
        my $mat = $1, $op, $cl; my %m = ('{'=>'}','{{'=>'}}','['=>']','('=>')'); 
        $op = $mat; $cl = $m{$mat};
        my $o = 1, $l = "";
        while (length($m)) {
            if (substr($m,0,length($op)) eq $op) {
                $l .= $op; $m = substr($m,length($op));
                $o++;
            } elsif (substr($m,0,length($cl)) eq $cl) {
                $m = substr($m,length($cl));
                if (--$o == 0) {
                    last;
                }
                $l .= $cl; 
            } elsif ($m =~ /^\s*$RE_string/ || $m =~ /^\*$RE_string_one/) {
                $l .= $&; $m = substr($m,length($&));
            } else {
                $l .= substr($m,0,1);; $m = substr($m,1);
            }
        }
        %ctx = ( %ctx, 'typ'=> $mat, 'b' => $l );
        print $::LOG (ident($c)."Got Bracket '$op $cl':'".dbgstr($l,256)."'\n");
    } else {
        confess("Error: ".($ctx{'local'}?"(.)":"").($ctx{'ar'}?"(@)":"").($ctx{'sc'}?"(\$)":"")."'$m'\n");
    }
    if ($post || $ctx{'ar'}|| $ctx{'sc'}) {
        if ($m =~ /^\s*\[/) {
            ($m,$p) = parse_token($m,$c);
            $ctx{'post'} = $p;
        }
    }
    if ($tag || $ctx{'ar'}|| $ctx{'sc'}) {
        if ($m =~ /^\s*\.([a-zA-Z0-9_]+)/) {
            $m = substr($m,length($&));
            $ctx{'tag'} = $1;
        }
    }
    my $c = {%ctx};
    if (length($dobless)) {
        $c = bless($c,$dobless);
    }
    return (delspace($m), $c);
}

# ..=@./AggE[ do a map on ./AggE and create []
# ..=[  create []
# {{switch ()?: ...;; ... }}
# Class::E{_val=...,_n=...}

sub parse_trans_ent {
    my ($m,$c,$list) = @_; my ($t,$t1,$t2,$t3,$t4);my (@a,@a1,@a2,@a3,@a4); my ($b1,$ctr,$cfl);
    my $ctx; my $ctx1; my $ctx2; my $ctx3; my $ctx4; my $b2; my $b; my @r = ();
    while (length($m = delspace($m))) {
        ($m,$ctx) = parse_token($m,$c);
        if ($$ctx{'typ'} eq 'arsz' ) {
            ($m,$ctx2) = parse_trans_ent($m,{%$c,'i'=>($$c{'i'}+1)},0);
            $$ctx{'of'} = $ctx2;
            $$ctx2{'l'}[0]{'ar'} = 1 if (blessed($ctx2) eq 'Expr');
            $ctx = bless($ctx,'Arsz');
            push(@r,$ctx);
        } elsif ($$ctx{'typ'} eq 'xpath' && defined($$ctx{'post'}) && $$ctx{'ar'}) {
            confess("Expect bracket as post") if (!length($b1 = $$ctx{'post'}{'b'}));
            my $a;
            $$ctx{'map'} = $a = parse_trans_ent($$ctx{'post'}{'b'},{%$c,'i'=>($$c{'i'}+1)},1);
            return ($m,bless($ctx,'Arr::Xpath'));
        } elsif ($$ctx{'typ'} eq 'xpath' && defined($$ctx{'post'}) ) {
            $$ctx{'idx'} = parse_trans_ent($$ctx{'post'}{'b'},{%$c,'i'=>($$c{'i'}+1)},1);
            push(@r,$ctx);
        } elsif($$ctx{'typ'} eq 'class') {
            if ($$ctx{'ar'} && defined($$ctx{'post'})) {
                $$ctx{'map'} = parse_trans_ent($$ctx{'post'}{'b'},{%$c,'i'=>($$c{'i'}+1)},1);
            } elsif ($$ctx{'sc'} && defined($$ctx{'post'})) {
                $$ctx{'idx'} = parse_trans_ent($$ctx{'post'}{'b'},{%$c,'i'=>($$c{'i'}+1)},1);
            }
            if ($m =~ /^\s*\{/) {                               #obj-create: class{}
                #confess("Error: Expect classgen at start (".scalar(@r).")\n") if (scalar(@r));
                ($m,$ctx1) = parse_token($m,$c); my $b1 = $$ctx1{'b'};
                confess("Expect bracket: '$$ctx1{'typ'}'\n") if ($$ctx1{'typ'} ne '{');
                my @m = ();
                while (length($b1 = delspace($b1))) {
                    ($b1,$ctx2) = parse_token($b1,$c); confess("Expect id:") if (!length($$ctx2{'id'}));
                    ($b1,$ctx3) = parse_token($b1,$c); confess("Expect =:") if ($$ctx3{'tok'} ne "=");
                    #print ("----".$b1."\n");
                    ($b1,$ctx4) = parse_trans_ent($b1,{%$c,'i'=>($$c{'i'}+1)},2);
                    $b1 =~ s/^\s*,//;
                    #print (Dumper($ctx4));
                    push(@m, bless({'n'=>$ctx2, 'v'=>$ctx4},'Obj::Member'));
                }
                $$ctx{'m'}=[@m];
                #print( $::LOG "Return 'Obj'\n");
                push(@r,bless($ctx,'Obj'));
                #print (Dumper(@r));
                
                #return ($m,bless($ctx,'Obj'));
            } elsif ($m =~ /^\s*\(/) {                          #obj-new: class()
                confess("Error: Expect classgen at start (".scalar(@r).")\n") if (scalar(@r));
                ($m,$ctx1) = parse_token($m,$c); my $b1 = $$ctx1{'b'};
                confess("Expect bracket: '$$ctx1{'typ'}'\n") if ($$ctx1{'typ'} ne '(');
                ($b1,$ctx2) = parse_trans_ent($b1,{%$c,'i'=>($$c{'i'}+1)},3);
                $$ctx{'args'} = $ctx2;
                push(@r,bless($ctx,'New'));
                
                #return ($m,bless($ctx,'New'));
            } else {
                push(@r,$ctx);
            }
        } elsif($$ctx{'typ'} eq '(' && length($b1 = $$ctx{'b'}) && $m =~ s/^\s*\?(?!:)// ) { # ? .. : ...
            $$ctx{'cond'} = parse_trans_ent($b1,{%$c,'i'=>($$c{'i'}+1)},1);
            ($m,$ctr) = parse_trans_ent($m,{%$c,'i'=>($$c{'i'}+1)},2);
            ($m,$ctx2) = parse_token($m,$c); confess("Expect ':' : ") if ($$ctx2{'tok'} != ':');
            ($m,$cfl) = parse_trans_ent($m,{%$c,'i'=>($$c{'i'}+1)},2);
            print($::LOG "Return 'Ifthenelse'\n");
            $$ctx{'true'} = $ctr;
            $$ctx{'false'} = $cfl;
            return ($m,bless($ctx,'Ifthenelse'));
        } elsif($$ctx{'typ'} eq '{{' && length($b = $$ctx{'b'})) { # {{case  ?: ... }}
            if ($b =~ s/^\s*case//) {
                my @r1 = ();
                while (length($b = delspace($b))) {
                    print($::LOG " Cases ".dbgstr($b,64)."\n");
                    ($b,$ctx1) = parse_token($b,{%$c,'i'=>($$c{'i'}+2)},0); my @r = ();
                    confess("Expect '(' : ".$$ctx1{'tok'}) if ($$ctx1{'typ'} ne '(');
                    $b1 = $$ctx1{'b'};
                    ($b,$ctx2) = parse_token($b,{%$c,'i'=>($$c{'i'}+2)}); confess("Expect ':' : ") if ($$ctx2{'tok'} != '?:');
                    ($b2,$ctx1) = parse_trans_ent($$ctx1{'b'},{%$c,'i'=>($$c{'i'}+2)},1);
                    
                    while (length($b = delspace($b)) && !($b =~ s/^\s*;;//s)) {
                        ($b,$ctx3) = parse_trans_ent($b,{%$c,'i'=>($$c{'i'}+2)},2);
                        push(@r,$ctx3);
                        $b =~ s/^\s*;(?!;)//s;
                    }
                    push(@r1, bless({'cond'=>$ctx1, 'stmts'=>[@r]},'Case'));
                }
                $$ctx{'cases'} = [@r1];
                return ($m,bless($ctx,'Cases'));
            } else {
                confess("unknown '{{'");
            }
        } else {
            push(@r,$ctx);
        }
        
        if (($list == 3)) {
        } elsif (($list == 1)) {
            if (($m =~ s/^\s*,//)) {
                $r[$#r]{'pnt'} = 1;
                goto lst1    
            }
        } elsif (($list == 2)) {
            goto lst1 if (!($m =~ s/^\s*;(?!;)//));
            $r[$#r]{'sem'} = 1;
        } elsif (!$list) {
          lst1:
            print $::LOG (ident($c)."last\n");
            last;
        }
    }
    #print (Dumper([@r]));
    confess("empty list") if (!scalar(@r));
    
    return (delspace($m),bless({'l'=>[@r]},'Expr'));
}

my $enter_map='my ($s,$p,$xml) = ($_,$r,$_); my $r; my @c = $s->nonBlankChildNodes();';

sub dump_ast_attr {
    my ($ast,$ctx) = @_; my $r = "";
    if (blessed($ast) eq 'Expr' && scalar(@{$$ast{'l'}}) == 1 && $$ast{'l'}[0]{'typ'} eq 'class') {
        return dump_ast_attr($$ast{'l'}[0],$ctx);
    } elsif (blessed($ast) ne 'New' && 
             $$ast{'typ'} eq 'class' && !($$ast{'id'} =~ /:/) &&
             !defined($$ast{'tag'}) && !defined($$ast{'idx'}) && !($$ast{'ar'}==1 || $$ast{'sc'}==1)) {
        if ($$ast{'id'} eq 'tag') {
            '$s->nodeName';
        } else {
            return '$s->getAttribute(\''.$$ast{'id'}.'\')';
        }
    } else {
        return dump_ast($ast,$ctx);
    }
}

sub hasobj {
    my ($ast) = @_;
    if (blessed($ast) eq 'Obj') {
        return 1;
    } elsif (blessed($ast) eq 'Expr') {
        foreach my $e (@{$$ast{'l'}}) {
            return 1 if (hasobj($e));
        }
    } elsif (blessed($ast) eq 'Cases') {
        foreach my $c (@{$$ast{'cases'}}) {
            foreach my $s (@{$$c{'stmts'}}) {
                return 1 if (hasobj($s));
            }
        }
    }
    return 0;
}

sub mctx  {
    my ($c0,$c1) = @_;
    my %c = %{$c0};
    if (defined($c1)) {
        foreach my $k (%{$c1}) {
            $c{$k} = $$c1{$k};
        }
    }
    $c{'i'} = $c{'i'} + 1;
    return {%c};
}

sub dump_ast {
    my ($ast,$ctx) = @_; my $r = "";
    if (blessed($ast) eq 'Obj') {
        my $c = $$ast{'id'};
        $r .= ident($ctx)."\$r = Hdl::dobless({_p=>\$p, _xml=>\$xml},'$c');\$p=\$r;\n";
        $r .= join("\n", map {                 
            #print (Dumper($_));
            ident($ctx).'$$r{'.
              dump_ast($$_{'n'},$ctx)."}=".
                dump_ast_attr($$_{'v'},mctx($ctx)).";" } @{$$ast{'m'}});
    } elsif (blessed($ast) eq 'New') {
        my $pre = ""; my $ppre = "";
        my $c = $$ast{'id'};
        $pre = '$p,' if ($c ne 'shift');
        $ppre .= '$r = ' if ($$ctx{'map'} && $$ctx{'last'}); #$$ctx{'map'} && 
        $r .= $ppre.$c."($pre".dump_ast($$ast{args},$ctx).")";
    } elsif (blessed($ast) eq 'Id') {
        if (defined($$ast{'map'})) {
            return "[\n".ident($ctx)."map { $enter_map\n".dump_ast($$ast{'map'},mctx($ctx,{'map'=>1,'last'=>1}))."\n".ident($ctx).";\$r } \@".$$ast{'id'}."\n".ident($ctx)."]";
        } else {
            $r .= "'" if ($$ast{'typ'} eq 'str');
            $r .= ($$ast{'ar'} || $$ast{'sc'} ? ($$ast{'post'}||$$ast{'sc'} ? '$' : '@') : '').$$ast{'id'};
            $r .= "'" if ($$ast{'typ'} eq 'str');
        }
    } elsif (blessed($ast) eq 'Arr::Xpath') {
        if (hasobj($$ast{'map'})) {
            return "[\n".ident($ctx)."map { $enter_map\n".
              dump_ast($$ast{'map'},mctx($ctx,{'map'=>1,'last'=>1}))."\n".ident($ctx)."\$r } \$xml->findnodes(\"".$$ast{'path'}."\")\n".ident($ctx)."]";
        } else {
            #\$r =
            return "[\n".ident($ctx)."map { $enter_map\n".
              dump_ast($$ast{'map'},mctx($ctx,{'map'=>1,'last'=>1}))."\n".";\$r } \$xml->findnodes(\"".$$ast{'path'}."\")\n".ident($ctx)."]";
        }
    } elsif (blessed($ast) eq 'Ifthenelse') {
        return ident($ctx)."if (".
          dump_ast($$ast{'cond'},$ctx).") {\n".
            dump_ast($$ast{'true'},mctx($ctx,{'map'=>0,'last'=>0}))."\n".ident($ctx)."} else {\n".
              dump_ast($$ast{'false'},mctx($ctx,{'map'=>0,'last'=>0}))."\n".ident($ctx)."}";
    } elsif (blessed($ast) eq 'Expr') {
        my @l = @{$$ast{'l'}}; my $i;
        for ($i = 0; $i < scalar(@l); $i++) {
            if ($l[$i]{'typ'} eq 'tok' && $l[$i]{'id'} eq '==' &&
                $l[$i+1]{'typ'} eq 'str') {
                $r .= " eq ";
            } else {
                $r .= " ".dump_ast_attr($l[$i],mctx($ctx,{'last'=>(($i+1)==scalar(@l))}));
            }
        }
        return $r;
#join(" ",map { dump_ast($_,$ctx) } @{$$ast{'l'}});
    } elsif (blessed($ast) eq 'Cases') {#
        
        for (my $i = 0; $i < scalar(@{$$ast{'cases'}}); $i++) {
            my $a = $$ast{'cases'}[$i];
            $r .= (($i == 0) ? "if" : "elsif" )." (".
              dump_ast($$a{'cond'},mctx($ctx,{'map'=>0})).") {";
            foreach my $stmt (@{$$a{'stmts'}}) {
                $r .= dump_ast($stmt,mctx($ctx,{'map'=>0}));
            }
            $r .= "}";
        }
        return $r;
        
        return join("\n",map { dump_ast($_,mctx($ctx)).";;" } @{$$ast{'cases'}});
    } elsif (blessed($ast) eq 'Arsz') {#
        return "scalar(".dump_ast($$ast{'of'},mctx($ctx)).")";
    } elsif ($$ast{'typ'} eq 'xpath') {
        $r .= "(\$s->findnodes('".($$ast{'local'} ? '.' : '').$$ast{'path'}."'))";
    } else {
        $r .= "<err>";
    }
    
    if (defined($$ast{'idx'})) {
        $r .= "[".dump_ast($$ast{'idx'},mctx($ctx,{'map'=>0,'last'=>1}))."]";
    }
    if (defined($$ast{'tag'})) {
        if ($$ast{'tag'} eq 'tag') {
            $r .= "->nodeName";
        } else {
            $r .= "->getAttribute('".$$ast{'tag'}."')";
        }
    }
    if ($$ast{'sem'}) {
        $r .= ";";
    }
    if ($$ast{'pnt'}) {
        $r .= ",";
    }
    return $r;
}

1;

## Local Variables:
## perl-indent-level: 4
## cperl-indent-level: 4
## indent-tabs-mode:nil
## End:
