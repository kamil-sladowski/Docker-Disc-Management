#!/usr/bin/perl
#
# Kamil Sladowski
#
# Projekt zaliczeniowy w perla
#


#use 5.26.1;
use strict;
use warnings;
use File::Basename;
use lib dirname (__FILE__);
#use Cwd qw(abs_path);
#use FindBin;
#use lib $FindBin::Bin;

use modules;
use commands;
use container;
use Getopt::Long;
use Thread;

sub print_help{
print "This is the simulator, which generates containers in Docker, to eat memory disc size.
At the same time, a second process works, which stops and removes containers that take up more than 1 MB disc space.

First of all navigate to directory with script and execute 
# docker build -t spammer .
Script will do it manually if doesn't find, but in this case you will not be able to track the download speed.

There are available two parameters: --eat, --clean, which define how often each of the processes (allocation and cleaning) should be launched.
Also you can use --prune to remove all unused containers, networks, images (both dangling and unreferenced), and optionally, volumes.
The difference between --clean and --prune is that first kill demanding continers, the second deletes unused resources.


The whole program works for about 100 second. 
During this, you can monitor the status of disc usage, by running script with --check flag, on the second console,
or manuall by executing following command:
# docker system df -v


Usage:
--help, --check, --eat [1...5],  --clean [1...5], --prune
"
}


my $eat_disc_factor = 1;
my $clean_disc_frequency = 1;
my $help = 0;
my $check = 0;
my $prune = 0;
my $timeout = 100;



GetOptions(
    'eat=s'    => \$eat_disc_factor,
    'clean=i'     => \$clean_disc_frequency,
    'help!'     => \$help,
    'check!'     => \$check,
    'prune!'     => \$prune,
) or die "Incorrect usage!\n";

if( $help ) {
    print_help();
} elsif ($check){
    print execute("system_usage_full");
} elsif($prune){
    print "prune \n";
    execute("cleanup_all_unused");
} else {
    if(($eat_disc_factor ~~ [ 1, 2, 3, 4, 5]) && ($clean_disc_frequency ~~ [ 1, 2, 3, 4, 5])){
        print "correct patameters \n";
        $eat_disc_factor = 6 - $eat_disc_factor;
        $clean_disc_frequency = 6 - $clean_disc_frequency;
        my $cleaning_delay = $clean_disc_frequency/$timeout;
        my $spamming_delay = $eat_disc_factor/$timeout;
        print "clean parameter: " . $cleaning_delay . "\n";
        print "eat parameter: " . $spamming_delay . "\n";
        build_spammer_img();
        start_threads($spamming_delay, $cleaning_delay);
    }
    else{
        print "Incorrect usage!\n";
        print_help();
        die;
    }
}


