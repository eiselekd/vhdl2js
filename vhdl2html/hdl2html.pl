use Data::Dumper;
use Getopt::Long;
use FindBin qw($Bin);
use lib "$Bin/../lib";
use Cwd;
use Cwd 'abs_path';

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

foreach $f (@ARGV) {
    print("Processing file $f\n");
    @lines = hdltokenize($f);
    

    
}

## Local Variables:
## perl-indent-level: 4
## cperl-indent-level: 4
## indent-tabs-mode:nil
## End:
