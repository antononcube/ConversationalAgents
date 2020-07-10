use Test;
use lib '../lib';
use lib './lib';
use QuantileRegressionWorkflows::Grammar;

plan 6;

# Shortcut
my $pQRMONCOMMAND = QuantileRegressionWorkflows::Grammar::WorkflowCommand;

#-----------------------------------------------------------
# Find anomalies
#-----------------------------------------------------------

ok $pQRMONCOMMAND.parse('compute anomalies with threshold 0.9'),
        'compute anomalies with threshold 0.9';

ok $pQRMONCOMMAND.parse('compute anomalies by residuals with the threshold 5'),
        'compute anomalies by residuals with the threshold 5';

ok $pQRMONCOMMAND.parse('find anomalies by the SPLUS outlier identifier'),
        'find anomalies by the SPLUS outlier identifier';

ok $pQRMONCOMMAND.parse('find anomalies with the outlier identifier Hampel'),
        'find anomalies with the outlier identifier Hampel';

ok $pQRMONCOMMAND.parse('find anomalies by residuals using outlier identifier Hampel'),
        'find anomalies by residuals using outlier identifier Hampel';

ok $pQRMONCOMMAND.parse('find anomalies by residuals using the SPLUS outlier identifier'),
        'find anomalies by residuals using the SPLUS outlier identifier';

done-testing;
