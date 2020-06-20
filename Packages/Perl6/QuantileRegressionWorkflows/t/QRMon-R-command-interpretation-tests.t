use v6;
use Test;
use lib 'lib';
use QuantileRegressionWorkflows;

plan 15;

#-----------------------------------------------------------
# Data transformation
#-----------------------------------------------------------

ok to_QRMon_R('rescale x axis'),
        'rescale x axis';

ok to_QRMon_R('rescale regressor axis'),
        'rescale regressor axis';

ok to_QRMon_R('rescale y axis'),
        'rescale y axis';

ok to_QRMon_R('rescale value axis'),
        'rescale value axis';

ok to_QRMon_R('rescale both axes'),
        'rescale both axes';

ok to_QRMon_R('resample'),
        'resample';

ok to_QRMon_R('resample the time series with step 0.3'),
        'resample the time series with step 0.3';

ok to_QRMon_R('resample with linear interpolation'),
        'resample with linear interpolation';

# ok to_QRMon_R('moving average using two days'),
# 'moving average using two days';

ok to_QRMon_R('moving average using 5'),
        'moving average using 5';

ok to_QRMon_R('moving median with 5 elements'),
        'moving average using 5';

ok to_QRMon_R('moving average with weights 1, 2, 5'),
        'moving average with weights 1, 2, 5';

ok to_QRMon_R('moving map Mean with 5 elements'),
        'moving map Mean with 5 elements';

ok to_QRMon_R('resample with hold value from left'),
        'resample with hold value from left';

ok to_QRMon_R('resample with HoldValueFromLeft'),
        'resample with HoldValueFromLeft';

ok to_QRMon_R('resample the time series'),
        'resample the time series';

done-testing;