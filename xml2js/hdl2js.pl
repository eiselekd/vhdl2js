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

$top = Hdl::Top::new(0,0);
@packageb = ();
@packaged = ();
foreach $f (@ARGV) {
    my $p = XML::LibXML->new();
    my $d = $p->parse_file($f);
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
