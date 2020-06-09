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

# find outliers
ok $pQRMONCOMMAND.parse('encontrar valores atípicos'),
        'encontrar valores atípicos';

# find top outliers
ok $pQRMONCOMMAND.parse('encontrar los valores atípicos superiores'),
        'encontrar los valores atípicos superiores';

# find bottom outliers
ok $pQRMONCOMMAND.parse('encontrar valores atípicos inferiores'),
        'encontrar valores atípicos inferiores';

# find bottom outliers with 0.1
ok $pQRMONCOMMAND.parse('encontrar valores atípicos inferiores con 0.1'),
        'encontrar valores atípicos inferiores con 0.1';

# find and show bottom outliers with 0.01
ok $pQRMONCOMMAND.parse('encontrar y mostrar valores atípicos inferiores con 0.01'),
        'encontrar y mostrar valores atípicos inferiores con 0.01';

# compute outliers with probabilities 0.1 and 0.9
ok $pQRMONCOMMAND.parse('calcular valores atípicos con probabilidades 0.1 y 0.9'),
        'calcular valores atípicos con probabilidades 0.1 y 0.9';

# compute outliers with 0.1 0.2 0.5 0.7 0.9
ok $pQRMONCOMMAND.parse('изчисли извънредни точки с 0.1 0.2 0.5 0.7 0.9'),
        'изчисли извънредни точки с 0.1 0.2 0.5 0.7 0.9';

done-testing;
