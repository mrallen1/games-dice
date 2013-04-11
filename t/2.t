use strict;
use warnings;

use Test::More 0.96;

use Games::Dice qw(roll);

my $trials = 100_000;

# probability of 18 in 3d6 die roll
# success = 1/6 * 1/6 * 1/6 = 1/216
# failure = 215/216
my $mean = (1.0/216.0)*$trials;
diag "expected number of 18s in $trials 3d6 rolls: $mean\n";

my $variance = $mean * (215.0/216.0);
my $std_dev = sqrt($variance);
diag "standard deviation: $std_dev\n";

sub run_trial {
    my %dist;
    for ( 1 .. $trials ) {
        my $roll = roll '3d6';
        $dist{$roll}++;
    }
    return $dist{18};
}

my $success;
my $stingy;
my $stingy_bound = $mean - $std_dev;
my $generous;
my $generous_bound = $mean + $std_dev;
for ( 1 .. 100 ) {
    my $result = run_trial();
    my $dev = abs($result - $mean);
    $stingy++ if $result < $stingy_bound;
    $generous++ if $result > $generous_bound;
    $success++ if $dev <= $std_dev;
}

diag "$success out of 100 trials within std deviation\n";
diag "stingy bias: $stingy\n";
diag "generous bias: $generous\n";

ok($success >= 70, "70% of runs within std deviation");
done_testing;
