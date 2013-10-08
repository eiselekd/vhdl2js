use Data::Dumper;
use Getopt::Long;
use XML::LibXML;
use FindBin qw($Bin);
use lib "$Bin/../lib";
use Cwd;
use Cwd 'abs_path';

my @archs = (); my @entities = ();

Getopt::Long::Configure(qw(bundling));
GetOptions(\%OPT,qw{
d+
quite|q+
verbose|v+
outfile|o=s
log|e=s
gensrc|g=s
genlvl|l=i
genn|n=s
}, @g_more) or usave(\*STDERR);

require "$Bin/hdl.pl";

#$::d=1;

$LOG=\*STDERR;
$OUT=\*STDOUT;
if (defined(my $of = $OPT{'outfile'})) {
    open OUT, ">$of" or die $!;
    $OUT=\*OUT;
}
if (defined(my $lf = $OPT{'log'})) {
    open LOG, ">$lf" or die $!;
    $LOG=\*LOG;
}
if ($OPT{'gensrc'}) {
    Hdl::gensrc($OPT{'gensrc'});
    exit(0);
}
Hdl::gensrc();
$OPT{'genlvl'} if (!defined($OPT{'genlvl'}));

%tokens = ();

map { $tokens{uc($_)} = 1; } (
       Tok_Invalid,  

       Tok_Left_Paren,    
       Tok_Right_Paren,   
       Tok_Left_Bracket,  
       Tok_Right_Bracket, 
       Tok_Colon,         
       Tok_Semi_Colon,    
       Tok_Comma,         
       Tok_Double_Arrow,  
       Tok_Tick,          
       Tok_Double_Star,   
       Tok_Assign,        
       Tok_Bar,           
       Tok_Box,           
       Tok_Dot,           

       Tok_Eof,           
       Tok_Newline,
       Tok_Comment,
       Tok_Character,
       Tok_Identifier,
       Tok_Integer,
       Tok_Real,
       Tok_String,
       Tok_Bit_String,

       Tok_Equal,              
       Tok_Not_Equal,          
       Tok_Less,               
       Tok_Less_Equal,         
       Tok_Greater,            
       Tok_Greater_Equal,      

       Tok_Plus,               
       Tok_Minus,              
       Tok_Ampersand,          

       Tok_And_And,            
       Tok_Bar_Bar,            
       Tok_Left_Curly,         
       Tok_Right_Curly,        
       Tok_Exclam_Mark,        
       Tok_Brack_Star,         
       Tok_Brack_Plus_Brack,   
       Tok_Brack_Arrow,        
       Tok_Brack_Equal,        
       Tok_Bar_Arrow,          
       Tok_Bar_Double_Arrow,   
       Tok_Minus_Greater,      
       Tok_Arobase,            

       Tok_Star,    
       Tok_Slash,   
       Tok_Mod,     
       Tok_Rem,     

       Tok_And,
       Tok_Or,
       Tok_Xor,
       Tok_Nand,
       Tok_Nor,

       Tok_Abs,
       Tok_Not,

       Tok_Access,
       Tok_After,
       Tok_Alias,
       Tok_All,
       Tok_Architecture,
       Tok_Array,
       Tok_Assert,
       Tok_Attribute,

       Tok_Begin,
       Tok_Block,
       Tok_Body,
       Tok_Buffer,
       Tok_Bus,

       Tok_Case,
       Tok_Component,
       Tok_Configuration,
       Tok_Constant,

       Tok_Disconnect,
       Tok_Downto,

       Tok_Else,
       Tok_Elsif,
       Tok_End,
       Tok_Entity,
       Tok_Exit,

       Tok_File,
       Tok_For,
       Tok_Function,

       Tok_Generate,
       Tok_Generic,
       Tok_Guarded,

       Tok_If,
       Tok_In,
       Tok_Inout,
       Tok_Is,

       Tok_Label,
       Tok_Library,
       Tok_Linkage,
       Tok_Loop,

       Tok_Map,

       Tok_New,
       Tok_Next,
       Tok_Null,

       Tok_Of,
       Tok_On,
       Tok_Open,
       Tok_Others,
       Tok_Out,

       Tok_Package,
       Tok_Port,
       Tok_Procedure,
       Tok_Process,

       Tok_Range,
       Tok_Record,
       Tok_Register,
       Tok_Report,
       Tok_Return,

       Tok_Select,
       Tok_Severity,
       Tok_Signal,
       Tok_Subtype,

       Tok_Then,
       Tok_To,
       Tok_Transport,
       Tok_Type,

       Tok_Units,
       Tok_Until,
       Tok_Use,

       Tok_Variable,

       Tok_Wait,
       Tok_When,
       Tok_While,
       Tok_With,

       Tok_Xnor,
       Tok_Group,
       Tok_Impure,
       Tok_Inertial,
       Tok_Literal,
       Tok_Postponed,
       Tok_Pure,
       Tok_Reject,
       Tok_Shared,
       Tok_Unaffected,

       Tok_Sll,
       Tok_Sla,
       Tok_Sra,
       Tok_Srl,
       Tok_Rol,
       Tok_Ror,

       Tok_Protected,

       Tok_Psl_Default,
       Tok_Psl_Clock,
       Tok_Psl_Property,
       Tok_Psl_Sequence,
       Tok_Psl_Endpoint,
       Tok_Psl_Assert,

       Tok_Psl_Const,
       Tok_Psl_Boolean,
       Tok_Inf,

       Tok_Within,
       Tok_Abort,
       Tok_Before,
       Tok_Always,
       Tok_Never,
       Tok_Eventually,
       Tok_Next_A,
       Tok_Next_E,
       Tok_Next_Event,
       Tok_Next_Event_A,
       Tok_Next_Event_E
);

sub readfile {
    my ($in) = @_;
    usage(\*STDOUT) if (length($in) == 0) ;
    open IN, "$in" or die "Reading \"$in\":".$!;
    local $/ = undef;
    $m = <IN>;
    close IN;
    return $m;
}

my @tok = ();
my %files = ();
my @fln = ();
$top = Hdl::Top::new(0,0);
@packageb = ();
@packaged = ();
foreach $f (@ARGV) {
    my $p = XML::LibXML->new();
    my $d = $p->parse_file($f);
    my @tokens = $d->findnodes('/root/tokens/token');
    my $maxlinenr = 0;
    foreach my $t (@tokens) {
        my $tok = $t->getAttribute('tok');
        my $loc = $t->getAttribute('loc');
        die ("nknown token $tok\n") if (!$tokens{$tok});
        die ("Cannot parse loc: $loc\n") if (! ($loc =~ /^(.*):([0-9]+):([0-9]+)$/));
        my ($fn, $linenr, $colnr) = ($1,$2,$3);
        # print ($fn.":".$linenr.":".$colnr."\n");
        my $id = scalar(@tok);
        my $e = {'fn' => $fn, 'ln' => $linenr, 'cn' => $colnr, 'tok' => $tok, 'id' => $id };
        $fln[$linenr] = [[-1]] if (!defined($fln[$linenr]));
        push(@{$fln[$linenr]}, [$id]);
        push(@tok, $e);
        $files{$fn} = 1;
        $maxlinenr = $linenr < $maxlinenr ? $maxlinenr : $linenr;
    }
    my @f = keys %files;
    die ("Unknown filename ") if (scalar(@f) == 0);
    my $f = shift @f;
    my $fm = readfile($f);
    my @fm = split("\n",$fm); my $ln = 1;
    foreach $fm (@fm) {
        $fln[$ln] = [[-1]] if (!defined($fln[$ln]));
        my $l = $fln[$ln];
        $$l[0][1] = $fm; my $beg = 0;
        for ($i = 1; $i < scalar(@$l); $i++) {
            my $id = $$l[$i][0];
            my $col = $tok[$id]{'cn'}-1;
            $$l[$i][1]   = substr($$l[$i-1][1],$col-$beg);
            $$l[$i-1][1] = substr($$l[$i-1][1],0,$col-$beg);
            $beg = $col;
        }
        shift(@$l) if (!length($$l[0][1]));
        $ln++;
    }
    for ($i = 0; $i <= $maxlinenr; $i++) {
        my $f;
        if (defined($f = $fln[$i])) {
            foreach my $l (@$f) {
                print("[".$$l[1]."]");
            }
            print ("\n");
        }
    }
    
    
    my @nodes = $d->findnodes('/root/xml_xml|/root/xml_vhdl');
    (scalar(@nodes) %2 == 0) or die("Uneven number of xml_xml,xml_vhdl nodes\n");
    for (my $i = 0; $i*2+1 < scalar(@nodes); $i++) {
        my $xml  = $nodes[($i*2)];
        my $vhdl = $nodes[($i*2)+1];
        ($vhdl->nodeName eq 'xml_vhdl' && $xml->nodeName eq 'xml_xml') or die ("No xml_xml,xml_vhdl pair\n");
        my @du = $vhdl->findnodes('./design_unit');
        for (my $di = 0; $di < scalar(@du); $di++) {
            my $du = $du[$di];
            my @arch    = $du->findnodes('./architecture_declaration');
            my @ent     = $du->findnodes('./entity_declaration');
            my @pckdecl = $du->findnodes('./package_declaration');
            my @pckbody = $du->findnodes('./package_body');
            for (my $pi = 0; $pi < scalar(@pckdecl); $pi++) {
                my $p = $pckdecl[$pi];
                push(@packaged, my $e = Hdl::PackageDecl::new($top,$p));
                $en = $$e{n};
                print($OUT "/* Package decl $en */\n");
                print($OUT $e->js($OUT));
            }
            for (my $pi = 0; $pi < scalar(@pckbody); $pi++) {
                my $p = $pckbody[$pi];
                push(@packageb, my $e = Hdl::PackageBody::new($top,$p));
                $en = $$e{n};
                print $OUT "/* Package body $en */\n";
                print $OUT $e->js($OUT);
            }
            foreach my $ent (@ent) {
                my $en = $ent->getAttribute('n');
                push(@entities, my $e = Hdl::Entity::new($top,$ent));
                print $OUT $e->js($OUT);
            }
            for (my $ai = 0; $ai < scalar(@arch); $ai++) {
                my $arch = $arch[$ai];
                push(@archs, my $e = Hdl::Arch::new($top,$arch));
                print $OUT $e->js($OUT);
            }
        }
    }
}


## Local Variables:
## perl-indent-level: 4
## cperl-indent-level: 4
## indent-tabs-mode:nil
## End:
