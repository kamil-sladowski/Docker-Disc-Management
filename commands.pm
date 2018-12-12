use 5.24.0;
use strict;
use warnings;

our ( @ISA, @EXPORT );
require Exporter;
@ISA    = qw(Exporter);
@EXPORT = qw/execute execute_on/;

# sub get_commands {
    my %commands = ();
    my @ps = split(/ /, "docker ps");
    my @logs = split(/ /, "docker logs");
    my @stats = split(/ /, "docker stats");
    my @system_usage = split(/ /, "docker system df");
    my @system_usage_full = split(/ /, "docker system df -v");
    my @run_ubuntu = split(/ /, "docker run -itd ubuntu");
    my @delete_dangling_volumes = ("docker", "volume", "rm", "$(docker volume ls -qf dangling=true)");
    my @delete_dangling_images = ("docker", "rmi", "$(docker images -qf dangling=true)");
    my @cleanup_all_unused = split(/ /, "docker system prune -a");

    my @build_spammer_image = split(/ /, "docker build -t spammer .");
    my @run_spamming_container= split(/ /, "docker run -itd spammer");
    my @stop = split(/ /, "docker stop");
    my @kill = split(/ /, "docker kill");
    my @rm = split(/ /, "docker rm");
    my @memory_usage = ("docker", "stats", "--all", "--format", "table {{.Container}}\t{{.CPUPerc}}\t{{.MemUsage}}", "--no-stream");

    $commands{ps} = \@ps;
    $commands{logs} = \@logs;
    $commands{stats} = \@stats;
    $commands{system_usage} = \@system_usage;
    $commands{system_usage_full} = \@system_usage_full;
    $commands{run_ubuntu} = \@run_ubuntu;
    $commands{delete_dangling_volumes} = \@delete_dangling_volumes;
    $commands{delete_dangling_images} = \@delete_dangling_images;
    $commands{cleanup_all_unused} = \@cleanup_all_unused;
    $commands{build_spammer_image} = \@build_spammer_image;
    $commands{run_spamming_container} = \@run_spamming_container;
    $commands{memory_usage} = \@memory_usage;
    $commands{stop} = \@stop;
    $commands{kill} = \@kill;
    $commands{rm} = \@rm;

#     return %commands;
# }


sub execute {
    my ($key) = @_;
    print join(", ", @{$commands{$key}} ) . "\n";
    run [@{$commands{$key}}], ">", \my $stdout;
    return $stdout;
}

sub execute_on {
    my ($container_id, $key) = @_;
    my @cmd = (@{$commands{$key}}, $container_id);
    run [@cmd], ">", \my $stdout;
    return $stdout;
}
