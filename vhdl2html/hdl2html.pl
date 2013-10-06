use Data::Dumper;
use Getopt::Long;
use FindBin qw($Bin);
use lib "$Bin/../lib";
use Cwd;
use Cwd 'abs_path';

$RE_balanced_brackets =          qr'(?:[\{]((?:(?>[^\{\}]+)|(??{$RE_balanced_brackets}))*)[\}])';
$RE_balanced_squarebrackets =    qr'(?:[\[]((?:(?>[^\[\]]+)|(??{$RE_balanced_squarebrackets}))*)[\]])';
$RE_balanced_smothbrackets =     qr'(?:[\(]((?:(?>[^\(\)]+)|(??{$RE_balanced_smothbrackets}))*)[\)])';
$RE_comment_Cpp =             qr{(?:\/\*(?:(?!\*\/)[\s\S])*\*\/|\/\/[^\n]*\n)};
$adaid =                      qr{(?:[a-zA-Z_][a-zA-Z_0-9]*)};
$WHITESPACE_RE = q/[\x20\x09\x0a\x0d]*/;

sub readfile {
    my ($in) = @_;
    usage(\*STDOUT) if (length($in) == 0) ;
    open IN, "$in" or die "Reading \"$in\":".$!;
    local $/ = undef;
    $m = <IN>;
    close IN;
    return $m;
}

Getopt::Long::Configure(qw(bundling));
GetOptions(\%OPT,qw{
d+
quite|q+
verbose|v+
ast|a=s
outfile|o=s
log|e=s
gensrc|g=s
genlvl|l=i
genn|n=s
}, @g_more) or usave(\*STDERR);

die ("AST not given usa the --ast=<file> switch") if (!defined($OPT{'ast'}));
require "$Bin/hdltok.pl";
require "$Bin/TinyJS.pl";

$d = $OPT{'d'} || 0;

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
$OPT{'genlvl'} if (!defined($OPT{'genlvl'}));

@ast = split(",",$OPT{'ast'});
foreach my $ast (@ast) {
    $a = readfile($ast);
    parse_js(\$a);
}



# foreach $f (@ARGV) {
#     print("Processing file $f\n");
#     #@lines = hdltokenize($f);
    
    
# }

sub parse_arch {
    my ($b) = @_;
    $b =~ s/^\s*\{\s*//s; $b =~ s/\s*\}\s*$//s;
    if ($b =~ m/this._gen = $RE_balanced_brackets/ms) {
        my ($j) = ("{".$1."}");
        
        #print(":.......:\n".$j."\n:.......:\n");
        
        my $js = JSON::TinyJS->new();
        $js->decode($j);
    } 
    if ($b =~ m/this._prt = $RE_balanced_brackets/ms) {
        my ($j) = ("{".$1."}");
        my $js = JSON::TinyJS->new();
        $js->decode($j);
    }
    
    if ($b =~ m/this._seq = $RE_balanced_brackets/ms) {
        my ($j) = ("{".$1."}");
        my $js = JSON::TinyJS->new();
        $js->decode($j);
    }
    
    
    #print ($b);

}

sub parse_entity {
    my ($b) = @_;
    $b =~ s/^\s*\{\s*//s; $b =~ s/\s*\}\s*$//s;
    if ($b =~ m/this._gen = $RE_balanced_brackets/ms) {
        my ($j) = ("{".$1."}");
        
        #print(":.......:\n".$j."\n:.......:\n");
        
        my $js = JSON::TinyJS->new();
        $js->decode($j);
    } 
    if ($b =~ m/this._prt = $RE_balanced_brackets/ms) {
        my ($j) = ("{".$1."}");
        my $js = JSON::TinyJS->new();
        $js->decode($j);
    }
    
    
    #print ($b);
}

sub parse_packagedecl {
}

sub parse_js {
    my ($m) = @_;
    
    while(pos($$m) < length($$m)) {
        $$m =~ m/\G\s*/gc;        
        #print("---- '".substr($$m,pos($$m),32)."'\n");
        if ($$m =~ m/\G$RE_comment_Cpp/gcms) {
            print("Parse comment: '$&'\n");
        } elsif ($$m =~ m/\Gfunction\s+_t_entity_(${adaid})\s*$RE_balanced_smothbrackets\s*$RE_balanced_brackets/gcms) { #
            my ($n,$a,$b) = ($1,$2,$3);
            #print("Parse entity $n,$a,$b: '$&'\n");
            parse_entity($b);
        } elsif ($$m =~ m/\Gfunction\s+_t_arch_(${adaid})\s*$RE_balanced_smothbrackets\s*$RE_balanced_brackets/gcms) {
            my ($n,$a,$b) = ($1,$2,$3);
            #print("Parse arch: '$&'\n");
            parse_arch($b);
            
        } elsif ($$m =~ m/\Gfunction\s+_t_pdecl_((?:${adaid})?)\s*$RE_balanced_smothbrackets\s*$RE_balanced_brackets/gcms) {
            my ($n,$a,$b) = ($1,$2,$3);
            #print("Parse package '$&'\n");
            parse_packagedecl($b);
            
        } else {
            die("Cannot parse '".substr($$m,pos($$m),32)."'\n");
        }
        $$m =~ m/\G\s*/gc;
    }
    
}

## Local Variables:
## perl-indent-level: 4
## cperl-indent-level: 4
## indent-tabs-mode:nil
## End:
