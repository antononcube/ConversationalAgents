use Test;
use lib '../lib';
use lib './lib';
use QuantileRegressionWorkflows::Grammar;

plan 6;

# Shortcut
my $pQRMONCOMMAND = QuantileRegressionWorkflows::Grammar::WorkflowCommmand;

#-----------------------------------------------------------
# Find anomalies
#-----------------------------------------------------------

# compute anomalies with threshold 0.9
ok $pQRMONCOMMAND.parse('изчсили аномалии с праг 0.9'),
        'изчсили аномалии с праг 0.9';

# compute anomalies by residuals with the threshold 5
ok $pQRMONCOMMAND.parse('изчсили аномалии чрез остатъци с праг 0.9'),
        'изчсили аномалии чрез остатъци с праг 0.9';

# find anomalies by the SPLUS outlier identifier
ok $pQRMONCOMMAND.parse('намери аномалии със идентификатора SPLUS'),
        'намери аномалии със идентификатора SPLUS';

# find anomalies with the outlier identifier Hampel
ok $pQRMONCOMMAND.parse('намери аномалии със идентификатора Хампел'),
        'намери аномалии със идентификатора Хампел';

# find anomalies by residuals using outlier identifier Hampel'
ok $pQRMONCOMMAND.parse('намери аномалии чрез остатъци ползвайки идентификатор Хампел'),
        'намери аномалии чрез остатъци ползвайки идентификатор Хампел';

# find anomalies by residuals using the SPLUS outlier identifier
ok $pQRMONCOMMAND.parse('намери аномалии чрез остатъци ползвайки идентификатора SPLUS'),
        'намери аномалии чрез остатъци ползвайки идентификатора SPLUS';

done-testing;
