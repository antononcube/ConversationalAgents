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
ok $pQRMONCOMMAND.parse('намери извънредни стойности'),
        'намери извънредни стойности';

# find top outliers
ok $pQRMONCOMMAND.parse('намери горни извънредни стойности'),
        'намери горни извънредни стойности';

# find bottom outliers
ok $pQRMONCOMMAND.parse('намери долни извънредни стойности'),
        'намери долни извънредни стойности';

# find bottom outliers with 0.1
ok $pQRMONCOMMAND.parse('намери долни извънредни стойности под 0.1'),
        'намери долни извънредни стойности под 0.1';

# find and show bottom outliers with 0.01
ok $pQRMONCOMMAND.parse('намери и покажи долните извънредни елементи с 0.01'),
        'намери и покажи долните извънредни елементи с 0.01';

# compute outliers with probabilities 0.1 and 0.9
ok $pQRMONCOMMAND.parse('изчисли извънредните точки за вероятности 0.1 и 0.9'),
        'изчисли извънредните точки за вероятности 0.1 и 0.9';

# compute outliers with 0.1 0.2 0.5 0.7 0.9
ok $pQRMONCOMMAND.parse('calcular valores atípicos con 0.1 0.2 0.5 0.7 0.9'),
        'calcular valores atípicos con 0.1 0.2 0.5 0.7 0.9';

done-testing;
