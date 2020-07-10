use Test;
use lib '../lib';
use lib './lib';
use QuantileRegressionWorkflows::Grammar;

plan 12;

# Shortcut
my $pQRMONCOMMAND = QuantileRegressionWorkflows::Grammar::WorkflowCommand;

#-----------------------------------------------------------
# Plot
#-----------------------------------------------------------

ok $pQRMONCOMMAND.parse('display plot'),
        'display plot';

ok $pQRMONCOMMAND.parse('display date list plot'),
        'display date list plot';

ok $pQRMONCOMMAND.parse('display date list plot with date origin 1900-01-01'),
        'display date list plot with date origin 1900-01-01';

ok $pQRMONCOMMAND.parse('show regression curves plot'),
        'show regression curves plot';

ok $pQRMONCOMMAND.parse('show data and quantile regression curves plot'),
        'show data and quantile regression curves plot';

ok $pQRMONCOMMAND.parse('show quantile regression curves plot'),
        'show quantile regression curves plot';

ok $pQRMONCOMMAND.parse('show data and quantile curves plot'),
        'show data and quantile curves plot';

ok $pQRMONCOMMAND.parse('show data and quantile curves date plot'),
        'show data and quantile curves date plot';

ok $pQRMONCOMMAND.parse('show error plots'),
        'show error plots';

ok $pQRMONCOMMAND.parse('display outliers date list plot'),
        'display outliers date list plot';

ok $pQRMONCOMMAND.parse('display date list outliers plot'),
        'display date list outliers plot';

ok $pQRMONCOMMAND.parse('show outliers plot'),
        'show outliers plot';

done-testing;
