use Test;
use lib '../lib';
use lib './lib';
use QuantileRegressionWorkflows::Grammar;

plan 9;

# Shortcut
my $pQRMONCOMMAND = QuantileRegressionWorkflows::Grammar::WorkflowCommand;

#-----------------------------------------------------------
# Quantile Regression fit
#-----------------------------------------------------------

ok $pQRMONCOMMAND.parse('compute quantile regression fit'),
        'compute quantile regression fit';

ok $pQRMONCOMMAND.parse('compute a quantile regression fit'),
        'compute a quantile regression fit';

ok $pQRMONCOMMAND.parse('compute least squares regression'),
        'compute least squares regression';

ok $pQRMONCOMMAND.parse('compute least squares fit'),
        'compute least squares fit';

ok $pQRMONCOMMAND.parse('compute quantile regression fit with functions Table[Sin[x],{x,0,10,2}]'),
        'compute quantile regression fit with functions Table[Sin[x],{x,0,10,2}]';

ok $pQRMONCOMMAND.parse('compute quantile regression fit with 0.1 0.2 0.5 0.7 0.9'),
        'compute quantile regression fit with 0.1 0.2 0.5 0.7 0.9';

ok $pQRMONCOMMAND.parse('compute quantile regression fit with functions Table[Sin[x],{x,0,10,2}] and proabilities 0.1, 0.2, and 0.6'),
        'compute quantile regression fit with functions Table[Sin[x],{x,0,10,2}] and proabilities 0.1, 0.2, and 0.6';

ok $pQRMONCOMMAND.parse('compute quantile regression fit with quantiles 0.1, 0.2, and 0.6 and functions Table[Sin[x],{x,0,10,2}]'),
        'compute quantile regression fit with quantiles 0.1, 0.2, and 0.6 and functions Table[Sin[x],{x,0,10,2}]';

ok $pQRMONCOMMAND.parse('compute QuantileRegression using probabilities from 0.1 to 0.9 step 0.1'),
        'compute QuantileRegression using probabilities from 0.1 to 0.9 step 0.1';

done-testing;
