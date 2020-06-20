use Test;
use lib '../lib';
use lib './lib';
use QuantileRegressionWorkflows::Grammar;

plan 16;

# Shortcut
my $pQRMONCOMMAND = QuantileRegressionWorkflows::Grammar::WorkflowCommmand;

#-----------------------------------------------------------
# Data transformation
#-----------------------------------------------------------

ok $pQRMONCOMMAND.parse('rescale x axis'),
        'rescale x axis';

ok $pQRMONCOMMAND.parse('rescale regressor axis'),
        'rescale regressor axis';

ok $pQRMONCOMMAND.parse('rescale y axis'),
        'rescale y axis';

ok $pQRMONCOMMAND.parse('rescale value axis'),
        'rescale value axis';

ok $pQRMONCOMMAND.parse('rescale both axes'),
        'rescale both axes';

ok $pQRMONCOMMAND.parse('resample'),
        'resample';

ok $pQRMONCOMMAND.parse('resample the time series with step 0.3'),
        'resample the time series with step 0.3';

ok $pQRMONCOMMAND.parse('resample with linear interpolation'),
        'resample with linear interpolation';

ok $pQRMONCOMMAND.parse('moving average using two days'),
        'moving average using two days';

ok $pQRMONCOMMAND.parse('moving average using 5'),
        'moving average using 5';

ok $pQRMONCOMMAND.parse('moving median with 5 elements'),
        'moving average using 5';

ok $pQRMONCOMMAND.parse('moving average with weights 1, 2, 5'),
        'moving average with weights 1, 2, 5';

ok $pQRMONCOMMAND.parse('moving map Mean with 5 elements'),
        'moving map Mean with 5 elements';

ok $pQRMONCOMMAND.parse('resample with hold value from left'),
        'resample with hold value from left';

ok $pQRMONCOMMAND.parse('resample with HoldValueFromLeft'),
        'resample with HoldValueFromLeft';

ok $pQRMONCOMMAND.parse('resample the time series'),
        'resample the time series';

done-testing;
