use Test;
use lib '../lib';
use lib './lib';
use QuantileRegressionWorkflows::Grammar;

plan 7;

# Shortcut
my $pQRMONCOMMAND = QuantileRegressionWorkflows::Grammar::WorkflowCommand;

#-----------------------------------------------------------
# Data statistics
#-----------------------------------------------------------

ok $pQRMONCOMMAND.parse('summarize data'),
        'summarize data';

ok $pQRMONCOMMAND.parse('summarize the data'),
        'summarize the data';

ok $pQRMONCOMMAND.parse('show data summary'),
        'show data summary';

ok $pQRMONCOMMAND.parse('cross tabulate'),
        'cross tabulate';

ok $pQRMONCOMMAND.parse('cross tabulate the data'),
        'cross tabulate the data';

ok $pQRMONCOMMAND.parse('cross tabulate time variable vs dependent variable'),
        'cross tabulate time variable vs dependent variable';

ok $pQRMONCOMMAND.parse('cross tabulate the time variable vs the dependent'),
        'cross tabulate the time variable vs the dependent';

done-testing;
