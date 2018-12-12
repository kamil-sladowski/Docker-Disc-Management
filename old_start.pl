#!/usr/bin/perl
use 5.24.0;
use strict;
use warnings;
# use modules_check;

use Thread;
use Getopt::Long;



sub run_spammer{
    my ($spamming_delay) = @_;
    for(1..5) {
        say "Spammer - start";
        say "Spammer - end";
        sleep $spamming_delay;
    }
}

sub run_cleaner{
    my $cleaning_delay = @_;
    for(1..5) {
        say "Cleaner - start";
        #do
        say "Cleaner  - end";
        sleep $cleaning_delay;
    }
}

# sub start_cleaner_and_spammer{
#     my ($spamming_delay, $cleaning_delay, $timeout) = @_;
#     my $pid = fork();
#     die if not defined $pid;
#     if (not $pid) {
#         run_cleaner($cleaning_delay);
#         exit;
#     }
#     run_spammer($spamming_delay);
#
#     my $finished = wait();
#     say "In parent - PID $$ finished $finished";
# }



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

    # docker -prone
}



sub print_help{
print "This is the simulator, which generates containers in Docker, to eat memory disc size.
At the same time, a second process works, which stops and removes containers that take up more than 1 MB disc space.
There are available two parameters: -e, -c, which define how often each of the processes (allocation and cleaning) should be launched.
The whole program works for 10 second. During this, you can see the results by executing following command on the second console:
docker ...
"

}


#### start_cleaner_and_spammer($eat_disc_factor, $clean_disc_frequency, $timeout);



my $eat_disc_factor     = 1;
my $clean_disc_frequency    = 1;
my $help     = 0;
my $timeout = 10;



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
        start_threads($spamming_delay, $cleaning_delay);
    }
    else{
        print "Incorrect usage!\n";
        print_help();
        die;
    }
}





