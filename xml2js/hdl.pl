use Data::Dumper;
use Getopt::Long;
use XML::LibXML;
use FindBin qw($Bin);
use lib "$Bin/../lib";
use Cwd;
use Cwd 'abs_path'; use Carp;

require "$Bin/template.pl";
if ((!$::OPT{'gensrc'}) &&
    (defined($::OPT{'genlvl'}) && ($::OPT{'genlvl'} != 0))) {
}

$::idre = $id = qr'(?:[a-zA-Z_][a-zA-Z_0-9]*)';
$xpath = qr{(?:$id)};

sub rmspace {
    my ($s) = @_;
    $s =~ s/^\s+//g;
    $s =~ s/\s+$//g;
    return $s;
}

package Hdl;
use Scalar::Util 'blessed'; use Carp;

sub gensrc {
    my ($out) = @_;
    return 1;
    my @m = @new_map;
    @m = @m[0..$::OPT{'genlvl'}] if (defined($::OPT{'genlvl'}));
    @m = () if (defined($::OPT{'genlvl'}) && $::OPT{'genlvl'} == 0);
    @m = ($::OPT{'genn'}) if (defined($::OPT{'genn'}) );
    
    my $OUTSRC=\*::LOG;
    if (length($out)) {
        open OUTSRC, ">$out" or die $!;
        $OUTSRC=\*OUTSRC;
    }
    foreach my $k (@m) {
        my $m = $new_map{$k}; my $ast;
        if (!length($m)) {
            next;
        }
        ($m,$ast) = Hdl::Template::parse_trans_ent($m,{'i'=>0},2);
        my $e = Hdl::Template::dump_ast($ast,{i=>1});
        my $f = "sub $k { my (\$o) = (shift(\@_)); my (\$p,\$xml,\$r) = (\$\$o{_p},\$\$o{_xml},undef); my \$s = \$xml;
my \@c = \$s->nonBlankChildNodes();
$e\n return \$r;\n}\n";
        print $OUTSRC $f;
        if (!length($out)) {
 #           print (eval ($f));
        }
    }
    print $OUTSRC "\n1;\n";
}

sub js { my ($s) = @_; return "undef"; };

%entities = ();

use XML::LibXML::PrettyPrint;
sub dbg     { my $m = substr($_[0],0,128); $m =~ s/\n/\\n/g; return "(ln:$ln) ".'"'.$m.'"'; }
sub dbgxml  { my $m = xmldump($_[0]); $m =~ s/\n/\n\|/g; return "(ln:".$_[0]->line_number().")\n|".'"'.$m.'"'; }
sub dbgscope { };
sub xmldump {
    my ($e) = @_;
    confess("Not a LibXML node\n") if (!(blessed($e) =~ /XML::LibXML/));
    my $pp = XML::LibXML::PrettyPrint->new(indent_string => "  ");
    return $pp->pretty_print($e)->toString();
}

sub n  { my ($s) = @_; return $s.$s->{n}; }
sub tn { my ($s) = @_; $s->n(); }

sub assert {
};

sub js {  my ($s) = @_;
          return "{ u:\"undeftyp: $s\"}";
          
          my $c = blessed($s);
          if (defined($maping{$c})) {
          } else {
              return "$c  - undef";
          }
}

sub log {
    print $::LOG "log\n";
}

sub dobless {
    my ($ret, $c) = @_;
    $ret = bless $ret, $c;
    $ret->importAttrs();
    return $ret;
}

sub importAttrs {
    my ($s) = @_;
    if (my $xml = $$s{'_xml'}) {
        foreach my $a ($xml->attributes()) { $$s{$a->nodeName} = $a->value; }
    }
    if (defined($$s{loc})) {
        $$s{loc} = $::loc2id{$$s{loc}} if (defined ($::loc2id{$$s{loc}}));
    }
}

sub register_entity {
    my ($n, $e) = @_; 
    $entities{$n} = $e;
}

sub getIntTyp {
    my ($s) = @_;
    confess("Cannot determine type") if (!$s->can('getSymbol'));
    return $s->getSymbol('integer');
}

sub gettyp {
    return undef;
}

sub getDecls {
    my ($r,@adecls) = @_;
    my @_adecls = ();
    for (my $i = 0; $i < scalar(@adecls); $i++) {
        my $a  = $adecls[$i];
        my $a1 = $adecls[$i+1];
        my ($decl1,$n1,$typ1,$cn1,$ret1);
        my ($decl,$n,$typ,$cn,$ret)      = ($a, $a->nodeName, $a->getAttribute('typ'), $a->getAttribute('n'),undef); 
           ($decl1,$n1,$typ1,$cn1,$ret1) = ($a1,$a1->nodeName,$a1->getAttribute('typ'),$a1->getAttribute('n'),undef) if ($a1) ; 
        my @lr = ($a->nonBlankChildNodes());
        if ($n eq 'object_declaration') {
            if ($typ eq 'constant') {
                $ret = Hdl::Constant::new($r,$decl);
            } elsif ($typ eq 'signal') {
                $ret = Hdl::Decl::Signal::new($r,$decl);
            } elsif ($typ eq 'variable') {
                $ret = Hdl::Decl::Var::new($r,$decl);
            } elsif ($typ eq 'file') {
                $ret = Hdl::Decl::File::new($r,$decl);
            } elsif ($typ eq 'alias') {
                $ret = Hdl::Decl::Alias::new($r,$decl);
            } else {
                confess("Cannot handle \"$typ\"".Hdl::dbgxml($a));
            }
        } elsif ($n eq 'type_declaration' ||
                 $n eq 'subtype_declaration' ||
                 $n eq 'anonymous_type_declaration') {
            $ret = Hdl::Type::new($r,$n,$decl);
        } elsif ($n eq 'subprogram_declaration') {
            if ($decl1 && ($decl1->nodeName eq 'subprogram_body')) {
                $i++;
            } else {
                $decl1 = undef;
            }
            $ret = Hdl::Subprog::new($r,$n,$decl,$decl1);
        } elsif ($n eq 'subprogram_body' && scalar(@lr) > 0 &&
                 $lr[0]->nodeName eq 'subprogram_declaration') {
            $ret = Hdl::Subprog::new($r,$n,$lr[0],$decl);
        } elsif ($n eq 'component_declaration') {
            $ret = bless(Hdl::Entity::new($r, $decl), 'Hdl::Component');
        } elsif ($n eq 'attribute_declaration') {
            my @t = $a->findnodes("./type");
            #print ("Cannot find attribute name ". Hdl::dbgxml($a));
            #confess ("Cannot find attribute name ". Hdl::dbgxml($a)) if (!length($n));
            confess("Cannot find type ".Hdl::dbgxml($a)) if (!scalar(@t));
            my $n = $t[0]->getAttribute('n');
            confess("Cannot find type name ".Hdl::dbgxml($a)) if (!length($n));
            $ret = Hdl::dobless({_p=>$r,_xml=>$a}, 'Hdl::Decl::Attribute');
            $$ret{_typ} = Hdl::Type::new($ret,'type',$t[0]);
    
        } elsif ($n eq 'attribute_specification') {
            my @n = grep {defined($_) } map { $_->getAttribute('n') } ($a->findnodes("./entity_name_list/Name"));
            confess("Cannot handle attributespec".Hdl::dbgxml($a)) if (!scalar(@n));
            $ret = bless({_p=>$r,_xml=>$a,_names=>[@n]}, 'Hdl::Attribute');
            if (scalar(@lr) > 1) {
                $$ret{'_val'} = Hdl::Expr::new($ret,$lr[1]);
            }
            
            
        } else {
            confess("Cannot handle ".Hdl::dbgxml($a));
        }
        push (@_adecls,$ret);
    }
    return grep { defined($_) } @_adecls;
}

sub getStmts {
    my ($r,@astmts) = @_;
    my @_astmts = ();
    for (my $i = 0; $i < scalar(@astmts); $i++) {
        my $a  = $astmts[$i];
        my $a1 = $astmts[$i+1];
        my ($decl1,$n1,$typ1,$cn1,$ret1);
        my ($decl,$n,$typ,$cn,$ret)      = ($a, $a->nodeName, $a->getAttribute('typ'), $a->getAttribute('n'),undef); 
           ($decl1,$n1,$typ1,$cn1,$ret1) = ($a1,$a1->nodeName,$a1->getAttribute('typ'),$a1->getAttribute('n'),undef) if ($a1) ; 
        my @lr = ($a->nonBlankChildNodes());
        
        if ($n eq 'generate_statement') {
            $ret = Hdl::Stmt::Generate::new({'_p'=>$r, '_xml'=>$a }); 
        } elsif ($n eq 'concurrent_conditional_signal_assignment') {
            $ret = Hdl::Stmt::ConcAssign::Sig::new({'_p'=>$r, '_xml'=>$a });
        } elsif ($n eq 'sensitized_process_statement') {
            # todo
            
        } elsif ($n eq 'component_instantiation_statement') {
            $ret = Hdl::Stmt::ComponentInstance::new({'_p'=>$r, '_xml'=>$a }); 
        } else {
            confess("Cannot handle ".Hdl::dbgxml($a));
        }
        push (@_astmts,$ret);
    }
    return grep { defined($_) } @_astmts;
}


package Hdl::Namespace;
use Carp;

sub getSymbol {
    my ($p,$sym) = @_;
    return $$p{'sym'}{$sym} if ($$p{'sym'}{$sym});
    return $$p{'_p'}->getSymbol($sym) if ($$p{'_p'});
    return undef;
}

sub setSymbol {
    my ($p,$sym,$s) = @_;
    return ($$p{'sym'}{$sym} = $s);
}

############## Top #################
package Hdl::Top;
use parent -norequire, 'Hdl', 'Hdl::Namespace';
sub new {
    my ($p,$xml) = @_; my $arch = $xml; my $time;
    my $r = {'_p'=>$p, '_xml'=>$xml };
    $r = Hdl::dobless ($r, 'Hdl::Top');
    my $std = Hdl::Type::StdLogic::new ($r,0);$$std{'n'} = "std_logic";
    my $bit = Hdl::Type::Bit::new ($r,0);$$bit{'n'} = "bit_vector";
    my $ch = Hdl::Type::Int::new ($r,0);$$bit{'n'} = "integer";
    $r->setSymbol('integer', Hdl::Type::Int::new ($r,0));
    $r->setSymbol('natural', Hdl::Type::Int::new ($r,0));
    $r->setSymbol('real', Hdl::Type::Real::new ($r,0));
    $r->setSymbol('boolean', Hdl::Type::Boolean::new ($r,0));
    $r->setSymbol('character', Hdl::Type::Int::new ($r,0));
    $r->setSymbol('string', Hdl::Type::Array::create ($r,$ch));
    $r->setSymbol('time', $time = Hdl::Type::Time::new ($r,0));
    $r->setSymbol('vitaldelaytype01', $time);
    $r->setSymbol('vitaldelaytype', $time);
    $r->setSymbol('std_logic', $std);
    $r->setSymbol('std_ulogic', $std);
    $r->setSymbol('std_logic_vector', Hdl::Type::Array::create ($r,$std));
    $r->setSymbol('std_ulogic_vector', Hdl::Type::Array::create ($r,$std));
    $r->setSymbol('unsigned', Hdl::Type::Array::create ($r,$std));
    $r->setSymbol('bit', $bit);
    $r->setSymbol('bit_vector', Hdl::Type::Array::create ($r,$bit));
    return $r;
}

########################################## ########################################## expressions  ####################################################################################

############## parse expression #################
package Hdl::Expr;
use parent -norequire, 'Hdl', 'Hdl::Namespace';
use Data::Dumper; use Carp;
sub n { return "\"<undef:".$_[0]->{'n'}."\">"}

%nodes = 
  (
   'integer_literal'         => sub { my ($p) = @_; Hdl::Expr::IntLiteral::new($p); },# 1
   'enumeration_literal'     => sub { my ($p) = @_; Hdl::Expr::EnumLiteral::new($p); }, # x
   'string_literal'          => sub { my ($p) = @_; Hdl::Expr::StringLiteral::new($p); }, # "st"
   'physical_int_literal'    => sub { my ($p) = @_; Hdl::Expr::IntLiteral::new($p); },# 1 ns
   'physical_fp_literal'     => sub { my ($p) = @_; Hdl::Expr::IntLiteral::new($p); },# 0.1 ns
   'floating_point_literal'  => sub { my ($p) = @_; Hdl::Expr::IntLiteral::new($p); },# 1.0
   'bitstring_literal'       => sub { my ($p) = @_; Hdl::Expr::BitStringLiteral::new($p); }, # "01"
   'null_literal'            => sub { my ($p) = @_; Hdl::Expr::IntLiteral::new($p); },# NULL
                                                                                       
   'constant_declaration'    => sub { my ($p) = @_; Hdl::Expr::Const::new($p); },     
   'dyadic_operator'         => sub { my ($p) = @_; Hdl::Expr::Binop::new($p); },     # a+b
   'monadic_operator'        => sub { my ($p) = @_; Hdl::Expr::Unop::new($p); },      # not a
   'implicit_dereference'    => sub { my ($p) = @_; Hdl::Expr::Unop::Transparent::new($p); }, # inout port
   'allocator_by_expression' => sub { my ($p) = @_; Hdl::Expr::Unop::Transparent::new($p); }, # new string'(...)
   'simple_name'             => sub { my ($p) = @_; Hdl::Expr::Name::new($p); },      
   'qualified_expression'    => sub { my ($p) = @_; Hdl::Expr::Qual::new($p); },      # string'()
   'variable_declaration'    => sub { my ($p) = @_; Hdl::Expr::Var::new($p); },       
                                                                                      
   'function_call'           => sub { my ($p) = @_; Hdl::Expr::FuncCall::new($p); },  # f(a)
   'procedure_call'          => sub { my ($p) = @_; Hdl::Expr::ProcCall::new($p); },  # f(a)
   'type_conversion'         => sub { my ($p) = @_; Hdl::Expr::TypeConv::new($p); },  # int(a)
   'indexed_name'            => sub { my ($p) = @_; Hdl::Expr::Index::new($p); },     # a(1)
   'slice_name'              => sub { my ($p) = @_; Hdl::Expr::Slice::new($p); },     # a(0 to 1)
   'selected_element'        => sub { my ($p) = @_; Hdl::Expr::Member::new($p); },    # r.a
   'aggregate'               => sub { my ($p) = @_; Hdl::Expr::Aggregate::new($p); }, 
   'parameter_specification' => sub { my ($p) = @_; Hdl::Expr::Param::new($p); },     # for i ... loop    
   'parametered_attribute'   => sub { my ($p) = @_; Hdl::Expr::Attribute::new($p); },     # a'left
   'simple_aggregate'        => sub { my ($p) = @_; Hdl::Expr::Agg::new($p); },       
   'range'                   => sub { my ($p) = @_; Hdl::Expr::Range::new($p); },       
   'designator_list'         => sub { my ($p) = @_; Hdl::Expr::List::new($p); },       
   'waveform'                => sub { my ($p) = @_; Hdl::Expr::Waveform::new($p); },       
   
   'signal_declaration'            => sub { my ($p) = @_; Hdl::Expr::Sig::new($p); },   
   'signal_interface_declaration'  => sub { my ($p) = @_; Hdl::Expr::Sig::new($p); },   
   'constant_interface_declaration' =>  sub { my ($p) = @_; Hdl::Expr::Sig::new($p); },
   'variable_interface_declaration' =>  sub { my ($p) = @_; Hdl::Expr::Sig::new($p); },
   'subtype_declaration'     => sub { my ($p) = @_; Hdl::Expr::Attribute::new_typ($p); }, # integer'low
   'object_alias_declaration'=> sub { my ($p) = @_; Hdl::Expr::Alias::new($p); },        
                                                                                        
   'variable_assignment'     => sub { my ($p) = @_; Hdl::Expr::Assign::Var::new($p); }, # a:= 1
   'signal_assignment'       => sub { my ($p) = @_; Hdl::Expr::Assign::Sig::new($p); }, # a<= 1
   'if_statement'            => sub { my ($p) = @_; Hdl::Stmt::If::new($p); },          # if a then end if
   'case_statement'          => sub { my ($p) = @_; Hdl::Stmt::Case::new($p); },        # case a then
   'assertion_statement'     => sub { my ($p) = @_; Hdl::Stmt::Assert::new($p); },      
   'report_statement'        => sub { my ($p) = @_; Hdl::Stmt::Report::new($p); },      
   'wait_statement'          => sub { my ($p) = @_; Hdl::Stmt::Wait::new($p); },        
   'loop'                    => sub { my ($p) = @_; Hdl::Stmt::Loop::new($p); },        
   'while'                   => sub { my ($p) = @_; Hdl::Stmt::While::new($p); },       
   'break'                   => sub { my ($p) = @_; Hdl::Stmt::Break::new($p); },       
   'return'                  => sub { my ($p) = @_; Hdl::Stmt::Return::new($p); },       
                                                                                       
   'sequential_statements'   => sub { my ($p) = @_; Hdl::Stmt::Block::new($p); },       
  );

sub new {
    my ($p,$xml,$expect) = @_; my $ex = $xml;
    confess ("Cannot generate Espression for ".Hdl::dbgxml($xml)."\n") if (!defined($xml)
                                                                           || !$nodes{$xml->nodeName});
    my $r = {'_p'=>$p, '_xml'=>$xml };
    $r->{_typ} = $expect if (defined($expect));
    #print (Hdl::dbgxml($$r{_xml})."\n");
    return $nodes{$xml->nodeName}->($r);
}

sub new_choices {
    my ($p,$xml) = @_; my $ex = $xml; my @r = (); my $r;
    confess ("Expect Choice\n".Hdl::dbgxml($xml)) if ($xml->nodeName ne "choice");
    foreach $lr (my @lr = ($xml->nonBlankChildNodes())) {
        $r = {'_p'=>$p, '_xml'=>$xml };
        if ($lr->nodeName eq "Choice") {
            if ($lr->getAttribute('val') eq 'others') {
                push(@r, Hdl::dobless ($r, 'Hdl::Expr::Choice::Others'));
            } else {
                my @lri = ($lr->nonBlankChildNodes());
                if (!scalar(@lri)) {
                    push(@r, Hdl::dobless ($r, 'Hdl::Expr::Choice::Name'));
                } else {
                    confess ("Cannot scan Choice (".scalar(@lri).")\n".Hdl::dbgxml($xml)) if (scalar(@lri) != 1);
                    my $lri = $lri[0];
                    push(@r,Hdl::Expr::new($p, $lri));
                }
            }
        } else {
            push(@r,Hdl::Expr::new($p, $lr));
            #push(@r, Hdl::dobless ($r, 'Hdl::Expr::Choice::Expr'));
        }
    }
    return [@r];
}


sub tn { my ($s) = @_; my $typ = $s->typ(); return $typ->n(); }
sub typ {
    my ($s) = @_;
    $s->gettyp() if (!defined($s->{_typ}));
    return $s->{_typ};
}

package Hdl::Expr::IntLiteral; use parent -norequire, 'Hdl::Expr'; use Data::Dumper; use Carp;
sub new {
    my ($r) = @_; 
    $r = Hdl::dobless ($r, 'Hdl::Expr::IntLiteral');
    $$r{_typ} = $$r{_p}->getSymbol("integer") if (!defined($r->{_typ}));
    confess("Cannot find interger type\n") if (!defined($r->{_typ}));
    return $r;
}
package Hdl::Expr::EnumLiteral; use parent -norequire, 'Hdl::Expr'; use Data::Dumper; use Carp;
sub new {
    my ($r) = @_; 
    $r = Hdl::dobless ($r, 'Hdl::Expr::EnumLiteral');
    $$r{_typ} = $$r{_p}->getSymbol("integer") if (!defined($r->{_typ}));
    confess("Cannot find interger type\n") if (!defined($r->{_typ}));
    return $r;
}
package Hdl::Expr::BitStringLiteral; use parent -norequire, 'Hdl::Expr'; use Data::Dumper; use Carp;
sub new {
    my ($r) = @_; 
    $r = Hdl::dobless ($r, 'Hdl::Expr::BitStringLiteral');
    $$r{_typ} = $$r{_p}->getSymbol("integer") if (!defined($r->{_typ}));
    confess("Cannot find interger type\n") if (!defined($r->{_typ}));
    return $r;
}
package Hdl::Expr::StringLiteral; use parent -norequire, 'Hdl::Expr'; use Data::Dumper; use Carp;
sub new {
    my ($r) = @_; 
    $r = Hdl::dobless ($r, 'Hdl::Expr::StringLiteral');
    $$r{_typ} = $$r{_p}->getSymbol("integer") if (!defined($r->{_typ}));
    confess("Cannot find interger type\n") if (!defined($r->{_typ}));
    return $r;
}

package Hdl::Expr::Const;      use parent -norequire, 'Hdl::Expr'; use Data::Dumper; use Carp;
sub new {
    my ($r) = @_; 
    $r = Hdl::dobless ($r, 'Hdl::Expr::Const');
    return $r;
}

package Hdl::Expr::Call;   use parent -norequire, 'Hdl::Expr'; use Data::Dumper; use Carp;

sub new_assoc {
    my ($p,$xml) = @_;  my @ra = ();
    confess("Cannot find argument list \"$v\"".Hdl::dbgxml($xml)) if ( $xml->nodeName ne 'association_chain');
    my @a = ($xml->findnodes("./Association"));
    #print(".\n");
    while(scalar(@a)) {
        my $a = shift(@a);
        my @ae = ($a->nonBlankChildNodes());
        confess("Cannot find argument list a\"$v\"".Hdl::dbgxml($xml)) if ((!(scalar(@ae) == 1 || scalar(@ae) == 2)) || $a->nodeName ne 'Association');
        if (scalar(@ae) == 1) {
            my $r = {'_p'=>$p, '_xml'=>$xml };
            $r = Hdl::dobless ($r, 'Hdl::Expr::Assoc');
            $$r{_val} = Hdl::Expr::new($r,$ae[0]);
            push(@ra, $r);
        } else {
            my $r = {'_p'=>$p, '_xml'=>$a };
            $r = Hdl::dobless ($r, 'Hdl::Expr::Assoc');
            
            $$r{_tag} = Hdl::Expr::new($r,$ae[0]);
            $$r{_val} = Hdl::Expr::new($r,$ae[1]);
            
            #print Hdl::dbgxml($xml);
            push(@ra, $r);
        }
        
        
    }
    return @ra;
}

package Hdl::Expr::FuncCall;   use parent -norequire, 'Hdl::Expr::Call'; use Data::Dumper; use Carp;
sub new {
    my ($r) = @_;  my ($p,$xml) = ($$r{_p},$$r{_xml});
    $r = Hdl::dobless ($r, 'Hdl::Expr::FuncCall');
    my $v = $$r{val};
    my @lr = ($xml->nonBlankChildNodes());
    my $a = shift(@lr);
    confess("Cannot find argument list \"$v\"".Hdl::dbgxml($xml)) if (scalar(@lr) != 0 || $a->nodeName ne 'association_chain');
    my @a = Hdl::Expr::Call::new_assoc($p,$a); 
    $$r{_arg} = [@a];
    
    #confess("Cannot find variable name \"$v\"".Hdl::dbgxml($xml));
    return $r;
}

package Hdl::Expr::ProcCall;    use parent -norequire, 'Hdl::Expr::Call'; use Data::Dumper; use Carp;
sub new {
    my ($r) = @_; my ($p,$xml) = ($$r{_p},$$r{_xml});
    $r = Hdl::dobless ($r, 'Hdl::Expr::ProcCall');
    my $v = $$r{val};
    my @lr = ($xml->nonBlankChildNodes());
    my $a = shift(@lr);
    confess("Cannot find argument list \"$v\"".Hdl::dbgxml($xml)) if (scalar(@lr) != 0 || $a->nodeName ne 'association_chain');
    
    #print Hdl::dbgxml($a);
    
    my @a = Hdl::Expr::Call::new_assoc($p,$a); 
    $$r{_arg} = [@a];
    
    return $r;
}

push(@::Hdl::new_map, 'Hdl::Expr::TypeConv::new');
$::Hdl::new_map{'Hdl::Expr::TypeConv::new'} = <<'TYP1'
  Hdl::Expr::TypeConv{_typ=Hdl::Type::new('type',.$c[0]),
                      _val=Hdl::Expr::new(       .$c[1])}

TYP1
;

# _typ=Hdl::Type(@c[0]),_val=Hdl::Expr(@c[1])
package Hdl::Expr::TypeConv;    use parent -norequire, 'Hdl::Expr'; use Data::Dumper; use Carp;
sub new {
    my ($r) = @_; my ($p,$xml) = ($$r{_p},$$r{_xml}); 
    $r = Hdl::dobless ($r, 'Hdl::Expr::TypeConv');
    my @lr = ($xml->nonBlankChildNodes());
    confess("Expect type/val for type conversion".Hdl::dbgxml($xml)) if (scalar(@lr) != 2);
    $$r{_typ} = Hdl::Type::new($r,'type',$lr[0]);
    $$r{_val} = Hdl::Expr::new($r, $lr[1]);
    return $r;
}

push(@::Hdl::new_map, 'Hdl::Expr::Index::new');
$::Hdl::new_map{'Hdl::Expr::Index::new'} = <<'TYP1'
  Hdl::Expr::Index{_obj =    Hdl::Expr::new(shift(.@c)),
                   _idxs=.@c[Hdl::Expr::new(.$c[0])]}

TYP1
;

# _idxs=@c[Hdl::Type(.)]
package Hdl::Expr::Index;       use parent -norequire, 'Hdl::Expr'; use Data::Dumper; use Carp;
sub new {
    my ($r) = @_; my ($p,$xml) = ($$r{_p},$$r{_xml}); my @ca = ();
    $r = Hdl::dobless ($r, 'Hdl::Expr::Index');
    my @lr = ($xml->nonBlankChildNodes());
    my $n = shift(@lr);
    $$r{_obj} = Hdl::Expr::new($r,$n);
    confess ("Expect indexes".Hdl::dbgxml($xml)."\n(".scalar(@lr).")\n") if (!(scalar(@lr) >= 1));
    while (scalar(@lr)) {
        my $i = shift @lr;
        my @ia = ($i->nonBlankChildNodes());
        confess("Expect Name node".Hdl::dbgxml($i)) if ($i->nodeName ne 'Name' || scalar(@ia) != 1);
        push(@ca,Hdl::Expr::new($r, $ia[0]));
    }
    $$r{_idxs} = [@ca];
    return $r;
}

push(@::Hdl::new_map, 'Hdl::Expr::Member::new');
$::Hdl::new_map{'Hdl::Expr::Member::new'} = <<'TYP1'
  Hdl::Expr::Member{_obj=Hdl::Expr::new(.$c[0])}
TYP1
;

# Hdl::Expr::Member{_obj=Hdl::Expr(@c[0])}
package Hdl::Expr::Member;      use parent -norequire, 'Hdl::Expr'; use Data::Dumper; use Carp;
sub new {
    my ($r) = @_; my ($p,$xml) = ($$r{_p},$$r{_xml});
    $r = Hdl::dobless ($r, 'Hdl::Expr::Member');
    #print Hdl::dbgxml($lr[1]);
    my @lr = ($xml->nonBlankChildNodes());
    confess ("Expect obj/property".Hdl::dbgxml($xml)."\n(".")\n") if (scalar(@lr) != 1);
    confess ("elemnt property not present".Hdl::dbgxml($xml)."\n(".")\n") if (!defined($$r{'elem'}));
    $r->{'_obj'}  = Hdl::Expr::new($r, $lr[0]);
#    $r->{'_prop'} = Hdl::Expr::new($r, $lr[1]);
    return $r;
}

push(@::Hdl::new_map, 'Hdl::Expr::Slice::new');
$::Hdl::new_map{'Hdl::Expr::Slice::new'} = <<'TYP1'
  (.$c[1].tag=='subtype_indication' && .$c[1].n) ? 
    Hdl::Expr::SlicePos{_obj=Hdl::Expr::new(.$c[0]),_pos=.$c[1].n} : 
    Hdl::Expr::Slice   {_obj=Hdl::Expr::new(.$c[0]),_range=Hdl::Expr::new(.$c[1])}
TYP1
;

package Hdl::Expr::SlicePos; use parent -norequire, 'Hdl::Expr::Slice'; use Data::Dumper; use Carp;
package Hdl::Expr::Slice;    use parent -norequire, 'Hdl::Expr';        use Data::Dumper; use Carp;
sub new {
    my ($r) = @_; my ($p,$xml,$n) = ($$r{_p},$$r{_xml});
    $r = Hdl::dobless ($r, 'Hdl::Expr::Slice');
    my @lr = ($xml->nonBlankChildNodes());
    confess ("Expect slice/range".Hdl::dbgxml($xml)."\n(".")\n") if (scalar(@lr) != 2);
    if ($lr[1]->nodeName eq "subtype_indication" && ($n = $lr[1]->getAttribute('n'))) {
        # v.read_pointer(FIFO_CNT_R), FIFO_CNT_R as n="FIFO_CNT_R"
        $r->{'_obj'}  = Hdl::Expr::new($r, $lr[0]);
        $r->{'_pos'}  = $n;
        $r = Hdl::dobless ($r, 'Hdl::Expr::SlicePos');
    } else {
        confess ("Expect range after slicename".Hdl::dbgxml($xml)."\n(".") got ".$lr[1]->nodeName."\n") if ($lr[1]->nodeName ne "range");
        $r->{'_obj'}  = Hdl::Expr::new($r, $lr[0]);
        $r->{'_range'}  = Hdl::Expr::new($r, $lr[1]);
        my $v = $$r{val};
    }
    return $r;
}

package Hdl::Expr::Choice;          use parent -norequire, 'Hdl::Expr'; use Data::Dumper; use Carp;
package Hdl::Expr::Choice::Others;  use parent -norequire, 'Hdl::Expr'; use Data::Dumper; use Carp;
package Hdl::Expr::Choice::Name;    use parent -norequire, 'Hdl::Expr'; use Data::Dumper; use Carp;
package Hdl::Expr::Choice::Expr;    use parent -norequire, 'Hdl::Expr'; use Data::Dumper; use Carp;

package Hdl::Expr::Assoc;           use parent -norequire, 'Hdl::Expr'; use Data::Dumper; use Carp;

package Hdl::Expr::Aggregate::E;    use parent -norequire, 'Hdl::Expr'; use Data::Dumper; use Carp;
package Hdl::Expr::Aggregate;       use parent -norequire, 'Hdl::Expr'; use Data::Dumper; use Carp;

push(@::Hdl::new_map, 'Hdl::Expr::Aggregate::new');
$::Hdl::new_map{'Hdl::Expr::Aggregate::new'} = <<'TYP1'
  Hdl::Expr::Aggregate{_entries=@./AggE[(.@#c==1)?
    Hdl::Expr::Aggregate::E{_val=Hdl::Expr::new(.$c[0])}:
    Hdl::Expr::Aggregate::E{_val=Hdl::Expr::new(.$c[1]),_tags=Hdl::Expr::new_choices(.$c[0])}]}
TYP1
;

sub new {
    my ($r) = @_;  my ($p,$xml) = ($$r{_p},$$r{_xml});
    $r = Hdl::dobless ($r, 'Hdl::Expr::Aggregate');
    my $v = $$r{val};
    my @lr = ($xml->findnodes("./AggE")); my @r = (); my $c;
    confess ("Expect aggregate entry".Hdl::dbgxml($xml)."\n(".")\n") if (!scalar(@lr) > 1);
    #print Hdl::dbgxml($xml);
    while (scalar(@lr)) {
        my $c = shift(@lr);
        my @lr = ($c->nonBlankChildNodes());
        confess ("Expect eather choice/val or val".Hdl::dbgxml($xml)."\n(".")\n") if (!(scalar(@lr) == 1 || scalar(@lr) == 2));
        if (scalar(@lr) == 1) {
            my $v = Hdl::Expr::new($r, $lr[0]);
            my $c = {'_p'=>$p, '_xml'=>$xml, '_val' => $v };
            push (@r, Hdl::dobless ($c, '::Hdl::Expr::Aggregate::E'));
        } else {
            my $v = Hdl::Expr::new($r, $lr[1]);
            confess ("Expect Choice as first element\n".Hdl::dbgxml($xml)) if ($lr[0]->nodeName ne "choice");
            my @c = @{Hdl::Expr::new_choices($r,$lr[0])};
            $$r{'_tag'} = [@c];
            my $c = {'_p'=>$p, '_xml'=>$xml, '_tags' => [@c], '_val' => $v };
            push (@r, Hdl::dobless ($c, '::Hdl::Expr::Aggregate::E'));
        }
    }
    $$r{_entries} = [@r];
    
    #confess("Cannot find variable name \"$v\"".Hdl::dbgxml($$r{_xml})) if (!defined($$r{_p}->getSymbol($v)));
    return $r;
}


push(@::Hdl::new_map, 'Hdl::Expr::Param::new');
$::Hdl::new_map{'Hdl::Expr::Param::new'} = <<'TYP1'
Hdl::Expr::Param{_range=Hdl::Type::getrange(./iterator[0])}
TYP1
;

# Hdl::Expr::Param{_range=::Hdl::Type::getrange(./iterator)}

package Hdl::Expr::Param;       use parent -norequire, 'Hdl::Expr'; use Data::Dumper; use Carp;
sub new {
    my ($r) = @_;  my ($p,$xml) = ($$r{_p},$$r{_xml});
    $r = Hdl::dobless ($r, 'Hdl::Expr::Param');
    my $n = $$r{n};
    my @i = $xml->findnodes("./iterator");
    #print Hdl::dbgxml($xml);
    confess ("Expect iterator (".scalar(@i).")\n".Hdl::dbgxml($xml)) if (scalar(@i)!= 1);
    $$r{_range} = ::Hdl::Type::getrange($r,$i[0]);
    
    #confess("Cannot find variable name \"$v\"".Hdl::dbgxml($$r{_xml})) if (!defined($$r{_p}->getSymbol($v)));
    return $r;
}

# Hdl::Expr::Agg{_entries=@./AggE[Hdl::Expr(.@c[0])]}

push(@::Hdl::new_map, 'Hdl::Expr::Agg::new');
$::Hdl::new_map{'Hdl::Expr::Agg::new'} = <<'TYP1'
Hdl::Expr::Agg{_entries=@./AggE[Hdl::Expr::new(.$c[0])]}
TYP1
;

package Hdl::Expr::Agg;         use parent -norequire, 'Hdl::Expr'; use Data::Dumper; use Carp;
sub new {
    my ($r) = @_; my ($p,$xml) = ($$r{_p},$$r{_xml});
    $r = Hdl::dobless ($r, 'Hdl::Expr::Agg');
    my $v = $$r{val};
    #print Hdl::dbgxml($xml);
    my @e = $xml->findnodes('./AggE');
    my @ec = map {
        my @lr = $_->nonBlankChildNodes($_);
        confess("expect one node as child to AddE (".scalar(@lr).")".Hdl::dbgxml($xml)."\n") if (scalar(@lr) != 1);
        Hdl::Expr::new($r, $lr[0]);
    } @e;
    $${'_entries'} = [@ec];
    #confess("Cannot find variable name \"$v\"".Hdl::dbgxml($$r{_xml})) if (!defined($$r{_p}->getSymbol($v)));
    return $r;
}

# Hdl::Expr::List{_list=@c[Hdl::Expr(.)]}

push(@::Hdl::new_map, 'Hdl::Expr::List::new');
$::Hdl::new_map{'Hdl::Expr::List::new'} = <<'TYP1'
Hdl::Expr::List{_list=@c[Hdl::Expr::new($s)]}
TYP1
;


package Hdl::Expr::List;       use parent -norequire, 'Hdl::Expr'; use Data::Dumper; use Carp;
sub new {
    my ($r) = @_; my ($p,$xml) = ($$r{_p},$$r{_xml});
    $r = Hdl::dobless ($r, 'Hdl::Expr::List');
    my $v = $$r{val};
    $$r{'_list'} = [ map { Hdl::Expr::new($r, $_) } $xml->nonBlankChildNodes() ];
    return $r;
}

package Hdl::Expr::Waveform;       use parent -norequire, 'Hdl::Expr'; use Data::Dumper; use Carp;
sub new {
    my ($r) = @_; my ($p,$xml) = ($$r{_p},$$r{_xml});
    $r = Hdl::dobless ($r, 'Hdl::Expr::Waveform');
    return $r;
}

push(@::Hdl::new_map, 'Hdl::Expr::Range::new');
$::Hdl::new_map{'Hdl::Expr::Range::new'} = <<'TYP1'
 (.typ == '\'range') ? 
   Hdl::Expr::Attribute{_obj=Hdl::Expr::new($c[0]),_attr=.n} :
   Hdl::Expr::Range{_left=Hdl::Expr::new($c[0]),_right=Hdl::Expr::new($c[1])}
TYP1
;




package Hdl::Expr::Range;       use parent -norequire, 'Hdl::Expr'; use Data::Dumper; use Carp;
sub new {
    my ($r) = @_; my ($p,$xml) = ($$r{_p},$$r{_xml});
    $r = Hdl::dobless ($r, 'Hdl::Expr::Range');
    my $v = $$r{val};

    my @lr = ($xml->nonBlankChildNodes());
    if ($$r{typ} eq "'range") {
        $$r{'_obj'}   = Hdl::Expr::new($r, $lr[0]);
        $$r{_attr} = $attr;
        $r = Hdl::dobless ($r, 'Hdl::Expr::Attribute');
        return $r;
    }
    
    confess ("range left/right (".scalar(@lr).")".Hdl::dbgxml($xml)."\n(".")\n") if (scalar(@lr) != 2);
    $r->{'_left'}   = Hdl::Expr::new($r, $lr[0]);
    $r->{'_right'}  = Hdl::Expr::new($r, $lr[1]);
    
    $r->{'dir'} = ::rmspace($r->{'dir'});
    
    #print $r->{'dir'};# = "to";

    #confess("Cannot find variable name \"$v\"".Hdl::dbgxml($$r{_xml})) if (!defined($$r{_p}->getSymbol($v)));
    return $r;
}


push(@::Hdl::new_map, 'Hdl::Expr::SigAttr::new');
$::Hdl::new_map{'Hdl::Expr::SigAttr::new'} = <<'TYP1'
   Hdl::Expr::SigAttr{}
TYP1
;


package Hdl::Expr::SigAttr;     use parent -norequire, 'Hdl::Expr'; use Data::Dumper; use Carp;
sub new {
    my ($r) = @_; my ($p,$xml) = ($$r{_p},$$r{_xml});
    $r = Hdl::dobless ($r, 'Hdl::Expr::SigAttr');
    my $v = $$r{val};
    confess("Cannot find attribute".Hdl::dbgxml($xml)) if (!length($xml->getAttribute('attribute')));
    #confess("Cannot find variable name \"$v\"".Hdl::dbgxml($$r{_xml})) if (!defined($$r{_p}->getSymbol($v)));
    return $r;
}

push(@::Hdl::new_map, 'Hdl::Expr::Name::new');
$::Hdl::new_map{'Hdl::Expr::Name::new'} = <<'TYP1'
   Hdl::Expr::Name{}
TYP1
;

package Hdl::Expr::Name;         use parent -norequire, 'Hdl::Expr'; use Data::Dumper; use Carp;
sub new {
    my ($r) = @_;
    $r = Hdl::dobless ($r, 'Hdl::Expr::Name');
    confess("Doesnt have value ".Hdl::dbgxml($$r{_xml})) if (!defined($$r{'val'}));
    
    #confess("Cannot find variable name \"$v\"".Hdl::dbgxml($$r{_xml})) if (!defined($$r{_p}->getSymbol($v)));
    
    return $r;
}

push(@::Hdl::new_map, 'Hdl::Expr::Var::new');
$::Hdl::new_map{'Hdl::Expr::Var::new'} = <<'TYP1'
   Hdl::Expr::Var{}
TYP1
;

package Hdl::Expr::Var; use parent -norequire, 'Hdl::Expr'; use Data::Dumper; use Carp;
sub new {
    my ($r) = @_;
    $r = Hdl::dobless ($r, 'Hdl::Expr::Var');
    confess("Doesnt have value ".Hdl::dbgxml($$r{_xml})) if (!defined($$r{'val'}));
    my $v = $$r{val};
    #confess("Cannot find variable name \"$v\"".Hdl::dbgxml($$r{_xml})) if (!defined($$r{_p}->getSymbol($v)));
    
    return $r;
}

push(@::Hdl::new_map, 'Hdl::Expr::Attr::new');
$::Hdl::new_map{'Hdl::Expr::Attr::new'} = <<'TYP1'
   Hdl::Expr::Attr{}
TYP1
;

package Hdl::Expr::Attr; use parent -norequire, 'Hdl::Expr'; use Data::Dumper; use Carp;
sub new {
    my ($r) = @_;
    $r = Hdl::dobless ($r, 'Hdl::Expr::Attr');
    confess("Doesnt have value ".Hdl::dbgxml($$r{_xml})) if (!defined($$r{'val'}));
    my $v = $$r{val};
    #confess("Cannot find variable name \"$v\"".Hdl::dbgxml($$r{_xml})) if (!defined($$r{_p}->getSymbol($v)));
    
    return $r;
}

push(@::Hdl::new_map, 'Hdl::Expr::Sig::new');
$::Hdl::new_map{'Hdl::Expr::Sig::new'} = <<'TYP1'
   Hdl::Expr::Sig{}
TYP1
;

package Hdl::Expr::Sig; use parent -norequire, 'Hdl::Expr'; use Data::Dumper; use Carp;
sub new {
    my ($r) = @_;
    $r = Hdl::dobless ($r, 'Hdl::Expr::Sig');
    confess("Doesnt have value ".Hdl::dbgxml($$r{_xml})) if (!defined($$r{'val'}));
    my $v = $$r{val};
    #confess("Cannot find variable name \"$v\"".Hdl::dbgxml($$r{_xml})) if (!defined($$r{_p}->getSymbol($v)));
    return $r;
}

push(@::Hdl::new_map, 'Hdl::Expr::Attribute::new');
$::Hdl::new_map{'Hdl::Expr::Attribute::new'} = <<'TYP1'
  {{case
    (.attribute && .n) ?:
      Hdl::Expr::Attribute{_param=Hdl::Expr::new($c[0]),_obj=Hdl::Namespace::getSymbol(.n)}  ;;
    (.attribute && .typ == 'expr') ?:
      Hdl::Expr::Attribute{_param=Hdl::Expr::new($c[1]),_obj=Hdl::Expr::new($c[0])}  ;;
    (1) ?:
      Hdl::Expr::Attribute{}  ;;
  }}
TYP1
;

package Hdl::Expr::Attribute; use parent -norequire, 'Hdl::Expr'; use Data::Dumper; use Carp;
sub new_typ {
    my ($r) = @_; my ($p,$xml) = ($$r{_p},$$r{_xml});
    $r = Hdl::dobless ($r, 'Hdl::Expr::Attribute');
    my @c = $xml->nonBlankChildNodes();
    confess("Need leaf ".Hdl::dbgxml($$r{_xml})) if (!(scalar(@c) == 0));
    my $attr = $xml->getAttribute('attribute');
    my $n = $xml->getAttribute('n');
    confess("Need attribute and name ".Hdl::dbgxml($$r{_xml})) if (!(length($n) && length($attr)));
    return $r;
}
sub new {
    my ($r) = @_; my ($p,$xml) = ($$r{_p},$$r{_xml});
    $r = Hdl::dobless ($r, 'Hdl::Expr::Attribute');
    my @c = $xml->nonBlankChildNodes();
    confess("Parametered attribute, expect 2 (".scalar(@c).")".Hdl::dbgxml($$r{_xml})) if (!(scalar(@c) == 2 || scalar(@c) == 1));
    my $typ = $xml->getAttribute('typ');
    my $attr = $xml->getAttribute('attribute');
    my $n    = $xml->getAttribute('n');
    # n+attr:    <parametered n=. attribute=.         > <param> </parametered>     =  n'attribute(param)
    # only attr: <parametered     attribute=. typ=expr> <o> <dim> </parametered>   =  o'attribute(dim)
    $$r{_attr} = $attr;
    if (length($attr)&&length($n)) {
        confess("Only one entry after n,attribute") if (!(scalar(@c)==1));
        my $t = $p->getSymbol($n);
        confess("Cannot retrieve type \"$n\"") if (!($t));
        $$r{_obj} = $t;
        $$r{_param} = Hdl::Expr::new($r,$c[0]) if (scalar(@c) > 0);
    } elsif (length($attr)&&$typ eq 'expr') {
        $$r{_obj}   = Hdl::Expr::new($r,$c[0]);
        $$r{_param} = Hdl::Expr::new($r,$c[1]) if (scalar(@c) > 1);
    }

    
    #print Hdl::dbgxml($$r{_xml});
    if ($attr eq 'length' ||
        $attr eq 'high' ||
        $attr eq 'range' ||
        $attr eq 'left' ||
        $attr eq 'right' ||
        $attr eq 'low') {
        confess("Expect \"$n\" ".scalar(@c)) if (!((length($n) && scalar(@c) == 1) ||
                                                   ((!length($n)) && scalar(@c) == 2 && $typ eq 'expr')));
        
    } else {
        confess("Need attribute name ".Hdl::dbgxml($$r{_xml})) if (!(length($attr)&&length($n)));
        

    }
    return $r;
}

push(@::Hdl::new_map, 'Hdl::Expr::Alias::new');
$::Hdl::new_map{'Hdl::Expr::Alias::new'} = <<'TYP1'
   Hdl::Expr::Alias{}
TYP1
;

package Hdl::Expr::Alias; use parent -norequire, 'Hdl::Expr'; use Data::Dumper; use Carp;
sub new {
    my ($r) = @_;
    $r = Hdl::dobless ($r, 'Hdl::Expr::Alias');
    confess("Doesnt have value ".Hdl::dbgxml($$r{_xml})) if (!defined($$r{'val'}));
    my $v = $$r{val};
    #confess("Cannot find variable name \"$v\"".Hdl::dbgxml($$r{_xml})) if (!defined($$r{_p}->getSymbol($v)));
    return $r;
}

package Hdl::Stmt;
use parent -norequire, 'Hdl::Expr';

package Hdl::Stmt::Block;
use parent -norequire, 'Hdl::Stmt';
use Data::Dumper; use Carp;

push(@::Hdl::new_map, 'Hdl::Stmt::Block::new');
$::Hdl::new_map{'Hdl::Stmt::Block::new'} = <<'TYP1'
   assert('Expect sequential_statements',.tag == 'sequential_statements');
   Hdl::Stmt::Block{_stmts=@c[Hdl::Expr::new($s)]}
TYP1
;


sub new {
    my ($r) = @_;  my ($p,$xml) = ($$r{_p},$$r{_xml});
    
    confess("Expect sequential_statements".Hdl::dbgxml($xml)) if ($xml->nodeName ne 'sequential_statements');
    $r = Hdl::dobless ($r, 'Hdl::Stmt::Block');
    my @lr = ($xml->nonBlankChildNodes());
    $$r{_stmts} = [ grep { defined($_) } map {
        my $e = Hdl::Expr::new($r,$_);
    } @lr ];
    return $r;
}
sub stmts { my ($s) = @_; return @{$$s{_stmts}};} 

package Hdl::Stmt::Block::Else;
use parent -norequire, 'Hdl::Stmt::Block';

package Hdl::Stmt::Block::If;
use parent -norequire, 'Hdl::Stmt::Block';

package Hdl::Stmt::If;
use parent -norequire, 'Hdl::Stmt';
use Data::Dumper; use Carp;


sub new_if {
    my ($p,$c) = @_;
    my $e = shift(@$c);
    my $r = {'_p'=>$p, '_xml'=>$e };
    
    my @lr = ($e->nonBlankChildNodes());
    if (scalar(@lr == 1)) {
        if (0 == scalar(@$c) &&
            $e->getAttribute('ctyp') eq 'else') {
            $r = Hdl::Expr::new($p,$lr[0]);
            push(@ca, (bless($r, 'Hdl::Stmt::Block::Else')));
        } else {
            confess ("Expect else with only statments".Hdl::dbgxml($c)."\n(".scalar(@r).")\n");
        }
    } else {
        $r = Hdl::dobless ($r, 'Hdl::Stmt::If');
        my $e = Hdl::Expr::new($r,$lr[0]);
        my $b = Hdl::Expr::new($r,$lr[1]);
        $$r{'_cond'} = $e;
        $$r{'_true'} = bless ($b, 'Hdl::Stmt::Block::If');
        if (scalar(@$c)) {
            $$r{'_false'} = new_if($r,$c);
        }
    }
    return $r;
}

sub new {
    my ($r) = @_;  my ($p,$xml) = ($$r{_p},$$r{_xml});
    my @c = $xml->findnodes('./clause');
    return new_if($p,[@c]);
}

package Hdl::Stmt::Loop; use parent -norequire, 'Hdl::Stmt';
use Data::Dumper; use Carp;

push(@::Hdl::new_map, 'Hdl::Stmt::Loop::new');
$::Hdl::new_map{'Hdl::Stmt::Loop::new'} = <<'TYP1'
   (@#c == 2) ? 
    Hdl::Stmt::Loop{
      _param=Hdl::Expr::new($c[0]),
      _block=Hdl::Expr::new($c[1])
    } :
    Hdl::Stmt::Loop{
      _block=Hdl::Expr::new($c[0])
    }
TYP1
;


sub new {
    my ($r) = @_; my ($p,$xml) = ($$r{_p},$$r{_xml});
    $r = Hdl::dobless ($r, 'Hdl::Stmt::Loop');
    my @c = $xml->nonBlankChildNodes();
    confess("Expect param/block") if (!(scalar(@c) == 1 ||  scalar(@c) == 2 && $c[0]->nodeName eq 'parameter_specification'));
    if (scalar(@c) == 2) {
        $$r{_param} = Hdl::Expr::new($r,$c[0]);
        $$r{_block} = Hdl::Expr::new($r,$c[1]);
    } else {
        $$r{_block} = Hdl::Expr::new($r,$c[0]);
    }
    return $r;
}

package Hdl::Stmt::While; use parent -norequire, 'Hdl::Stmt';
use Data::Dumper; use Carp;

push(@::Hdl::new_map, 'Hdl::Stmt::While::new');
$::Hdl::new_map{'Hdl::Stmt::While::new'} = <<'TYP1'
   (@#c == 2) ? 
    Hdl::Stmt::Loop{
      _test=Hdl::Expr::new($c[0]),
      _block=Hdl::Expr::new($c[1])
    } :
    Hdl::Stmt::Loop{
      _block=Hdl::Expr::new($c[0])
    }
TYP1
;

sub new {
    my ($r) = @_; my ($p,$xml) = ($$r{_p},$$r{_xml});
    $r = Hdl::dobless ($r, 'Hdl::Stmt::While');
    my @c = $xml->nonBlankChildNodes();
    confess("Expect while test/block") if (!(scalar(@c) == 1 ||  scalar(@c) == 2));
    if (scalar(@c) == 2) {
        $$r{_test}  = Hdl::Expr::new($r,$c[0]);
        $$r{_block} = Hdl::Expr::new($r,$c[1]);
    } else {
        $$r{_block} = Hdl::Expr::new($r,$c[0]);
    }
    return $r;
}

package Hdl::Stmt::Break; use parent -norequire, 'Hdl::Stmt';
use Data::Dumper; use Carp;

push(@::Hdl::new_map, 'Hdl::Stmt::Break::new');
$::Hdl::new_map{'Hdl::Stmt::Break::new'} = <<'TYP1'
   (@#c) ? Hdl::Stmt::Break{_cond=Hdl::Expr::new($c[0])} : Hdl::Stmt::Break{}
TYP1
;

sub new {
    my ($r) = @_; my ($p,$xml) = ($$r{_p},$$r{_xml});
    $r = Hdl::dobless ($r, 'Hdl::Stmt::Break');
    my @c = $xml->nonBlankChildNodes();
    #confess("Expect while test/block") if (!(scalar(@c) == 1 ||  scalar(@c) == 2));
    if (scalar(@c)) {
        $$r{_cond} = Hdl::Expr::new($r,$c[0]);
    }
    return $r;
}

package Hdl::Stmt::Return; use parent -norequire, 'Hdl::Stmt';
use Data::Dumper; use Carp;

push(@::Hdl::new_map, 'Hdl::Stmt::Return::new');
$::Hdl::new_map{'Hdl::Stmt::Return::new'} = <<'TYP1'
   (@#c) ? Hdl::Stmt::Return{_ret=Hdl::Expr::new($c[0])} : Hdl::Stmt::Return{}
TYP1
;

sub new {
    my ($r) = @_; my ($p,$xml) = ($$r{_p},$$r{_xml});
    $r = Hdl::dobless ($r, 'Hdl::Stmt::Return');
    my @c = $xml->nonBlankChildNodes();
    #confess("Expect while test/block") if (!(scalar(@c) == 1 ||  scalar(@c) == 2));
    if (scalar(@c)) {
        $$r{_ret} = Hdl::Expr::new($r,$c[0]);
    }
    return $r;
}


package Hdl::Stmt::Case::Val;
use parent -norequire, 'Hdl::Stmt::Case';
use Data::Dumper; use Carp;
sub new {
    my ($r) = @_; my ($p,$xml) = ($$r{_p},$$r{_xml});
    $r = Hdl::dobless ($r, 'Hdl::Stmt::Case::Val');
    confess("Expect choice".Hdl::dbgxml($xml)) if ($xml->nodeName ne 'Choice');
    
    my @c = $xml->nonBlankChildNodes(); my $sel;
    my @cs = ();
    while (scalar(@c) && $c[0]->nodeName eq 'choice') {
        my $sel = shift(@c);
        push(@cs,@{Hdl::Expr::new_choices($r,$sel)});
    }
    $$r{'_c'} = [@cs];
    confess("Expect one seqlist after case\n".::Hdl::dbgxml($xml)) if (scalar(@c) != 1);
    $$r{'_b'} = Hdl::Expr::new($r,$c[0]);
    return $r;
}


package Hdl::Stmt::Case;
use parent -norequire, 'Hdl::Stmt';
use Data::Dumper; use Carp;

sub new {
    my ($r) = @_; my ($p,$xml) = ($$r{_p},$$r{_xml});
    $r = Hdl::dobless ($r, 'Hdl::Stmt::Case');
    #print("xml:\n".Hdl::dbgxml($xml));
    my @c = $xml->nonBlankChildNodes();
    my $sel = shift(@c);
    $$r{'_obj'}  = Hdl::Expr::new($r,$sel);
    $$r{'_cases'} = [ map {  
        my $e = {'_p'=>$r, '_xml'=>$_ };
        my $_e = Hdl::Stmt::Case::Val::new($e); $_e; 
    } @c ]; 
    my $v = $$r{val};
    return $r;
}

package Hdl::Stmt::Wait;
use parent -norequire, 'Hdl::Stmt';
use Data::Dumper; use Carp;
sub new {
    my ($r) = @_; my ($p,$xml) = ($$r{_p},$$r{_xml});
    $r = Hdl::dobless ($r, 'Hdl::Stmt::Wait');
    my @c = $xml->nonBlankChildNodes();
    confess("Expect one expression in wait\n".::Hdl::dbgxml($xml)) if (scalar(@c) > 1);
    if (scalar(@c) == 1) {
        $$r{'_wait'}  = Hdl::Expr::new($r,$c[0]);
    } else {
    }
    return $r;
}


package Hdl::Stmt::Assert;
use parent -norequire, 'Hdl::Stmt';
use Data::Dumper; use Carp;
sub new {
    my ($r) = @_; my ($p,$xml) = ($$r{_p},$$r{_xml});
    $r = Hdl::dobless ($r, 'Hdl::Stmt::Assert');
    my $v = $$r{val};
    return $r;
}

package Hdl::Stmt::Report;
use parent -norequire, 'Hdl::Stmt';
use Data::Dumper; use Carp;
sub new {
    my ($r) = @_; my ($p,$xml) = ($$r{_p},$$r{_xml});
    $r = Hdl::dobless ($r, 'Hdl::Stmt::Report');
    my $v = $$r{val};
    return $r;
}

############ concurrent ############

package Hdl::Stmt::Generate; use parent -norequire, 'Hdl::Stmt';
use Data::Dumper; use Carp;

sub decl {
    my ($s) = @_;
    my $r = {%$s};
    return bless ($r, '::Hdl::Stmt::Generate::Decls') ;
}

#eval(my $js = ::convert_template('Hdl::Stmt::Generate::js', 
#'/* generate {(n)} */
#function _t_{.of.} (_p,_n,_g,_port) {
#    hdl.obj(this,_p,_n);
#    this._seq = {@decl,js@};
#    this.elaborate = function() {
#    }
#}
#'));

sub new {
    my ($r) = @_; my ($p,$xml) = ($$r{_p},$$r{_xml});
    $r = Hdl::dobless ($r, 'Hdl::Stmt::Generate');
    my $typ = $xml->getAttribute('typ');
    my @chain = $xml->findnodes('./concurrent_statement_chain');
    die ("Expect only one concurrent statment chain in ".Hdl::dbgxml($xml)) if (scalar(@chain) > 1);
    my $c = $chain[0];
    my @lr = ($xml->nonBlankChildNodes());
    $r->{'_typ'} = $typ;
    if ($typ eq 'if') {
        die ("Expect if condiftional ".Hdl::dbgxml($xml)) if (scalar(@lr) < 1);
        $r->{'_conditional'} = Hdl::Expr::new($r, $lr[0]);
    } elsif ($typ eq 'for') {
        die ("Expect for iterator ".Hdl::dbgxml($xml)) if (scalar(@lr) < 1);
        $r->{'_conditional'} = Hdl::Expr::new($r, $lr[0]);
    } else {
        die ("Expect \"if\" or \"for\" in ".Hdl::dbgxml($xml)) if (!($typ eq 'if' || $typ eq 'for'));
    }
    if (defined($c)) {
        my @dc = $c->findnodes('./*');
        my @d = ::Hdl::getStmts($r,@dc);
        $r->{'_stmts'} = [ @d ];
    }
    return $r;
}

package Hdl::Stmt::ComponentInstance; use parent -norequire, 'Hdl::Stmt';
use Data::Dumper; use Carp;

sub new {
    my ($r) = @_; my ($p,$xml) = ($$r{_p},$$r{_xml});
    $r = Hdl::dobless ($r, 'Hdl::Stmt::ComponentInstance');
    my $typ = $xml->getAttribute('typ');
    my @g = $xml->findnodes('./generic_map_aspect/association_chain');
    my @p = $xml->findnodes('./port_map_aspect/association_chain');
    die ("Expect one generic and one port ".Hdl::dbgxml($xml)) if (scalar(@g) > 1 || scalar(@p) > 1);
    my $gen = $g[0];
    my $prt = $p[0];
    $r->{'_generics'} = [Hdl::Expr::Call::new_assoc($p,$gen)];
    $r->{'_ports'}    = [Hdl::Expr::Call::new_assoc($p,$prt)];
      
    return $r;
}

package Hdl::Stmt::ConcAssign::Sig; use parent -norequire, 'Hdl::Stmt';
use Data::Dumper; use Carp;

sub new {
    my ($r) = @_; my ($p,$xml) = ($$r{_p},$$r{_xml});
    $r = Hdl::dobless ($r, 'Hdl::Stmt::ConcAssign::Sig');
    
    my @lr = ($xml->nonBlankChildNodes());
    confess ("Expect 3 childs for sigassign ".Hdl::dbgxml($xml)) if (scalar(@lr) != 3);
    #print (Hdl::dbgxml($xml));
    $r->{'_left'}  = Hdl::Expr::new($r, $lr[0]);
    my @e = $xml->findnodes('./waveform/waveelem');
    confess("Cannot find right element".Hdl::dbgxml($xml)) if (scalar(@e) == 0);
    my @ei = map {
        my @er = ($_->nonBlankChildNodes());
        my $w = bless({_p=>$r,_xml=>$_},'Hdl::Decl::Waveform');
        confess("Cannot non-single right element(".scalar(@er)."):".Hdl::dbgxml($xml)) if (!(scalar(@er) == 1 || scalar(@er) == 2));
        $$w{_elem} = Hdl::Expr::new($r, $er[0]);
        if (scalar(@er) == 2) {
            $$w{_delay} = Hdl::Expr::new($r, $er[1]);
        }
        $w
    } @e;
    $r->{'_right'} = [@ei];
    my $v = $$r{val};
    return $r;
}

############ expr ############


package Hdl::Expr::Assign;
use parent -norequire, 'Hdl::Expr';

package Hdl::Expr::Assign::Var;
use parent -norequire, 'Hdl::Expr::Assign';
use Data::Dumper; use Carp;
sub new {
    my ($r) = @_; my ($p,$xml) = ($$r{_p},$$r{_xml});
    $r = Hdl::dobless ($r, 'Hdl::Expr::Assign::Var');
    my @lr = ($xml->nonBlankChildNodes());
    confess ("Expect 2 childs for varassign ".Hdl::dbgxml($xml)) if (scalar(@lr) != 2);
    #
    $r->{'_left'}  = Hdl::Expr::new($r, $lr[0]);
    $r->{'_right'} = Hdl::Expr::new($r, $lr[1]);
    #print (Hdl::dbgxml($lr[0]));

    my $v = $$r{val};
    return $r;
}

package Hdl::Decl::Waveform; use parent -norequire, 'Hdl::Expr'; use Data::Dumper; use Carp;

package Hdl::Expr::Assign::Sig;
use parent -norequire, 'Hdl::Expr::Assign';
use Data::Dumper; use Carp;
sub new {
    my ($r) = @_; my ($p,$xml) = ($$r{_p},$$r{_xml});
    $r = Hdl::dobless ($r, 'Hdl::Expr::Assign::Sig');
    my @lr = ($xml->nonBlankChildNodes());
    confess ("Expect 3 childs for sigassign ".Hdl::dbgxml($xml)) if (scalar(@lr) != 3);
    #print (Hdl::dbgxml($xml));
    $r->{'_left'}  = Hdl::Expr::new($r, $lr[0]);
    my @e = $xml->findnodes('./waveform/waveelem');
    confess("Cannot find right element".Hdl::dbgxml($xml)) if (scalar(@e) == 0);
    my @ei = map {
        my @er = ($_->nonBlankChildNodes());
        my $w = bless({_p=>$r,_xml=>$_},'Hdl::Decl::Waveform');
        confess("Cannot non-single right element(".scalar(@er)."):".Hdl::dbgxml($xml)) if (!(scalar(@er) == 1 || scalar(@er) == 2));
        $$w{_elem} = Hdl::Expr::new($r, $er[0]);
        if (scalar(@er) == 2) {
            $$w{_delay} = Hdl::Expr::new($r, $er[1]);
        }
        $w
    } @e;
    $r->{'_right'} = [@ei];
    my $v = $$r{val};
    return $r;
}

package Hdl::Expr::Binop;
use parent -norequire, 'Hdl::Expr';
use Data::Dumper; use Carp;
#eval(my $js = ::convert_template('Hdl::Expr::Binop::n', 
#"({(_left,n)}{.op.}{(_right,n)})"));

%binops = ( 
    'integer' => (
        '-'   => "Integer.sub({(_left,js)},{(_right,js)})",
        '+'   => "Integer.add({(_left,js)},{(_right,js)})",
        '/'   => "Integer.div({(_left,js)},{(_right,js)})",
        '**'  => "Integer.pow({(_left,js)},{(_right,js)})",),
   'boolean' => (
        'or'  => "Boolean.or({(_left,js)},{(_right,js)})",
        'and' => "Boolean.and({(_left,js)},{(_right,js)})",),
   'stdlogic' => (
        '='   => "stdlogic.eq({(_left,js)},{(_right,js)})",
        'or'  => "stdlogic.or({(_left,js)},{(_right,js)})",
        'and' => "stdlogic.or({(_left,js)},{(_right,js)})",
        'xor' => "stdlogic.or({(_left,js)},{(_right,js)})",)
);

%unops = 
  ( 
    'integer' => (),
    'boolean' => (
        'not'  => "(!{(_left,js)})",),
    'stdlogic' => (
        'not' => "stdlogic.not({(_left,js)})",));

sub new {
    my ($r) = @_;
    my ($p,$xml) = ($$r{_p},$$r{_xml});
    $r = Hdl::dobless ($r, 'Hdl::Expr::Binop');
    my @lr = ($xml->nonBlankChildNodes());
    confess ("Expect 2 childs for binop ".Hdl::dbgxml($xml)) if (scalar(@lr) != 2);
    $r->{'_left'}  = Hdl::Expr::new($r, $lr[0],$$r{_typ});
    $r->{'_right'} = Hdl::Expr::new($r, $lr[1],$$r{_typ});
    my $lt = $r->{'_left'}->typ();
    my $rt = $r->{'_right'}->typ();
    
    return $r;
}

package Hdl::Expr::Qual; use parent -norequire, 'Hdl::Expr'; use Data::Dumper; use Carp;
sub new {
    my ($r) = @_;
    my ($p,$xml) = ($$r{_p},$$r{_xml});
    $r = Hdl::dobless ($r, 'Hdl::Expr::Qual');
    my @lr = ($xml->nonBlankChildNodes());
    confess ("Expect 2 childs for binop ".Hdl::dbgxml($xml)) if (scalar(@lr) != 2);
    confess ("Expect type as first") if ($lr[0]->nodeName ne 'type');
    my $n =  $lr[0]->getAttribute('n');
    confess ("Cannot retrieve type \"$n\"") if (!length($n));
    
    $r->{'_typ'}  = $n;
    #$r->{'_right'} = Hdl::Expr::new($r, $lr[1],$$r{_typ});
    
    #my $lt = $r->{'_left'}->typ();
    #my $rt = $r->{'_right'}->typ();
    
    return $r;
}

package Hdl::Expr::Unop;
use parent -norequire, 'Hdl::Expr';
use Data::Dumper; use Carp;
sub new {
    my ($r) = @_;
    my ($p,$xml) = ($$r{_p},$$r{_xml});
    $r = Hdl::dobless ($r, 'Hdl::Expr::Unop');
    my @lr = ($xml->nonBlankChildNodes());
    confess ("Expect 1 childs for unop ".Hdl::dbgxml($xml)) if (scalar(@lr) != 1);
    $r->{'_left'}  = Hdl::Expr::new($r, $lr[0],$$r{_typ});
    my $lt = $r->{'_left'}->typ();
    return $r;
}

package Hdl::Expr::Unop::Transparent;
use parent -norequire, 'Hdl::Expr::Unop';
sub new {
    my ($r) = @_; my ($p,$xml) = ($$r{_p},$$r{_xml});
    $r = Hdl::Expr::Unop::new($r);
    $r = Hdl::dobless ($r, 'Hdl::Expr::Unop::Transparent');
    $$r{'op'} = $xml->nodeName;
    return $r;
}

########################################## ########################################## Types ####################################################################################
############## type base #################

package Hdl::Type;
use parent -norequire, 'Hdl', 'Hdl::Namespace';
use Data::Dumper; use Carp; use Class::ISA;
use Scalar::Util 'blessed'; 

sub js { return "{u:0}" } 

sub getrange {
    my ($p,$r) = @_; my $n; 
    my @si = $r->findnodes('./subtype_indication'); my $si = $si[0];
    my @c = $r->findnodes('./subtype_indication/*');
    if (scalar(@c) == 0 && $si && length($n = $si->getAttribute('n'))) {
        #confess("Expect integer as range, got $n".Hdl::dbgxml($r)) if ($n ne "integer" && $n ne "natural");
        
        return Hdl::dobless({'_p'=>$p, '_xml'=>$si}, 'Hdl::Type::Ref');
        
        return (undef); # array (integer <> ) of ...
    }
    my @r = $r->findnodes('./subtype_indication/range');
    if (scalar(@r)) {
        confess ("Expecting one subtype_indication/range (".scalar(@r).")(".Hdl::dbgxml($r).")\n") if (scalar(@r) != 1);
        my $r = $r[0];
        my @c = $r->childNodes();
        my @lr = ($r->nonBlankChildNodes());
        die ("Expect left-right\n") if (scalar(@lr) != 2);
        my $le = Hdl::Expr::new($p,$lr[0],$p->getIntTyp());
        my $re = Hdl::Expr::new($p,$lr[1],$p->getIntTyp());
        my $dir = $r->getAttribute('dir');
        printf("From ".$le->n." $dir ".$re->n."\n") if ($::d);
        return bless({('_p'=>$p, '_xml'=>$r, _left=>$le, _right=>$re, _dir=>::rmspace($dir))}, '::Hdl::Expr::Range');
    };
    my @r = $r->findnodes('./subtype_indication/array_element_constraint/arrrange');
    if (scalar(@r)) {
        #constant maxsizerx : unsigned(15 downto 0) := to_unsigned(maxsize + 18, 16);
        confess ("Expecting one subtype_indication/array_element_constraint (".scalar(@r).")(".Hdl::dbgxml($r).")\n") if (scalar(@r) != 1);
        #print Hdl::dbgxml($r[0]);
        #$r = Hdl::dobless( $r, 'Hdl::Type::Array::Constrained');
        return getrange($p,$r[0]);
    }

    my @r = $r->findnodes('./subtype_indication/parametered_attribute');
    if (scalar(@r)) {
        confess ("Expecting one subtype_indication/parametered_attribute (".scalar(@r).")(".Hdl::dbgxml($r).")\n") if (scalar(@r) != 1);
        
        my $ra = {'_p'=>$p, '_xml'=>$r[0] };
        
        return ::Hdl::Expr::Attribute::new($ra); 
        
        return (undef,undef,undef); #exit(1);
    }
    
        confess("Cannot scan range ".Hdl::dbgxml($r));
}

# {{case
#  (.tag == 'type_declaration' && @#./type_definition/record_type_definition == 1) ?:
#   ;; 
#  (.tag == 'anonymous_type_declaration' && @#./type_definition/array_type_definition == 1 ||
#   .tag == 'type_declaration'           && @#./type_definition/array_type_definition == 1)  ?:
#   ;;
# }}
# 
sub new {
    my ($p,$n,$xml) = @_; my $typ = $xml; my @re = (); my @a = ();
    my $ret = {'_p'=>$p,'_xml'=>$xml};
    print($::LOG " type ".$ret->{n}.":\n")  if ($::d);

#    print (Hdl::dbgxml($xml));

    if ($n eq 'type_declaration' &&
        scalar(@a = $typ->findnodes('./type_definition/record_type_definition')) == 1) {
        $ret = Hdl::dobless($ret, 'Hdl::Type::Record');
        my @e = $a[0]->findnodes('./entry');
        @re = map { 
            my $x = $_;
            my $n = $x->getAttribute('n');
            my $t = Hdl::Type::new($ret,'type',$x);
            my $re = {'_p'=>$ret,'_xml'=>$x,'n'=>$n};
            $re = Hdl::dobless($re, 'Hdl::Type::Record::Entry');
            $$re{_typ} = $t;
            #print ($t."\n");
            $re;
        } @e;
        print("  entries ". join(",", map { $_->getAttribute('n') } (@e))."\n")  if ($::d);
        $$ret{_entries} = [@re];
        
    } elsif (($n eq 'anonymous_type_declaration' &&
             scalar(@a = $typ->findnodes('./type_definition/array_type_definition')) == 1) ||
             ($n eq 'type_declaration' &&
              scalar(@a = $typ->findnodes('./type_definition/array_type_definition')) == 1)) {
        my @r = $a[0]->findnodes('./arrrange');
        my @t = $a[0]->findnodes('./type');
        confess ("Only one dim range suppored, expect one type (".scalar(@r).")\n") if (scalar(@r) != 1 || scalar(@t) != 1);
        $ret = Hdl::dobless( $ret, 'Hdl::Type::Array');
        $$ret{'_range'} = getrange($ret,$r[0]);
        
    } elsif ($n eq 'type_declaration' &&
             scalar(my @a = $typ->findnodes('./type_definition/enumeration_type_definition')) == 1) {
        
        $ret = Hdl::dobless( $ret, 'Hdl::Type::Enum');
        $$ret{'_vals'} = [map { $_->getAttribute('n') } $a[0]->findnodes('./Enumeration')];

    } elsif (($n eq 'type' ||  # generic
              $n eq 'subtype_declaration') &&  # subtype array
             scalar(my @a = $typ->findnodes('./subtype_indication')) == 1) {
        
        my $e = $a[0];
        my $n = $e->getAttribute('n');
        
        if (length($n)) {
            my $basetyp = $p->getSymbol($n);
            #print ("Cannot find typ $n\n".Hdl::dbgxml($typ)."\n") if (!defined($basetyp));
            
            $ret = Hdl::dobless($ret, 'Hdl::Type::Ref');
        
        } else {
            
            my $basetyp = $p->getSymbol(my $typmark = $e->getAttribute('typmark'));
            my @ra = $e->findnodes('./array_element_constraint');
            my $isar = 0;
            if (scalar(@ra) == 0 && !defined($basetyp)) {
                confess ("Cannot find typmark $typmark\n".Hdl::dbgxml($typ)) if (!defined($basetyp));
            } elsif (!defined($basetyp)) {
                # guess $basetyp to be array 
                $isar = 1;
            } 
            
            if ($isar || $basetyp->isa("Hdl::Type::Array")) {
                
                $ret = Hdl::dobless( $ret, 'Hdl::Type::Array::Constrained');
                $$ret{'_of'} = $basetyp if (defined($basetyp));
                $$ret{'_typmark'} = $typmark;
                
                ##### defined constrained array ######
                confess ("Cannot find array_element_constraint (".Hdl::dbgxml($xml).") got ".scalar(@r)."\n") if (scalar(@ra) != 1);
                my @raa = $ra[0]->nonBlankChildNodes();
                if (scalar(@raa) == 0 && 'array' eq $ra[0]->getAttribute('pos')) {
                    #type octet_vector   is array (natural range <>) of std_logic_vector(7 downto 0);
                    #subtype data_vector8 is octet_vector;
                    
                } else {
                
                    my @r = $e->findnodes('./array_element_constraint/arrrange');
                
                    confess ("array_element_constraint/arrrange(".scalar(@raa)."): Only one dim array range suppored (".Hdl::dbgxml($xml).") got ".scalar(@r)."\n") if (scalar(@r) != 1);
                
                    $$ret{'_range'} = getrange($ret,$r[0]);
                }
            } elsif ($basetyp->isa("Hdl::Type::Int")) {
                
                ##### defined constrained integer ######
                $ret = Hdl::dobless( $ret, 'Hdl::Type::Int::Constrained');
                $$ret{'_range'} = getrange($ret,$typ);
                my @r = $e->findnodes('./range');
                confess ("Only one int dim range suppored (".Hdl::dbgxml($xml).") got ".scalar(@r)."\n") if (scalar(@r) != 1);
                $$ret{'_typmark'} = $typmark;
                
            } elsif ($basetyp->isa("Hdl::Type::String")) {

                ##### defined constrained string ######
 

                my @r = $e->findnodes('./array_element_constraint/arrrange');
                confess ("Only one dim range suppored (".Hdl::dbgxml($xml).") got ".scalar(@r)."\n") if (scalar(@r) != 1);
                
                $$ret{'_of'} = $basetyp;
                $ret = Hdl::dobless( $ret, 'Hdl::Type::String::Constrained');
                $$ret{'_range'} = getrange($ret,$r[0]);
                $$ret{'_typmark'} = $typmark;
                
            } else {
                confess ("Cannot scan subtype (".Hdl::dbgxml($typ).")");         
            }
        }
        
    } elsif (($n eq 'type' && scalar(my @a = $typ->findnodes('./subtype_indication')) == 0)) {
        # no type definition but straight type ref
        my $n = $typ->getAttribute('n');
        
        confess("Cannot retrive type ".Hdl::dbgxml($typ)) if (!length($n));
      
        if (!defined($p->getSymbol($n))) {
            
            $ret = Hdl::dobless($ret, 'Hdl::Type::Ref');
            return $ret;
        }
        
        # confess("Cannot retrive type \"$n\" from $p".Hdl::dbgscope($p).Hdl::dbgxml($typ)) if (!defined($p->getSymbol($n)));
        return $p->getSymbol($n);
    }  elsif ($n eq 'type_declaration' &&
             scalar(my @a = $typ->findnodes('./type_definition')) == 1) {
        my $acc = $a[0]->getAttribute('typ');
        if ($acc eq 'access') {
            $ret = Hdl::dobless( $ret, 'Hdl::Type::Enum');
        } else {
            goto err;
        }
        @a = $a[0]->findnodes('./subtype_indication');
        confess ("Only subtype_indication supported\n".Hdl::dbgxml($typ))  if (scalar(@a) != 1);
        $ret = Hdl::dobless( $ret, 'Hdl::Type::Access');
        $$ret{'_typ'} = $a[0]->getAttribute('n');

    } else {
  err:
        confess("Cannot gen type ($n):".Hdl::dbgxml($typ));
    }
    
    if (length($ret->{'n'})) {
        $p->setSymbol($ret->{'n'}, $ret);
    }    
    return $ret;
}

package Hdl::Type::Ref;
use parent -norequire, 'Hdl::Type';

############## record type #################
package Hdl::Type::Record;
use parent -norequire, 'Hdl::Type';

package Hdl::Type::Record::Entry;
use parent -norequire, 'Hdl::Type';

############## array type #################
package Hdl::Type::Array::Constrained; use parent -norequire, 'Hdl::Type';

package Hdl::Type::Array;
use parent -norequire, 'Hdl::Type';

sub n { my ($s) = @_; return "Array"; }
sub new {
    my ($p,$xml) = @_; my $arch = $xml;
    my $r = {'_p'=>$p, '_xml'=>$xml };
    $r = Hdl::dobless ($r, 'Hdl::Type::Array');
}

sub create {
    my ($p,$sub) = @_;
    my $r = {'_p'=>$p, '_xml'=>0, '_elem' => $sub };
    $r = Hdl::dobless ($r, 'Hdl::Type::Array');
}

############## Int type #################
package Hdl::Type::Int::Constrained; use parent -norequire, 'Hdl::Type';

package Hdl::Type::Int;
use parent -norequire, 'Hdl::Type';

# convert js:
# typ.range (this, "n", <left>, <rigth>, <dir>);

# eval(my $js = ::convert_template('Hdl::Type::Int::js', "typ.int({.val.})"));

sub n { my ($s) = @_; return "Int"; }
sub new {
    my ($p,$xml) = @_; my $arch = $xml;
    my $r = {'_p'=>$p, '_xml'=>$xml };
    $r = Hdl::dobless ($r, 'Hdl::Type::Int');
}

sub value {
    
}

package Hdl::Type::Boolean;
use parent -norequire, 'Hdl::Type::Int';

sub n { my ($s) = @_; return "Boolean"; }

sub new {
    my ($p,$xml) = @_; my $arch = $xml;
    my $r = {'_p'=>$p, '_xml'=>$xml };
    $r = Hdl::dobless ($r, 'Hdl::Type::Boolean');
}

package Hdl::Type::Real;
use parent -norequire, 'Hdl::Type';

sub n { my ($s) = @_; return "Real"; }
sub new {
    my ($p,$xml) = @_; my $arch = $xml;
    my $r = {'_p'=>$p, '_xml'=>$xml };
    $r = Hdl::dobless ($r, 'Hdl::Type::Real');
}

package Hdl::Type::String::Constrained; use parent -norequire, 'Hdl::Type::String';

package Hdl::Type::String;
use parent -norequire, 'Hdl::Type';

sub n { my ($s) = @_; return "String"; }
sub new {
    my ($p,$xml) = @_; my $arch = $xml;
    my $r = {'_p'=>$p, '_xml'=>$xml };
    $r = Hdl::dobless ($r, 'Hdl::Type::String');
}

package Hdl::Type::Time;
use parent -norequire, 'Hdl::Type';

sub n { my ($s) = @_; return "Time"; }
sub new {
    my ($p,$xml) = @_; my $arch = $xml;
    my $r = {'_p'=>$p, '_xml'=>$xml };
    $r = Hdl::dobless ($r, 'Hdl::Type::Time');
}

############## StdLogic type #################
package Hdl::Type::Access;
use parent -norequire, 'Hdl::Type';

package Hdl::Type::Enum;
use parent -norequire, 'Hdl::Type';

sub new {
    my ($p,$xml) = @_; my $arch = $xml;
    my $r = {'_p'=>$p, '_xml'=>$xml };
    $r = Hdl::dobless ($r, 'Hdl::Type::Enum');
}

package Hdl::Type::StdLogic;
use parent -norequire, 'Hdl::Type::Enum';

sub new {
    my ($p,$xml) = @_; my $arch = $xml;
    my $r = {'_p'=>$p, '_xml'=>$xml };
    $r = Hdl::dobless ($r, 'Hdl::Type::StdLogic');
}

package Hdl::Type::Bit;
use parent -norequire, 'Hdl::Type::Enum';
sub new {
    my ($p,$xml) = @_; my $arch = $xml;
    my $r = {'_p'=>$p, '_xml'=>$xml };
    $r = Hdl::dobless ($r, 'Hdl::Type::Bit');
}

########################################## ########################################## Components ####################################################################################

package Hdl::Subprog;
use parent -norequire, 'Hdl', 'Hdl::Namespace'; use Carp;
use Scalar::Util 'blessed'; 

sub new {
    my ($p,$n,$xml,$xml1) = @_; my $arch = $xml;
    my $r = {'_p'=>$p, '_xml'=>$xml };
    $r = Hdl::dobless ($r, 'Hdl::Subprog');
    my @ia = $xml->nonBlankChildNodes();
    $$r{_iface} = [ map {
        Hdl::Arg::new($r,$_);
    } $xml->findnodes('./interface_chain/interface_declaration') ];
    if ($$r{typ} eq 'function') {
        my $fret = $ia[1];
        confess("Interface chain expect return value".::Hdl::dbgxml($xml)) if (scalar(@ia) != 2);
        $$r{_rtyp} = Hdl::Type::new($r,'type',$fret);
    }
    
#    print (Hdl::dbgxml($xml));
    if ($xml1) {
        confess ("Expect subprogram_body\n".::Hdl::dbgxml($xml1)) if ($xml1->nodeName ne 'subprogram_body');
        #print (Hdl::dbgxml($xml1->findnodes('./sequential_statements')));

        $$r{_decls} = [::Hdl::getDecls($r,$xml1->findnodes('./declaration_chain/*'))];
        $$r{_seq}   = [ grep {defined($_)} map { Hdl::Expr::new($r,$_); } $xml1->findnodes('./sequential_statements') ];
        
        #map { print(blessed($_)."\n"); } @{$$r{_seq}};
        
        


        
        #my @seqstmts = $xml1->findnodes('./sequential_statements/*'); 
        
        

    }
    
#    my @lr = ($xml->nonBlankChildNodes());
#    confess ("Expect type/vaxl\n".::Hdl::dbgxml($xml)) if (!(scalar(@lr) == 1 || scalar(@lr) == 2));
#    $r->{_typ} = Hdl::Type::new($p,'type',$lr[0]);
#    confess("Cannot create type that is printable to js: ".$r->{_typ}." ".Hdl::dbgxml($lr[0])) if ((!defined($r->{_typ})) || !$r->{_typ}->can('js'));
    
#    print("Define generic ".$r->{n}." \n"); 
#    $p->setSymbol($r->{n}, $r) if (length($r->{n}));
    return $r;
}


############## Generic #################
package Hdl::Generic;
use parent -norequire, 'Hdl', 'Hdl::Namespace'; use Carp;

# convert js:
# hdl.generic (this, "n", <idx>, <typdef>, <default-expr>);

#eval(my $js = ::convert_template('Hdl::Generic::js', 
#'var {.n.} = hdl.generic(this,\"{.n.}\", {._gidx.} /*gidx*/, {(_typ,js)});'));

sub new {
    my ($p,$xml,$gidx) = @_; my $arch = $xml;
    my $r = {'_p'=>$p, '_xml'=>$xml, '_gidx' => $gidx };
    $r = Hdl::dobless ($r, 'Hdl::Generic');
    my @lr = ($xml->nonBlankChildNodes());
    confess ("Expect type/val\n".::Hdl::dbgxml($xml)) if (!(scalar(@lr) == 1 || scalar(@lr) == 2));
    $r->{_typ} = Hdl::Type::new($p,'type',$lr[0]);
    
    print ("Cannot parse type") if (!($r->{_typ}));
    confess("Cannot create type that is printable to js: ".$r->{_typ}." ".Hdl::dbgxml($lr[0])) if ((!defined($r->{_typ})) || !$r->{_typ}->can('js'));
    
    $r->{_init} = Hdl::Expr::new($r,$lr[1]) if ((scalar(@lr) > 1)); 
    
    #print (::Hdl::dbgxml($xml));

    
    #print("Define generic ".$r->{n}." ".$r->{_typ}."\n"); 
    $p->setSymbol($r->{n}, $r) if (length($r->{n}));
    return $r;
}

package Hdl::Port;
use parent -norequire, 'Hdl'; use Carp;

sub new {
    my ($p,$xml) = @_; my $arch = $xml;
    my $r = {'_p'=>$p, '_xml'=>$xml };
    $r = Hdl::dobless ($r, 'Hdl::Port');
    my @lr = ($xml->nonBlankChildNodes());
    confess ("Expect type/val\n".::Hdl::dbgxml($xml)) if (!(scalar(@lr) == 1 || scalar(@lr) == 2));

    $r->{_typ} = Hdl::Type::new($p,'type',$lr[0]);
    
    print ("Cannot parse type") if (!($r->{_typ}));
    confess("Cannot create type that is printable to js: ".$r->{_typ}." ".Hdl::dbgxml($lr[0])) if ((!defined($r->{_typ})) || !$r->{_typ}->can('js'));
    
    $r->{_init} = Hdl::Expr::new($r,$lr[1]) if ((scalar(@lr) > 1)); 


    $p->setSymbol($r->{n},$r) if (length($r->{n}));
    return $r;
}


package Hdl::Constant;
use parent -norequire, 'Hdl::Generic'; use Carp;

sub js { 
#    print $_[0]."\n";
}

sub new {
    my ($p,$xml) = @_; my $arch = $xml;
    my $r = {'_p'=>$p, '_xml'=>$xml };
    $r = Hdl::dobless ($r, 'Hdl::Constant');

    my @lr = ($xml->nonBlankChildNodes());
    confess ("Expect type/val in constant\n".::Hdl::dbgxml($xml)) if (scalar(@lr) != 2);
    my $lrtyp = $lr[0];
    my $lrval = $lr[1];
    my $lrret = Hdl::Type::new($p,'type',$lrtyp);
    my $lrvret= Hdl::Expr::new($p,$lrval,$lrret);
    
    
    #$r->{_typ} = Hdl::Type::new($p,'type',$lr[0]);
    
    #print("Define generic ".$r->{n}." \n"); 
    
    $p->setSymbol($r->{n}, $r) if (length($r->{n}));
    return $r;
}



############## Port #################
package Hdl::Arg;
use parent -norequire, 'Hdl', 'Hdl::Namespace'; use Carp;

sub new {
    my ($p,$xml) = @_; my $arch = $xml;
    my $r = {'_p'=>$p, '_xml'=>$xml };
    $r = Hdl::dobless ($r, 'Hdl::Arg');
    my @lr = ($xml->nonBlankChildNodes());
    confess ("Expect type/val\n".::Hdl::dbgxml($xml)) if (!(scalar(@lr) == 1 || scalar(@lr) == 2));
    
    $$r{_typ} = Hdl::Type::new($r,'type',$lr[0]);
    
    $p->setSymbol($r->{n},$r) if (length($r->{n}));
    return $r;
}


package Hdl::Decl::Signal;
use parent -norequire, 'Hdl', 'Hdl::Namespace'; use Carp;

sub new {
    my ($p,$xml) = @_; my $arch = $xml;
    my $r = {'_p'=>$p, '_xml'=>$xml };
    $r = Hdl::dobless ($r, 'Hdl::Decl::Signal');
    my @lr = ($xml->nonBlankChildNodes());
    confess ("Expect type/val\n".::Hdl::dbgxml($xml)) if (!(scalar(@lr) == 1 || scalar(@lr) == 2));

    $$r{_typ} = Hdl::Type::new($r,'type',$lr[0]);
    $$r{_init} = Hdl::Expr::new($r,$lr[1]) if (scalar(@lr) >= 2);

    $p->setSymbol($r->{n},$r) if (length($r->{n}));
    return $r;
}

package Hdl::Decl::Var;
use parent -norequire, 'Hdl', 'Hdl::Namespace'; use Carp;

sub new {
    my ($p,$xml) = @_; my $arch = $xml;
    my $r = {'_p'=>$p, '_xml'=>$xml };
    $r = Hdl::dobless ($r, 'Hdl::Decl::Var');
    my @lr = ($xml->nonBlankChildNodes());
    confess ("Expect type/val\n".::Hdl::dbgxml($xml)) if (!(scalar(@lr) == 1 || scalar(@lr) == 2));

    $$r{_typ} = Hdl::Type::new($r,'type',$lr[0]);
    $$r{_init} = Hdl::Expr::new($r,$lr[1]) if (scalar(@lr) >= 2);

    $p->setSymbol($r->{n},$r) if (length($r->{n}));
    return $r;
}

package Hdl::Decl::File;
use parent -norequire, 'Hdl'; use Carp;

sub new {
    my ($p,$xml) = @_; my $arch = $xml;
    my $r = {'_p'=>$p, '_xml'=>$xml };
    $r = Hdl::dobless ($r, 'Hdl::Decl::File');
    my @lr = ($xml->nonBlankChildNodes());
    confess ("Expect type/val\n".::Hdl::dbgxml($xml)) if (!(scalar(@lr) == 1 || scalar(@lr) == 2));
    $p->setSymbol($r->{n},$r) if (length($r->{n}));
    return $r;
}

package Hdl::Decl::Alias;
use parent -norequire, 'Hdl'; use Carp;

sub new {
    my ($p,$xml) = @_; my $arch = $xml;
    my $r = {'_p'=>$p, '_xml'=>$xml };
    $r = Hdl::dobless ($r, 'Hdl::Decl::Alias');
    my @lr = ($xml->nonBlankChildNodes());
    confess ("Expect type/val\n".::Hdl::dbgxml($xml)) if (!(scalar(@lr) == 1 || scalar(@lr) == 2));
    $p->setSymbol($r->{n},$r) if (length($r->{n}));
    return $r;
}

package Hdl::Decl::Attribute; use parent -norequire, 'Hdl' , 'Hdl::Namespace'; use Carp;

############## Package #################

package Hdl::PackageDecl;
use parent -norequire, 'Hdl', 'Hdl::Namespace'; use Carp;
sub new {
    my ($p,$xml) = @_; my $pck = $xml;
    my $r = {'_p'=>$p, '_xml'=>$xml };
    $r = Hdl::dobless ($r, 'Hdl::PackageDecl');
    $$r{'_decls'} =  [  ::Hdl::getDecls($r,$pck->findnodes('./declaration_chain/*')) ];
    return $r;
}

# eval(my $js = ::convert_template('Hdl::PackageDecl::js',  
# '/* package decl {.n.} */
# function _t_pdecl_{.of.} (_p,_n,_g,_port) {
#     _pdecl_d = {(_decls,js:"{}")};
#     this.elaborate = function() {
#     }
# }
# '));
#print $js;

package Hdl::PackageBody;
use parent -norequire, 'Hdl', 'Hdl::Namespace'; use Carp;
sub new {
    my ($p,$xml) = @_; my $pck = $xml;
    my $r = {'_p'=>$p, '_xml'=>$xml };
    $r = Hdl::dobless ($r, 'Hdl::PackageBody');
    $$r{'_decls'} =  [  ::Hdl::getDecls($r,$pck->findnodes('./declaration_chain/*')) ] ;
    return $r;
}

#eval(my $js = ::convert_template('Hdl::PackageBody::js',  
#'/* Package body {.n.} */
#function _t_pbody_{.n.} (_p,_n,_g,_port) {
#    _pbody_d = {(_decls,js:"{}")};
#    this.elaborate = function() {
#    }
#}
#'));
#print $js;

############## Entity #################
package Hdl::Attribute; use parent -norequire, 'Hdl', 'Hdl::Namespace'; use Carp;
package Hdl::Component; use parent -norequire, 'Hdl', 'Hdl::Namespace'; use Carp;
package Hdl::Entity;    use parent -norequire, 'Hdl', 'Hdl::Namespace'; use Carp;

# eval(my $js = ::convert_template('Hdl::Entity::js', 
# '
# /* entity {.n.} */
# function _t_entity_{.n.} (_p,_n,_g,_port) {
#     hdl.obj(this,_p,_n);
#     /* generic */
#     this._gen = {@declgen,js@};
#     /* port */
#     this._prt = {@declprt,js@};
    
#     this.elaborate = function() {
#     }
# }
# '));

sub declgen { my ($s) = @_; return bless ({ '_generics' => [ @{$$s{_gen}}]},'::Hdl::Generic::Decls'); }
sub declprt { my ($s) = @_; return bless ({ '_ports'    => [ @{$$s{_prt}}]},'::Hdl::Port::Decls');; }

sub new {
    my ($p,$xml) = @_; my $arch = $xml;
    my $r = {'_p'=>$p, '_xml'=>$xml, _gen=>[], _prt=>[] };
    $r = Hdl::dobless ($r, 'Hdl::Entity');
    
    #print Hdl::dbgxml($xml);
    
    my $gidx = 0;
    my @g = map { Hdl::Generic::new($r,$_,$gidx++) } $arch->findnodes('./generics/interface_chain/interface_declaration');
    $r->{'_gen'} = [@g];
    my @p = map { Hdl::Port::new($r,$_) } $arch->findnodes('./ports/interface_chain/interface_declaration');
    $r->{'_prt'} = [@p];
    
    $p->setSymbol($r->{n}, $r) if (length($r->{n}));
    
    return $r;
}

############## process #################

package Hdl::Process;
use parent -norequire, 'Hdl', 'Hdl::Namespace'; use Carp;

#{(declvar)}
#{(declprc)}
#{(declfunc)}
#{(declseq)}
#{(decltyp)}
#    v = {@ declseq,js @}

#eval(my $js = ::convert_template('Hdl::Process::js', 
#'/* process {(n)} */
#function _t_{.of.} (_p,_n,_g,_port) {
#    hdl.obj(this,_p,_n);
#    this._seq = {@declseq,js@};
#    this.elaborate = function() {
#    }
#}
#'));

sub declseq { my ($s) = @_; return @{$$s{_seq}};  }

sub n { my ($s) = @_; return 'process '.$s->{'lab'}.'(arch '.$s->{_p}->n.')'; }
sub new {
    my ($p,$xml) = @_; my $proc = $xml;
    my $r = {'_p'=>$p,'_xml'=>$xml };
    $r = Hdl::dobless ($r, 'Hdl::Process');
    
    $$r{'_seq'} = [ grep {defined($_)} map {
        my $e = Hdl::Expr::new($r,$_); 
        $e;
    } $proc->findnodes('./sequential_statements') ];
    
    $$r{'_decls'} = [  ::Hdl::getDecls($r,$proc->findnodes('./declaration_chain/*')) ];

    return $r;
}

############## architecture #################

package Hdl::Arch;
use parent -norequire, 'Hdl::Entity', 'Hdl::Namespace';
use Scalar::Util 'blessed'; 
use Data::Dumper; use Carp;

# eval(my $js = ::convert_template('Hdl::Arch::js', 
# '
# /* architecture {(n)} */
# function _t_arch_{.of.} (_p,_n,_g,_port) {
#     hdl.obj(this,_p,_n);
#     /* generic */
#     this._gen = {@declgen,js@};
#     /* port */
#     this._prt = {@declprt,js@};
    
#     /* types */
#     this._typ =  [{@decltyp,js,","@}];
#     /* subs */
#     this._sub =  [{@declsub,js,","@}];
#     /* signals */
#     this._ssig = [{@declsig,js,","@}];
#     /* processes */
#     this._prc =  [{@declprc,js,","@}];
#     /* conc */
#     this._con =  [{@declcon,js,","@}];
    
#     this.elaborate = function() {
#     }
# }
# '));

sub gen     { my ($s) = @_; return @{$$s{_entity}{_gen}}; }
sub decltyp { my ($s) = @_; return bless ({ '_decls' => [ grep { $_->isa('Hdl::Type')    } @{$$s{_decls}}]}, '::Hdl::Proc::Decls'); }
sub declsub { my ($s) = @_; return bless ({ '_decls' => [ grep { $_->isa('Hdl::Subprog') } @{$$s{_decls}}]}, '::Hdl::Proc::Decls'); }
sub declsig { my ($s) = @_; return bless ({ '_decls' => [ grep { $_->isa('Hdl::Decl::Signal') } @{$$s{_decls}}]}, '::Hdl::Proc::Decls'); }
sub declgen { my ($s) = @_; return bless ({ '_generics' => [ @{$$s{_entity}{_gen}}]},'::Hdl::Generic::Decls'); }
sub declprt { my ($s) = @_; return bless ({ '_ports'    => [ @{$$s{_entity}{_prt}}]},'::Hdl::Port::Decls');; }
sub declprc { my ($s) = @_; return grep { $_->isa('Hdl::Process') } @{$$s{_processes}};  }
sub declcon { my ($s) = @_; return @{$$s{_conc}};  }

sub n { my ($s) = @_; return $s->{'n'}." of ".$s->{'of'}; }
sub new {
    my ($p,$xml) = @_; my $arch = $xml;
    my $r = {'_p'=>$p, '_xml'=>$xml, _processes=>[], _decls=>[] };
    $r = Hdl::dobless ($r, 'Hdl::Arch');
    my $of = $$r{'of'};
    my $e  = $p->getSymbol($$r{'of'});
    confess("Cannot find entity \"$of\"") if (!defined($e));
    $r->{'_p'} = $e;
    #print ("Found  arch: ".$r->n."\n");
    
    $$r{'_decls'} = [ grep { defined($_) && blessed($_) } ::Hdl::getDecls($r,$arch->findnodes('./declaration_chain/*')) ];
    my @aprocs = $arch->findnodes('./concurrent_statement_chain/sensitized_process_statement/process_statement');
    $$r{'_processes'} = [ map { Hdl::Process::new($r,$_); } @aprocs ];
    
    my @generates = $arch->findnodes('./concurrent_statement_chain/*');
    my @d = ::Hdl::getStmts($r,@generates);
    $$r{'_conc'} = [@d];
    
    
    #print(join(",\n",map { print ($_."\n"); $_->js } @{$$r{'_decls'}}));
    
    confess("Need \"of\" to access entity ".$r->n) if (!length($r->{'of'}));
    my $e = $p->getSymbol($r->{'of'});
    confess("Cannot find entity".$r->{'of'}) if (!$e);
    $r->{'_entity'} = $e;
    
    return $r;
}


package Hdl::Signal;
use parent -norequire, 'Hdl';

sub new {
    my $r = bless {}, 'Hdl::Signal';
    return $r;
}

package Hdl;

%access = (
           '::Hdl::Stmt::Block' => "\@_stmts"
          );

@mapping = (
            '::Hdl::Proc::Decls'               , [ 'decls', '.@_decls()' ],
            '::Hdl::PackageDecl::Decls'        , [ 'decls', '.@_decls()' ],
            '::Hdl::PackageBody::Decls'        , [ 'decls', '.@_decls()' ],
            '::Hdl::Generic::Decls'            , [ 'decls', '.@_generics()' ],
            '::Hdl::Port::Decls'               , [ 'decls', '.@_ports()' ],

            '::Hdl::Entity'                    , ['type', "ENTITY", 'name', '.n', 'generics', '.@_gen()', 'ports', '.@_prt()' ], 
            '::Hdl::Arch'                      , ['type', "ARCHITECTURE", 'name', '.n', 'of', '.of', 'decls', '.@_decls()', 'procs', '.@_processes()', 'concs', '.@_conc()' ], 
            '::Hdl::PackageDecl'               , ['type', "PACKAGE",     'decls', '.@_decls()'],
            '::Hdl::PackageBody'               , ['type', "PACKAGEBODY", 'decls', '.@_decls()'],

            '::Hdl::Process'                   , [ 'type', "PROCESS",  'label', '.lab', 'decls', '.@_decls()', 'block', '.@_seq()',  ],

            '::Hdl::Stmt::Generate::Decls'     , [ 'type', "GENERATE", 'decls', '.@_stmts()', 'conditional', '._conditional()' ],
            '::Hdl::Stmt::ComponentInstance'   , [ 'type', "COMPONENT", 'generics', '.@_generics()', 'ports', '.@_ports()' ],

            'Hdl::Stmt::Generate'              , [ 'type', "GENERATE", 'cond', '._typ', 'decls', '.@_stmts()', 'conditional', '._conditional()', 'loc' , '.loc' ],


            '::Hdl::Generic'                   , [ 'type' , "GENERIC", 'name', '.n', 'mode', '.mode', 'typedef', '._typ()', 'init', '._init()', 'loc' , '.loc' ],
            '::Hdl::Port'                   , [ 'type' , "PORT", 'name', '.n', 'mode', '.mode', 'typedef', '._typ()', 'init', '._init()', 'loc' , '.loc' ],
            
            '::Hdl::Component'                 , [ 'type' , "COMPONENT", 'generics', '.@_gen()', 'ports', '.@_prt()', 'loc' , '.loc' ],
            '::Hdl::Attribute'                 , [ 'type' , "ATTRIBUTEDEF", 'val', '._val()', 'names', '["names"]', 'loc' , '.loc' ], # todo print names array of Hdl::Attribute

            '::Hdl::Type::Int'                 , [ 'type' , "INTEGER", 'loc' , '.loc' ],
            '::Hdl::Type::Int::Constrained'    , [ 'type' , "INTEGERSUBTYPE", 'range', '._range()', 'loc' , '.loc' ],
            '::Hdl::Type::String::Constrained' , [ 'type' , "STRINGSUBTYPE", 'range', '._range()', 'loc' , '.loc' ],
            '::Hdl::Type::Access'              , [ 'type' , "ACCESSTYPE", 'to', '._typ', 'loc' , '.loc' ],
            '::Hdl::Expr::List'                , [ 'type' , "LIST", 'list', '.@_list()', 'loc' , '.loc' ],

            '::Hdl::Expr::IntLiteral'          , [ 'type' , "INTLITERAL",       'value', '.val', 'loc' , '.loc' ],
            '::Hdl::Expr::EnumLiteral'         , [ 'type' , "ENUMLITERAL",      'value', '.val', 'loc' , '.loc' ],
            '::Hdl::Expr::BitStringLiteral'    , [ 'type' , "BITSTRINGLITERAL", 'value', '.val', 'loc' , '.loc' ],
            '::Hdl::Expr::StringLiteral'       , [ 'type' , "STRINGLITERAL",    'value', '.val', 'loc' , '.loc' ],
            '::Hdl::Decl::Waveform'            , [ 'type' , "WAVEFORM", 'elem', '._elem()', 'delay', '._delay()', 'loc' , '.loc' ],
            
            '::Hdl::Expr::Binop'               , [ 'type' , "BINARYEXPRESSION",   'operator', 'binop(.op)', 'left' , '._left()', 'right' , '._right()', 'loc' , '.loc' ],
            '::Hdl::Expr::Unop'                , [ 'type' , "UNARYEXPRESSION",    'argument' , '._arg()', 'operator', 'unop(.op)', 'left' , '._left()', 'loc' , '.loc' ],
            '::Hdl::Expr::Wait'                , [ 'type' , "WAITEXPRESSION",     'wait' , '._wait()', 'loc' , '.loc' ],
            '::Hdl::Expr::FuncCall'            , [ 'type' , "FUNCCALLEXPRESSION", 'arguments' , '.@_arg()', 'calee', '._callee()', 'loc' , '.loc' ],
            '::Hdl::Expr::ProcCall'            , [ 'type' , "PROCCALLEXPRESSION", 'arguments' , '.@_arg()', 'calee', '._callee()', 'loc' , '.loc' ],
            '::Hdl::Expr::Qual'                , [ 'type' , "QUALEXPRESSION",     'typedef' , '._typ', 'right' , '._right()', 'loc' , '.loc' ],
            '::Hdl::Expr::TypeConv'            , [ 'type' , "TYPECONVERSION",     'typedef' , '._typ()', 'value' , '._val()', 'loc' , '.loc' ],
 
            '::Hdl::Expr::Name'                , [ 'type' , "IDENTIFIER", 'phase' , "'name'", 'value', '.val', 'loc' , '.loc' ],
            '::Hdl::Expr::Var'                 , [ 'type' , "IDENTIFIER", 'phase' , "'var'",  'value', '.val', 'loc' , '.loc' ],
            '::Hdl::Expr::Sig'                 , [ 'type' , "IDENTIFIER", 'phase' , "'sig'",  'value', '.val', 'loc' , '.loc' ],
            '::Hdl::Expr::Const'               , [ 'type' , "IDENTIFIER", 'phase' , "'const'", 'value', '.val', 'loc' , '.loc' ],
            '::Hdl::Expr::Alias'               , [ 'type' , "IDENTIFIER", 'phase', "'alias'", 'loc' , '.loc' ],
            '::Hdl::Expr::Aggregate'           , [ 'type' , "AGGREGATE",  'entries' , '.@_entries()', 'loc' , '.loc' ],
            '::Hdl::Expr::Aggregate::E'        , [ 'type' , "AGGREGATEENTRY",  'tags' , '.@_tags()', 'value', '._val()', 'loc' , '.loc' ],
            '::Hdl::Expr::Agg'                 , [ 'type' , "SIMPLEAGGREGATE",  'entries' , '.@_entries()', 'loc' , '.loc' ],
                        
            '::Hdl::Expr::Assoc'               , [ 'type' , "ASSOCIATION",  'value' , '._val()', 'loc' , '.loc' ],
            
            '::Hdl::Expr::Choice::Others'      , [ 'type' , "OTHERS", 'loc' , '.loc' ],
            '::Hdl::Expr::Choice::Name'        , [ 'type' , "NAME", 'name', '.val', 'loc' , '.loc' ],
            
            '::Hdl::Expr::Assign::Var'         , [ 'type' , "ASSIGNMENTEXPRESSIONVAR", 'left' , '._left()', 'right' , '._right()', 'loc' , '.loc' ],
            '::Hdl::Expr::Assign::Sig'         , [ 'type' , "ASSIGNMENTEXPRESSIONSIG", 'left' , '._left()', 'right' , '.@_right()', 'wait' , '._wait()', 'loc' , '.loc' ],
            '::Hdl::Expr::Range'               , [ 'type' , "RANGEEXPRESSION",         'left' , '._left()', 'right' , '._right()', 'dir', '._dir', 'loc' , '.loc' ],
            '::Hdl::Expr::Member'              , [ 'type' , "MEMBEREXPRESSION",        'object', '._obj()', 'element' , '.elem', 'loc' , '.loc' ],
            '::Hdl::Expr::Index'               , [ 'type' , "INDEXEXPRESSION",         'object', '._obj()', 'indexes' , '.@_idxs()', 'loc' , '.loc' ],
            '::Hdl::Expr::Slice'               , [ 'type' , "SLICEEXPRESSION",         'object', '._obj()', 'range' , '._range()', 'loc' , '.loc' ],
            '::Hdl::Expr::SlicePos'            , [ 'type' , "SLICEPOSEXPRESSION",      'object', '._obj()', 'pos' , '._pos', 'loc' , '.loc' ],
            '::Hdl::Expr::Attribute'           , [ 'type' , "ATTRIBUTE",               'object', '._obj()', 'attribute' , '._attr', 'parameter' , '._param()', 'loc' , '.loc' ],
                                          
            '::Hdl::Stmt::If'                  , [ 'type' , "IFSTATEMENT",             'test' , '._cond()', 'consequence' , '._true()', 'alternate' , '._false()', 'loc' , '.loc' ],
            '::Hdl::Stmt::Block'               , [ 'type' , "BLOCKSTATEMENT",          'body' , '.@_stmts()', 'loc' , '.loc' ],
            '::Hdl::Stmt::Case'                , [ 'type' , "SWITCHSTATEMENT",         'discriminant', '._obj()', 'cases' , '.@_cases()', 'loc' , '.loc' ],
            '::Hdl::Stmt::Case::Val'           , [ 'type' , "SWITCHCASE",              'tests' , '.@_c()', 'consequence', '._b()', 'loc' , '.loc' ],
            '::Hdl::Stmt::Loop'                , [ 'type' , "LOOPSTATEMENT",           'param' , '._param()', 'block' , '._block()', 'loc' , '.loc' ],
            '::Hdl::Stmt::Wait'                , [ 'type' , "WAITSTATEMENT",           'wait' , '._wait()', 'loc' , '.loc'],

            '::Hdl::Expr::Param'               , [ 'type' , "LOOPPARAM",  'name', '.n', 'range', '._range()', 'loc' , '.loc' ],


            '::Hdl::Stmt::While'               , [ 'type' , "WHILESTATEMENT",          'test' , '._test()', 'block' , '._block()', 'loc' , '.loc' ],
            '::Hdl::Stmt::Break'               , [ 'type' , "BREAKSTATEMENT",          'cond' , '._cond()', 'loc' , '.loc' ],
            '::Hdl::Stmt::Return'              , [ 'type' , "RETURNSTATEMENT",          'ret' , '._ret()', 'loc' , '.loc' ],

            '::Hdl::Stmt::Report'              , [ 'type' , "REPORTSTATEMENT"  , 'loc' , '.loc'         ],
            '::Hdl::Stmt::Assert'              , [ 'type' , "ASSERTSTATEMENT"  , 'loc' , '.loc'         ],
            

            '::Hdl::Type::Record'              , [ 'type' , "TYPERECORD", 'name', '.n', 'entries', '.@_entries()', 'loc' , '.loc' ], 
            '::Hdl::Type::Record::Entry'       , [ 'type' , "RECORDENTRY", 'tag', '.n', 'typedef', '._typ()', 'loc' , '.loc' ],
            '::Hdl::Type::Ref'                 , [ 'type' , "TYPEREF", 'typedef', '.n', 'loc' , '.loc' ],
            '::Hdl::Type::Array::Constrained'  , [ 'type' , "TYPECONSTRAINEDARRAY",  'name', '.n', 'range', '._range()', 'typmark', '._typmark' , 'loc' , '.loc' ],
            '::Hdl::Type::Array'               , [ 'type' , "TYPEARRAY", 'name', '.n', 'range', '._range()', 'loc' , '.loc' ],
            '::Hdl::Type::Enum'                , [ 'type' , "TYPEENUM", 'name', '.n', 'values', '["_vals"]', 'loc' , '.loc' ],
            
            '::Hdl::Subprog'                   , [ 'type' , "SUBPROG", 'name', '.n', 'ftyp', '.typ', 'arguments', '.@_iface()', 'decl', '.@_decls()', 'seq', '.@_seq()', 'loc' , '.loc' ],
            '::Hdl::Arg'                       , [ 'type' , "ARG", 'name', '.n', 'mode', '.mode', 'typedef', '._typ()', 'loc' , '.loc' ],
            
            '::Hdl::Decl::Var'                 , [ 'type' , "VAR",  'name', '.n', 'typedef', '._typ()', 'initializer', '._init()', 'loc' , '.loc' ],
            '::Hdl::Decl::Sig'                 , [ 'type' , "SIG",  'name', '.n', 'typedef', '._typ()', 'initializer', '._init()', 'loc' , '.loc' ],
            '::Hdl::Decl::Alias'               , [ 'type' , "ALIAS", 'name', '.n', 'loc' , '.loc' ],
            '::Hdl::Decl::File'                , [ 'type' , "FILE", 'name', '.n', 'loc' , '.loc' ],
            '::Hdl::Decl::Signal'              , [ 'type' , "SIGNAL", 'name', '.n', 'typdef', '._typ()', 'initializer', '._init()', 'loc' , '.loc' ],
            '::Hdl::Decl::Attribute'           , [ 'type' , "ATTR", 'name', '.n', 'typdef', '._typ()', 'loc' , '.loc' ],
            
            
            '::Hdl::Select'                    , [ 'type', "SELECT", 'object', '.object()',  'indexes', '.@indexes()'  ],  # in fold.js
            '::Hdl::Append'                    , [ 'type', "APPEND", 'elements', '.@elements()'  ],  # in fold.js
            
            #'::Hdl::Stmt::ConcAssign::Sig'     , []
           );

foreach my $k (keys (%access)) {
    my $v = $access{$k}; my $n = $v;
    if ($n =~ /^@/) {
        $v =~ s/^\@//;
        $n =~ s/^\@_?//;
        eval(my $js = "sub ${k}::${n} { return \@{\$_[0]{$v}};};\n");
#        print $js;
    }
}

sub esc_str {
    my ($s) = @_;
    $s =~ s/^\s*"//;
    $s =~ s/"\s*$//;
    return $s;
}

my %tok2op = (
              ';'=>    "SEMICOLON",
              ','=>    "COMMA",
              '?'=>    "HOOK",
              ':'=>    "COLON",
              'or'=>   "OR",
              'and'=>   "AND",
              'xor'=>   "XOR",
              '|'=>    "BITWISE_OR",
              '^'=>    "BITWISE_XOR",
              '&'=>    "CONCAT",
              '==='=>  "STRICT_EQ",
              '='=>   "EQ",
              ':='=>    "ASSIGN",
              '/=='=>  "STRICT_NE",
              '/='=>   "NE",
              '<<'=>   "LSH",
              '<='=>   "LE",
              '<'=>    "LT",
              '>>>'=>  "URSH",
              '>>'=>   "RSH",
              '>='=>   "GE",
              '>'=>    "GT",
              '++'=>   "INCREMENT",
              '--'=>   "DECREMENT",
              '+'=>    "PLUS",
              '-'=>    "MINUS",
              '*'=>    "MUL",
              '/'=>    "DIV",
              '%'=>    "MOD",
              '!'=>    "NOT",
              '~'=>    "BITWISE_NOT",
              '.'=>    "DOT",
              '['=>    "LEFT_BRACKET",
              ']'=>    "RIGHT_BRACKET",
              '{'=>    "LEFT_CURLY",
              '}'=>    "RIGHT_CURLY",
              '('=>    "LEFT_PAREN",
              ')'=>    "RIGHT_PAREN"
             );

sub binop {
    my ($s) = @_;
    die ("Unknown op $s\s") if (!defined($tok2op{$s}));
    return $tok2op{$s};
}

my %tok2op_un = (
              'not'=>    "NOT"
          );

sub unop {
    my ($s) = @_;
    die ("Unknown unop $s\n") if (!defined($tok2op_un{$s}));
    return $tok2op_un{$s};
}

# convert js,perl string struct
for (my $mi = 0; $mi +1 < scalar(@mapping); $mi+=2) {
    my ($k,$v) = ($mapping[$mi],$mapping[$mi+1]);
    #my $v = $mapping{$k};
    if ((ref($v) eq "ARRAY"))  {
        my @c = ();
        my @v = @$v;
        foreach $lang ([':','js'],['=>','perl']) {
            my ($s, $n) = @$lang;
            while (scalar(@v)) {
                my $e0 = shift(@v);
                my $v0 = shift(@v);
                if ($v0 =~ /^\.([_a-zA-Z0-9]+)\(\)$/) { # .a()
                    push(@c,"(defined(\$s->{$1}) ? (\"$e0$s\". \$s->{$1}->$n(\@_)) : undef)");
                } elsif ($v0 =~ /^\.\@([_a-zA-Z0-9]+)\(\)$/) { # .@a()
                    push(@c,"(\"$e0$s [\".join(\",\", grep { defined(\$_) } map {  \$_->$n(\@_); } \@{\$\$s{$1}}).\"]\")");
                } elsif ($v0 =~ /^([_a-zA-Z0-9]+)\(\.([_a-zA-Z0-9]+)\)$/) { # x(.a)
                    push(@c,"(defined(\$s->{$2}) ? (\"$e0$s\". $1(\$s->{$2})) : undef)");
                } elsif ($v0 =~ /^\.([_a-zA-Z0-9]+)$/) { # .a
                    push(@c,"(defined(\$s->{$1}) ? (\"$e0$s\\\"\". esc_str(\$s->{$1}).\"\\\"\") : undef)");
                } elsif ($v0 =~ /^\["([_a-zA-Z0-9]+)"\]$/) { # ["a"]
                    push(@c,"(defined(\$s->{$1}) ? (\"$e0${s}[\".join(\",\", map { \"\\\"\". \$_.\"\\\"\" } \@{\$s->{$1}} ).\"]\" ) : undef)");
                } else {
                    #$v0 =~ s/'/\\"/g;
                    push(@c,"(\"$e0$s $v0\")");
                }
            }
            my $snippet = "sub ".$k."::${n}".' { my ($s) = shift(@_);return "{".join(",", grep { defined($_) } ('.join(",",@c).'))."}" };'."\n";
            eval($snippet); if($@) { print "Error: $@ :  $snippet" }
        }
    } else {
        eval(my $js = ::convert_template($k.'::js', $v));
    }
}

# convert internal perl struct
for (my $mi = 0; $mi +1 < scalar(@mapping); $mi+=2) {
    my ($k,$v) = ($mapping[$mi],$mapping[$mi+1]);
    if ((ref($v) eq "ARRAY"))  {
        my @c = ();
        my @v = @$v;
        my ($s, $n) = ('=>', 'data');
        while (scalar(@v)) {
            my $e0 = shift(@v);
            my $v0 = shift(@v);
            if ($v0 =~ /^\.([_a-zA-Z0-9]+)\(\)$/) { # .a()
                push(@c,"(defined(\$s->{$1}) ? (\$\$_r{\"$e0\"} = \$s->{$1}->$n({},\@_)) : undef)");
            } elsif ($v0 =~ /^\.\@([_a-zA-Z0-9]+)\(\)$/) { # .@a()
                push(@c,"(\$\$_r{\"$e0\"} =  [ grep { defined(\$_) } map {  \$_->$n({},\@_); } \@{\$\$s{$1}} ])");
            } elsif ($v0 =~ /^([_a-zA-Z0-9]+)\(\.([_a-zA-Z0-9]+)\)$/) { # x(.a)
                push(@c,"(defined(\$s->{$2}) ? (\$\$_r{\"$e0\"} = $1(\$s->{$2})) : undef)");
            } elsif ($v0 =~ /^\.([_a-zA-Z0-9]+)$/) { # .a
                push(@c,"(defined(\$s->{$1}) ? (\$\$_r{\"$e0\"} = (\$s->{$1})) : undef)");
            } elsif ($v0 =~ /^\["([_a-zA-Z0-9]+)"\]$/) { # ["a"]
                push(@c,"(defined(\$s->{$1}) ? (\$\$_r{\"$e0\"} = [ \@{\$s->{$1}} ]) : undef)");
            } else {
                #$v0 =~ s/'/\\"/g;
                push(@c,"(\$\$_r{\"$e0\"} = $v0)");
            }
        }
        my $snippet = "sub ".$k."::data".' { my ($s) = shift(@_);my ($_r) = shift(@_); '.join(";\n",@c)."; return \$_r; }\n";
        eval($snippet); if($@) { die "Error: $@ : $snippet";  }
    } else {
        eval(my $js = ::convert_template($k.'::data', $v));
    }
}

package Hdl;
sub print_js_out {
    my ($OUT) = @_;
    my @a = ();

    print ("
def = require(\"./def.js\");
eval(def.consts);
");
    print ("function jsout(d) {\n  var o = [], i, j, a;
  function totok(a) {
     return def.tokens[a];
  }
  function tostr(a) {
    if( !/^[0-9]/g.exec(a) ) {
      a = \"\\\"\" + a +\"\\\"\";
    }
    return a;   
  };
  if (d === undefined) {
      return 'undefined';
  }
  switch(d.type) {\n");
    
    for (my $mi = 0; $mi +1 < scalar(@mapping); $mi+=2) {
        my ($k,$v) = ($mapping[$mi],$mapping[$mi+1]);
        if ((ref($v) eq "ARRAY"))  {
            my @c = ();
            my @v = @$v;
            my ($s, $n) = (':', 'data');
            my $e00 = shift(@v);
            my $v00 = shift(@v);
            if ($e00 eq 'type') {
                
                while (scalar(@v)) {
                    my $e0 = shift(@v);
                    my $v0 = shift(@v);
                    if ($v0 =~ /^\.([_a-zA-Z0-9]+)\(\)$/) { # .a()
                        push(@c,"    if (!(d['$e0'] === undefined)) { o.push(\"$e0 : \" + jsout(d['$e0'])); }\n");
                    } elsif ($v0 =~ /^\.\@([_a-zA-Z0-9]+)\(\)$/) { # .@a()
                        push(@c,"    if (!(d['$e0'] === undefined)) { a = []; for (i = 0, j = d['$e0'].length; i < j; i++) { a.push(jsout(d['$e0'][i])) }; o.push('$e0 : [' + a.join(',') + ']'); }\n");
                    } elsif ($v0 =~ /^([_a-zA-Z0-9]+)\(\.([_a-zA-Z0-9]+)\)$/) { # x(.a)
                        push(@c,"    if (!(d['$e0'] === undefined)) { o.push('$e0 :' + totok(d['$e0'])); }\n");
                    } elsif ($v0 =~ /^\.([_a-zA-Z0-9]+)$/) { # .a
                        push(@c,"    if (!(d['$e0'] === undefined)) { o.push('$e0 :' + tostr(d['$e0'])); }\n");
                    } elsif ($v0 =~ /^\["([_a-zA-Z0-9]+)"\]$/) { # ["a"]
                        push(@c,"    if (!(d['$e0'] === undefined)) { a = []; for (i = 0, j = d['$e0'].length; i < j; i++) { a.push(tostr(d['$e0'][i])) }; o.push('$e0 : [' + a.join(',') + ']'); }\n");
                    } else {
                        push(@c,"    if (!(d['$e0'] === undefined)) { o.push('$e0 :' + tostr(d['$e0'])); }\n");
                    }
                }
                print ("  case $v00:\n    o.push('type : $v00');\n");
                foreach my $c (@c) {
                    print $c; 
                }
                print ("    break;\n");
                push(@a, [$v00,\@c]);
            }
        } 
    }
    print ("  }\nreturn '{' + o.join(',') + '}';\n};\n");
    print ("\n/*export jsout function only*/\nexports.jsout = jsout;\n");

}

1;

## Local Variables:
## perl-indent-level: 4
## cperl-indent-level: 4
## indent-tabs-mode:nil
## End:
