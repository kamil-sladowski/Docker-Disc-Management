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
There are available two parameters: -e, -c, which define how often each of the processes (allocation and cleaning) should be launched.
Usage:

The whole program works for about 100 second. During this, you can see the results by executing following command on the second console:
docker system df -v

--help, --eat [1...5],  --clean [1...5]
"
}

sub run_spammer{
    my ($spamming_delay) = @_;
    for(1..5) {
        print "Spammer - start";
        # my $container_id = run_spamming_container();
        run_spamming_container();
        print "Spammer - end";
        sleep $spamming_delay;
    }
}

sub run_cleaner{
    my $cleaning_delay = @_;
    my @containers_ids = ();
    for(1..5) {
        print "Cleaner - start";
        @containers_ids = get_running_containers();
        foreach my $container_id (@containers_ids) {
            if (is_container_eat_to_much($container_id)) {
                execute_on($container_id, "stop");
                execute_on($container_id, "rm");
            }
        }
        print "Cleaner  - end";
        sleep $cleaning_delay;
    }
}

sub start_threads {
    my ($spamming_delay, $cleaning_delay) = @_;
    my $t1 = Thread->new(\&run_spammer, $spamming_delay);
    my $t2 = Thread->new(\&run_cleaner, $cleaning_delay);


    # for(1..10){
    print "This is the main program\n";
    # }

    print "Waiting for thread now\n";
    my $stuff1 = $t1->join();
    my $stuff2 = $t2->join();
    print "After join \n";

    execute("cleanup_all_unused");
}
my $eat_disc_factor = 1;
my $clean_disc_frequency = 1;
my $help     = 0;
my $timeout = 100;



GetOptions(
    'eat=s'    => \$eat_disc_factor,
    'clean=i'     => \$clean_disc_frequency,
    'help!'     => \$help,
) or die "Incorrect usage!\n";

if( $help ) {
    print_help();
} else {
    if(($eat_disc_factor ~~ [ 1, 2, 3, 4, 5]) && ($clean_disc_frequency ~~ [ 1, 2, 3, 4, 5])){
        print "correct patameters \n";
        $eat_disc_factor = 6 - $eat_disc_factor;
        $clean_disc_frequency = 6 - $clean_disc_frequency;
        my $cleaning_delay = $clean_disc_frequency/$timeout;
        my $spamming_delay = $eat_disc_factor/$timeout;
        print "clean: " . $cleaning_delay . "\n";
        print "eat: " . $spamming_delay . "\n";
        build_spammer_img();
        start_threads($spamming_delay, $cleaning_delay);
    }
    else{
        print "Incorrect usage!\n";
        print_help();
        die;
    }
}




# my $output = execute("system_usage");
# print $output;
#





# start_cleaner_and_spammer($eat_disc_factor, $clean_disc_frequency);
