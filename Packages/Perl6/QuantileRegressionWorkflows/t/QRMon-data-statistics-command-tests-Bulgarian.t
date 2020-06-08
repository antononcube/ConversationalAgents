use Test;
use lib '../lib';
use lib './lib';
use QuantileRegressionWorkflows::Grammar;

plan 10;

# Shortcut
my $pQRMONCOMMAND = QuantileRegressionWorkflows::Grammar::WorkflowCommmand;

#-----------------------------------------------------------
# Data statistics
#-----------------------------------------------------------

# summarize data
ok $pQRMONCOMMAND.parse('суммаризирай данни'),
        'сумаризирай данни';

# summarize data
ok $pQRMONCOMMAND.parse('обобщи данни'),
        'обобщи данни';

# summarize the data
ok $pQRMONCOMMAND.parse('сумаризирай данните'),
        'сумаризирай данните';

# summarize the data
ok $pQRMONCOMMAND.parse('обобщи данните'),
        'обобщи данните';

# show data summary
ok $pQRMONCOMMAND.parse('покажи рекапитулация на данните'),
        'покажи рекапитулация на данните';

# show data summary
ok $pQRMONCOMMAND.parse('покажи резюме на данните'),
        'покажи резюме на данните';

# cross tabulate
ok $pQRMONCOMMAND.parse('кръстно табулиране'),
        'кръстно табулиране';

# cross tabulate the data
ok $pQRMONCOMMAND.parse('кръстно табулиране на данните'),
        'кръстно табулиране на данните';

# cross tabulate time variable vs dependent variable
ok $pQRMONCOMMAND.parse('кръстно табулиране на време променлива със зависимата променлива'),
        'кръстно табулиране на време променлива със зависимата променлива';

# cross tabulate the time variable vs the dependent
ok $pQRMONCOMMAND.parse('кръстно табулиране на време променлива срещу зависимата'),
        'кръстно табулиране на време променлива срещу зависимата';

done-testing;
