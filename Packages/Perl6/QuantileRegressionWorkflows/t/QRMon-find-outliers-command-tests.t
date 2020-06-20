use Test;
use lib '../lib';
use lib './lib';
use QuantileRegressionWorkflows::Grammar;

plan 7;

# Shortcut
my $pQRMONCOMMAND = QuantileRegressionWorkflows::Grammar::WorkflowCommmand;

#-----------------------------------------------------------
# Find outliers
#-----------------------------------------------------------

ok $pQRMONCOMMAND.parse('find outliers'),
        'find outliers';

ok $pQRMONCOMMAND.parse('find top outliers'),
        'find top outliers';

ok $pQRMONCOMMAND.parse('find bottom outliers'),
        'find bottom outliers';

ok $pQRMONCOMMAND.parse('find bottom outliers with 0.1'),
        'find bottom outliers with 0.1';

ok $pQRMONCOMMAND.parse('find and show bottom outliers with 0.01'),
        'find and show bottom outliers with 0.01';

ok $pQRMONCOMMAND.parse('compute outliers with probabilities 0.1 and 0.9'),
        'compute outliers with probabilities 0.1 and 0.9';

ok $pQRMONCOMMAND.parse('compute outliers with 0.1 0.2 0.5 0.7 0.9'),
        'compute outliers with 0.1 0.2 0.5 0.7 0.9';

done-testing;
