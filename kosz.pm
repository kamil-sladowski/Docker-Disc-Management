use strict;
use warnings;
#
# sub run_spammer{
#     say "Spammer - start";
#        sleep 2;
#        say "Spammer - end";
# }
#
# sub run_cleaner{
#     say "Cleaner - start";
#     sleep 2;
#     say "Cleaner  - end";
# }
#
# sub start_cleaner_and_spammer{
#
#     my $pid = fork();
#     die if not defined $pid;
#     if (not $pid) {
#        run_spammer();
#        exit;
#     }
#
#     run_cleaner();
#
#     my $finished = wait();
#     say "In parent - PID $$ finished $finished";
# }


# sub get_container_logs{
#     my ($container_id) = @_;
#     my @cmd = (@{$commands{logs}}, $container_id);
#     my $log_output = execute(@cmd);
#     return $log_output;
# }

