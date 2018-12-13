use strict;
use warnings;

our ( @ISA, @EXPORT );
require Exporter;
@ISA    = qw(Exporter);
@EXPORT = qw/check_modules/;

sub check_modules {
    my @modules = qw(
        Thread
        Getopt::Long
    );

    for (@modules) {
        eval "use $_";
        if ($@) {
            warn "Not found : $_" if $@;
        }
        else {
            print "Found : $_";
        }
    }
}
