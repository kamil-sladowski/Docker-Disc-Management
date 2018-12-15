use strict;
use warnings;
use Thread;

our ( @ISA, @EXPORT );
require Exporter;
@ISA    = qw(Exporter);
@EXPORT = qw/build_spammer_img run_spamming_container is_container_eat_to_much start_threads /;

sub build_spammer_img{
    print "INFO: Building image. It may take a few minutes... \n";
    execute("build_spammer_image");
    print "INFO: Image created. \n";
}

sub run_spamming_container{
    my $container_id = execute("run_spamming_container");
    $container_id = substr( $container_id, 0, 12 );
    print "INFO: Started container " . $container_id . "\n";
    return $container_id;
}

sub get_running_containers{
    my @containers_ids = ();
    my $output = execute("ps");
    my @lines = split "\n", $output;
    foreach my $line (@lines){
        if (index($line, "CONTAINER ID") == -1) {
            my @container_record = split / /, $line;
            push(@containers_ids, $container_record[0]);
        }
    }
    return @containers_ids;
}

sub get_exited_containers{
    my @containers_ids = ();
    my $output = execute("ps_exited");

    my @lines = split "\n", $output;
    foreach my $line (@lines){
            my @container_record = split / /, $line;
            push(@containers_ids, $container_record[0]);
    }
    return @containers_ids;
}


sub is_container_eat_to_much{
    my ($container_id) = @_;
    my $output = execute("memory_usage");
    my @lines = split "\n", $output;
    foreach my $line (@lines){
        if (index($line, $container_id) != -1) {
            my @disc_usage = split ' ', $line;
            my $size =  $disc_usage[2];


            if ("MiB" eq $unit || "GiB" eq $unit || "MB" eq $unit || "GB" eq $unit ){
                print "INFO: Container " . $container_id . " eat to much resources\n";
                return 1;
            }
            last;
        }
    }
    return 0;
}


sub run_spammer{
    my ($spamming_delay) = @_;
    for(1..5) {
        print "INFO: Spammer start \n";
        run_spamming_container();
        print "INFO: Spammer done \n";
        sleep $spamming_delay;
    }
}


sub rm_exited_containers{
	my @containers_ids = ();
        @containers_ids = get_exited_containers();
        foreach my $container_id (@containers_ids) {       
                print "INFO: Removing exited container " . $container_id . "...\n";
                execute_on($container_id, "rm");
                print "INFO: Container " . $container_id . " stopped.\n";
        }  
}


sub run_cleaner{
    my $cleaning_delay = @_;
    
    for(1..5) {
	my @containers_ids = ();
        print "INFO: Cleaner started \n";
        @containers_ids = get_running_containers();
        foreach my $container_id (@containers_ids) {
            if (is_container_eat_to_much($container_id)) {
                print "INFO: Killing container " . $container_id . "...\n";
                execute_on($container_id, "stop");
                execute_on($container_id, "rm");
                print "INFO: Container " . $container_id . " stopped.\n";
            } else {print "INFO: container " . $container_id . " is OK.\n";}
        }
        print "INFO: Cleaner done \n";
        sleep $cleaning_delay + 5;
    }
}

sub start_threads {
    my ($spamming_delay, $cleaning_delay) = @_;
    my $t1 = Thread->new(\&run_spammer, $spamming_delay);
    my $t2 = Thread->new(\&run_cleaner, $cleaning_delay);

    $t1->join();
    $t2->join();  
    rm_exited_containers();
    print "INFO: DONE \n";
}
