use Test;
use lib '../lib';
use lib './lib';
use QuantileRegressionWorkflows::Grammar;

plan 22;

# Shortcut
my $pQRMONCOMMAND = QuantileRegressionWorkflows::Grammar::WorkflowCommmand;

#-----------------------------------------------------------
# Quantile Regression
#-----------------------------------------------------------

ok $pQRMONCOMMAND.parse('compute quantile regression'),
        'compute quantile regression';

ok $pQRMONCOMMAND.parse('compute and display QuantileRegression'),
        'compute and display QuantileRegression';

ok $pQRMONCOMMAND.parse('compute a quantile regression fit'),
        'compute a quantile regression fit';

ok $pQRMONCOMMAND.parse('compute quantile regression'),
        'compute quantile regression';

ok $pQRMONCOMMAND.parse('compute quantile regression with 0.1 0.2 0.5 0.7 0.9'),
        'compute quantile regression with 0.1 0.2 0.5 0.7 0.9';

ok $pQRMONCOMMAND.parse('calculate quantile regression with probabilities 0.5 and 0.75'),
        'calculate quantile regression with probabilities 0.5 and 0.75';

ok $pQRMONCOMMAND.parse('compute quantile regression with probabilities from 0. to 1'),
        'compute quantile regression with probabilities from 0. to 1';

ok $pQRMONCOMMAND.parse('compute quantile regression for the probabilities 0.1 and 0.9'),
        'compute quantile regression for the probabilities 0.1 and 0.9';

ok $pQRMONCOMMAND.parse('compute quantile regression for the probabilities 0.1 0.2 0.5 0.7 0.9'),
        'compute quantile regression for the probabilities 0.1 0.2 0.5 0.7 0.9';

ok $pQRMONCOMMAND.parse('compute quantile regression with 0.1 0.2 0.5 0.7 0.9'),
        'compute quantile regression with 0.1 0.2 0.5 0.7 0.9';

ok $pQRMONCOMMAND.parse('compute quantile regression using the 0.5 probability'),
        'compute quantile regression using the 0.5 probability';

ok $pQRMONCOMMAND.parse('compute quantile regression using probability 0.5'),
        'compute quantile regression using probability 0.5';

ok $pQRMONCOMMAND.parse('compute quantile regression with 0.1, 0.2, 0.5, 0.7, and 0.9'),
        'compute quantile regression with 0.1, 0.2, 0.5, 0.7, and 0.9';

ok $pQRMONCOMMAND.parse('compute quantile regression with probabilities 0.1, 0.2, 0.5, 0.7, and 0.9'),
        'compute quantile regression with probabilities 0.1, 0.2, 0.5, 0.7, and 0.9';

ok $pQRMONCOMMAND.parse('compute quantile regression with the probability list 0.1, 0.2, 0.5, 0.7, 0.9'),
        'compute quantile regression with the probability list 0.1, 0.2, 0.5, 0.7, 0.9';

ok $pQRMONCOMMAND.parse('compute quantile regression with the knots 0.1, 0.2, 0.5, 0.7, 0.9'),
        'compute quantile regression with the knots 0.1, 0.2, 0.5, 0.7, 0.9';

ok $pQRMONCOMMAND.parse('compute QuantileRegression using probabilities from 0.1 to 0.9 step 0.1'),
        'compute QuantileRegression using probabilities from 0.1 to 0.9 step 0.1';

ok $pQRMONCOMMAND.parse('compute quantile regression using 0.5 and 10 knots'),
        'compute quantile regression using 0.5 and 10 knots';

ok $pQRMONCOMMAND.parse('compute quantile regression with 12 knots and using the probability 0.5'),
        'compute quantile regression with 12 knots and using the probability 0.5';

ok $pQRMONCOMMAND.parse('compute quantile regression with 12 knots, using the probability 0.5 and interpolation order 3'),
        'compute quantile regression with 12 knots, using the probability 0.5 and interpolation order 3';

ok $pQRMONCOMMAND.parse('compute quantile regression with the knots from 0.1 to 20.2 step 0.5, using the probability 0.25, 0.5, 0.75 and interpolation order 3'),
        'compute quantile regression with the knots from 0.1 to 20.2 step 0.5, using the probability 0.25, 0.5, 0.75 and interpolation order 3';

ok $pQRMONCOMMAND.parse('compute quantile regression using the probabilities 0.25, 0.5, 0.75 and knots from 0.1 to 20.2 step 0.5 and interpolation order 3'),
        'compute quantile regression using the probabilities 0.25, 0.5, 0.75 and knots from 0.1 to 20.2 step 0.5 and interpolation order 3';

done-testing;
