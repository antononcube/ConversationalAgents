use Test;
use lib '../lib';
use lib './lib';
use QuantileRegressionWorkflows::Grammar;

plan 7;

# Shortcut
my $pQRMONCOMMAND = QuantileRegressionWorkflows::Grammar::WorkflowCommmand;

#-----------------------------------------------------------
# Data statistics
#-----------------------------------------------------------

# summarize data
ok $pQRMONCOMMAND.parse('resumir datos'),
        'resumir datos';

# summarize the data
ok $pQRMONCOMMAND.parse('resumir los datos'),
        'resumir los datos';

# show data summary
ok $pQRMONCOMMAND.parse('mostrar resumen de datos'),
        'mostrar resumen de datos';

# cross tabulate
ok $pQRMONCOMMAND.parse('tabulación cruzada'),
        'tabulación cruzada';

# cross tabulate the data
ok $pQRMONCOMMAND.parse('tabular de forma cruzada los datos'),
        'tabular de forma cruzada los datos';

# cross tabulate time variable vs dependent variable
ok $pQRMONCOMMAND.parse('variable de tiempo de tabla cruzada vs variable dependiente'),
        'variable de tiempo de tabla cruzada vs variable dependiente';

# cross tabulate the time variable vs the dependent
ok $pQRMONCOMMAND.parse('tabulación cruzada de la variable de tiempo vs la dependiente'),
        'tabulación cruzada de la variable de tiempo vs la dependiente';

done-testing;
