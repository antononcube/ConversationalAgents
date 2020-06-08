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
ok $pQRMONCOMMAND.parse('calcular anomalías con umbral 0.9'),
        'calcular anomalías con umbral 0.9';

# compute anomalies by residuals with the threshold 5
ok $pQRMONCOMMAND.parse('calcular anomalías por residuos con el umbral 5'),
        'calcular anomalías por residuos con el umbral 5';

# find anomalies by the SPLUS outlier identifier
ok $pQRMONCOMMAND.parse('encontrar anomalías por el identificador atípico SPLUS'),
        'encontrar anomalías por el identificador atípico SPLUS';

# find anomalies with the outlier identifier Hampel
ok $pQRMONCOMMAND.parse('encontrar anomalías con el identificador atípico Hampel'),
        'encontrar anomalías con el identificador atípico Hampel';

# find anomalies by residuals using outlier identifier Hampel
ok $pQRMONCOMMAND.parse('encontrar anomalías por residuos utilizando un identificador atípico Hampel'),
        'encontrar anomalías por residuos utilizando un identificador atípico Hampel';

# find anomalies by residuals using the SPLUS outlier identifier
ok $pQRMONCOMMAND.parse('encontrar anomalías por residuos utilizando el identificador de valor atípico SPLUS'),
        'encontrar anomalías por residuos utilizando el identificador de valor atípico SPLUS';

done-testing;
