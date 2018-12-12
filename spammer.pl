#!/usr/bin/perl
use 5.010;
use strict;
use warnings;
use Time::HiRes 'usleep';

sub spam_to_file{
    my $filename = 'tmp.txt';

    unless(open FILE, '>'.$filename) {
    die "\nUnable to create $filename\n";
    }
    for(my $i=0; $i <= 200000 ; $i++) { # 104000 na minute - 3.2 MB
        open(my $fh, '>>', $filename) or die "Could not open file '$filename' $!";
        print $fh "  " . localtime() . $i . "\n";
        close $fh;
        usleep(500);
    }
}
spam_to_file();
