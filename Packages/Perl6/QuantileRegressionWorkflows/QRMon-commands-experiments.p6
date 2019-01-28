use lib './lib';
#use lib '.';
use QuantileRegressionWorkflowsGrammar;

# say QuantileRegressionWorkflowsGrammar::Quantile-regression-workflow-commmand.parse("rescale both axes");
# say QuantileRegressionWorkflowsGrammar::Quantile-regression-workflow-commmand.parse("rescale the x axis");
# say QuantileRegressionWorkflowsGrammar::Quantile-regression-workflow-commmand.parse("rescale the axes");

# say QuantileRegressionWorkflowsGrammar::Quantile-regression-workflow-commmand.parse("do quantile regression");
#
# say QuantileRegressionWorkflowsGrammar::Quantile-regression-workflow-commmand.parse("compute QuantileRegression");
#
# say QuantileRegressionWorkflowsGrammar::Quantile-regression-workflow-commmand.parse("do quantile regression with quantiles 0.2, 0.5 and 0.7");
#
# say QuantileRegressionWorkflowsGrammar::Quantile-regression-workflow-commmand.parse("compute quantile regression with 5 knots");
#
# say QuantileRegressionWorkflowsGrammar::Quantile-regression-workflow-commmand.parse("do quantile regression with 5 knots and interpolation order 4");

# say QuantileRegressionWorkflowsGrammar::Quantile-regression-workflow-commmand.parse("compute top outliers");
#
# say QuantileRegressionWorkflowsGrammar::Quantile-regression-workflow-commmand.parse("find and show bottom outliers with 0.01");
#
# say QuantileRegressionWorkflowsGrammar::Quantile-regression-workflow-commmand.parse("find and show bottom outliers with the quantile 0.02");

say QuantileRegressionWorkflowsGrammar::Quantile-regression-workflow-commmand.parse("show data and quantile regression curves plot");

say QuantileRegressionWorkflowsGrammar::Quantile-regression-workflow-commmand.parse("display outliers date list plot");

say QuantileRegressionWorkflowsGrammar::Quantile-regression-workflow-commmand.parse("display date list outliers plot");
