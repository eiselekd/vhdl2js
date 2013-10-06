use Data::Dumper;
use Carp;

$RE_comment_Cpp =                q{(?:\/\*(?:(?!\*\/)[\s\S])*\*\/|\/\/[^\n]*\n)};
$RE_string =                     qr{"((?:\\.|[^\\"])*)"};
$RE_string_one =                 qr{'((?:\\.|[^\\'])*)'}; #"
$c_id =                          qr{(?:[a-zA-Z_][a-zA-Z_0-9]*)};


sub hdltokenize {
    my ($f) = @_; my @l = ();
    my $m = readfile($f);
    while(pos($m) < length($m)) {
        
    }
    return @l;
}

sub dobless {
    my ($ret, $c) = @_;
    $ret = bless $ret, $c;
    return $ret;
}

#my $r = dobless({}, 'hdltok::line');
    
package hdltok;


package hdltok::line;


package hdltok::tok;


1;

## Local Variables:
## perl-indent-level: 4
## cperl-indent-level: 4
## indent-tabs-mode:nil
## End:
