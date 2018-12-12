use 5.24.0;
use strict;
use warnings;

our ( @ISA, @EXPORT );
require Exporter;
@ISA    = qw(Exporter);
@EXPORT = qw/build_spammer_img run_spamming_container is_container_eat_to_much /;

sub build_spammer_img{
    execute("build_spammer_image");
}

sub run_spamming_container{
    my $container_id = execute("run_spamming_container");
    $container_id = substr( $container_id, 0, 12 );
    print $container_id . "\n";
    return $container_id;
}

sub get_running_containers{
    my @containers_ids = ();
    my $output = execute("ps");
    print $output;
    my @lines = split "\n", $output;
    foreach my $line (@lines){
        if (index($line, "CONTAINER ID") == -1) {
            print "LINE " . $line . "\n";
            my @container_record = split ' ', $line;
            @containers_ids.push($container_record[0]);
            print "added $container_record[0] \n";
        }
    }
    # if(scalar @match != 0){
    return @containers_ids;
    # }
}


sub is_container_eat_to_much{
    my ($container_id) = @_;
    print "container_id  " . $container_id ;
    my $output = execute("memory_usage");
    print $output;
    my @lines = split "\n", $output;
    foreach my $line (@lines){
        if (index($line, $container_id) != -1) {
            print "\n\n" . $container_id . " in " . $line . "\n";
            my @disc_usage = split ' ', $line;
            my $size =  $disc_usage[2];
            my $unit = $disc_usage[3];
            if ("MiB" eq $unit || "GiB" eq $unit ){
                return 1;
            }
            last;
        }
    }
    return 0;
}