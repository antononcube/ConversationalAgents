use Test;
use lib '../lib';
use lib './lib';
use QuantileRegressionWorkflows::Grammar;

plan 4;

# Shortcut
my $pQRMONCOMMAND = QuantileRegressionWorkflows::Grammar::WorkflowCommmand;

#-----------------------------------------------------------
# Error plots
#-----------------------------------------------------------

ok $pQRMONCOMMAND.parse('display errors plot'),
        'display errors plots';

ok $pQRMONCOMMAND.parse('show the relative errors plots'),
        'show the relative errors plots';

ok $pQRMONCOMMAND.parse('plot errors'),
        'plot errors';

ok $pQRMONCOMMAND.parse('plot absolute errors'),
        'plot absolute errors';

done-testing;
