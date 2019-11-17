use Test;
use lib '../lib';
use lib './lib';
use QuantileRegressionWorkflowsGrammar;

plan 83;

# Shortcut
my $pQRMONCOMMAND = QuantileRegressionWorkflowsGrammar::Quantile-regression-workflow-commmand;

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


#-----------------------------------------------------------
# Data statistics
#-----------------------------------------------------------

ok $pQRMONCOMMAND.parse('summarize data'),
'summarize data';

ok $pQRMONCOMMAND.parse('summarize the data'),
'summarize the data';

ok $pQRMONCOMMAND.parse('show data summary'),
'show data summary';

ok $pQRMONCOMMAND.parse('cross tabulate'),
'cross tabulate';

ok $pQRMONCOMMAND.parse('cross tabulate the data'),
'cross tabulate the data';

ok $pQRMONCOMMAND.parse('cross tabulate time variable vs dependent variable'),
'cross tabulate time variable vs dependent variable';

ok $pQRMONCOMMAND.parse('cross tabulate the time variable vs the dependent'),
'cross tabulate the time variable vs the dependent';


#-----------------------------------------------------------
# Quantile Regression
#-----------------------------------------------------------

ok $pQRMONCOMMAND.parse('compute quantile regression'),
'compute quantile regression';

ok $pQRMONCOMMAND.parse('compute and display QuantileRegression'),
'compute and display QuantileRegression';

ok $pQRMONCOMMAND.parse('compute a quantile regression fit'),
'compute a quantile regression fit';

ok $pQRMONCOMMAND.parse('compute quantile regression'),
'compute quantile regression';

ok $pQRMONCOMMAND.parse('compute quantile regression with 0.1 0.2 0.5 0.7 0.9'),
'compute quantile regression with 0.1 0.2 0.5 0.7 0.9';

ok $pQRMONCOMMAND.parse('calculate quantile regression with probabilities 0.5 and 0.75'),
'calculate quantile regression with probabilities 0.5 and 0.75';

ok $pQRMONCOMMAND.parse('compute quantile regression with probabilities from 0. to 1'),
'compute quantile regression with probabilities from 0. to 1';

ok $pQRMONCOMMAND.parse('compute quantile regression for the probabilities 0.1 and 0.9'),
'compute quantile regression for the probabilities 0.1 and 0.9';

ok $pQRMONCOMMAND.parse('compute quantile regression for the probabilities 0.1 0.2 0.5 0.7 0.9'),
'compute quantile regression for the probabilities 0.1 0.2 0.5 0.7 0.9';

ok $pQRMONCOMMAND.parse('compute quantile regression with 0.1 0.2 0.5 0.7 0.9'),
'compute quantile regression with 0.1 0.2 0.5 0.7 0.9';

ok $pQRMONCOMMAND.parse('compute quantile regression using the 0.5 probability'),
'compute quantile regression using the 0.5 probability';

ok $pQRMONCOMMAND.parse('compute quantile regression using probability 0.5'),
'compute quantile regression using probability 0.5';

ok $pQRMONCOMMAND.parse('compute quantile regression with 0.1, 0.2, 0.5, 0.7, and 0.9'),
'compute quantile regression with 0.1, 0.2, 0.5, 0.7, and 0.9';

ok $pQRMONCOMMAND.parse('compute quantile regression with probabilities 0.1, 0.2, 0.5, 0.7, and 0.9'),
'compute quantile regression with probabilities 0.1, 0.2, 0.5, 0.7, and 0.9';

ok $pQRMONCOMMAND.parse('compute quantile regression with the probability list 0.1, 0.2, 0.5, 0.7, 0.9'),
'compute quantile regression with the probability list 0.1, 0.2, 0.5, 0.7, 0.9';

ok $pQRMONCOMMAND.parse('compute quantile regression with the knots 0.1, 0.2, 0.5, 0.7, 0.9'),
'compute quantile regression with the knots 0.1, 0.2, 0.5, 0.7, 0.9';

ok $pQRMONCOMMAND.parse('compute QuantileRegression using probabilities from 0.1 to 0.9 step 0.1'),
'compute QuantileRegression using probabilities from 0.1 to 0.9 step 0.1';

ok $pQRMONCOMMAND.parse('compute quantile regression using 0.5 and 10 knots'),
'compute quantile regression using 0.5 and 10 knots';

ok $pQRMONCOMMAND.parse('compute quantile regression with 12 knots and using the probability 0.5'),
'compute quantile regression with 12 knots and using the probability 0.5';

ok $pQRMONCOMMAND.parse('compute quantile regression with 12 knots, using the probability 0.5 and interpolation order 3'),
'compute quantile regression with 12 knots, using the probability 0.5 and interpolation order 3';

ok $pQRMONCOMMAND.parse('compute quantile regression with the knots from 0.1 to 20.2 step 0.5, using the probability 0.25, 0.5, 0.75 and interpolation order 3'),
'compute quantile regression with the knots from 0.1 to 20.2 step 0.5, using the probability 0.25, 0.5, 0.75 and interpolation order 3';

ok $pQRMONCOMMAND.parse('compute quantile regression using the probabilities 0.25, 0.5, 0.75 and knots from 0.1 to 20.2 step 0.5 and interpolation order 3'),
'compute quantile regression using the probabilities 0.25, 0.5, 0.75 and knots from 0.1 to 20.2 step 0.5 and interpolation order 3';


#-----------------------------------------------------------
# Quantile Regression fit
#-----------------------------------------------------------

ok $pQRMONCOMMAND.parse('compute quantile regression fit'),
'compute quantile regression fit';

ok $pQRMONCOMMAND.parse('compute a quantile regression fit'),
'compute a quantile regression fit';

ok $pQRMONCOMMAND.parse('compute least squares regression'),
'compute least squares regression';

ok $pQRMONCOMMAND.parse('compute least squares fit'),
'compute least squares fit';

ok $pQRMONCOMMAND.parse('compute quantile regression fit with functions Table[Sin[x],{x,0,10,2}]'),
'compute quantile regression fit with functions Table[Sin[x],{x,0,10,2}]';

ok $pQRMONCOMMAND.parse('compute quantile regression fit with 0.1 0.2 0.5 0.7 0.9');

ok $pQRMONCOMMAND.parse('compute quantile regression fit with functions Table[Sin[x],{x,0,10,2}] and proabilities 0.1, 0.2, and 0.6'),
'compute quantile regression fit with functions Table[Sin[x],{x,0,10,2}] and proabilities 0.1, 0.2, and 0.6';

ok $pQRMONCOMMAND.parse('compute quantile regression fit with quantiles 0.1, 0.2, and 0.6 and functions Table[Sin[x],{x,0,10,2}]'),
'compute quantile regression fit with quantiles 0.1, 0.2, and 0.6 and functions Table[Sin[x],{x,0,10,2}]';

ok $pQRMONCOMMAND.parse('compute QuantileRegression using probabilities from 0.1 to 0.9 step 0.1'),
'compute QuantileRegression using probabilities from 0.1 to 0.9 step 0.1';


#-----------------------------------------------------------
# Find outliers
#-----------------------------------------------------------

ok $pQRMONCOMMAND.parse('find outliers'),
'find outliers';

ok $pQRMONCOMMAND.parse('find top outliers'),
'find top outliers';

ok $pQRMONCOMMAND.parse('find bottom outliers'),
'find bottom outliers';

ok $pQRMONCOMMAND.parse('find bottom outliers with 0.1'),
'find bottom outliers with 0.1';

ok $pQRMONCOMMAND.parse('find and show bottom outliers with 0.01'),
'find and show bottom outliers with 0.01';

ok $pQRMONCOMMAND.parse('compute outliers with probabilities 0.1 and 0.9'),
'compute outliers with probabilities 0.1 and 0.9';

ok $pQRMONCOMMAND.parse('compute outliers with 0.1 0.2 0.5 0.7 0.9'),
'compute outliers with 0.1 0.2 0.5 0.7 0.9';


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

#-----------------------------------------------------------
# Error plots
#-----------------------------------------------------------

ok $pQRMONCOMMAND.parse('display errors plot'),
'display errors plots';

ok $pQRMONCOMMAND.parse('show the relative errors plots'),
'show the relative errors plots';

ok $pQRMONCOMMAND.parse('plot errors'),
'plot errors';

ok $pQRMONCOMMAND.parse('plot absolute errors'),
'plot absolute errors';

done-testing;
