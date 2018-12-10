use 5.24.0;
use strict;
use warnings;

my @modules = qw(
    Thread
    Getopt::Long
);

for(@modules) {
    eval "use $_";
    if ($@) {
        warn "Not found : $_" if $@;
    } else {
        say "Found : $_";
    }
}