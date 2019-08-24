use Test;
use lib '../lib';
use lib './lib';
use QuantileRegressionWorkflowsGrammar;

plan 12;

ok QuantileRegressionWorkflowsGrammar::Quantile-regression-workflow-commmand.parse("show data and quantile regression curves plot");

ok QuantileRegressionWorkflowsGrammar::Quantile-regression-workflow-commmand.parse("compute quantile regression");

ok QuantileRegressionWorkflowsGrammar::Quantile-regression-workflow-commmand.parse("summarize data");

ok QuantileRegressionWorkflowsGrammar::Quantile-regression-workflow-commmand.parse("compute and display QuantileRegression");

ok QuantileRegressionWorkflowsGrammar::Quantile-regression-workflow-commmand.parse("compute a quantile regression fit");

ok QuantileRegressionWorkflowsGrammar::Quantile-regression-workflow-commmand.parse("compute quantile regression with probability 0.85");

ok QuantileRegressionWorkflowsGrammar::Quantile-regression-workflow-commmand.parse("compute quantile regression with probabilities 0.5 and 0.75");

ok QuantileRegressionWorkflowsGrammar::Quantile-regression-workflow-commmand.parse("compute quantile regression with probabilities 0.25 0.5 0.75");

ok QuantileRegressionWorkflowsGrammar::Quantile-regression-workflow-commmand.parse("compute quantile regression with probabilities 0.5 and 0.75 and 0.3");

ok QuantileRegressionWorkflowsGrammar::Quantile-regression-workflow-commmand.parse("compute quantile regression with probabilities 0.25, 0.5 and 0.75");

ok QuantileRegressionWorkflowsGrammar::Quantile-regression-workflow-commmand.parse("compute quantile regression with probabilities from 0.25 to 0.75 with step 0.25");

ok QuantileRegressionWorkflowsGrammar::Quantile-regression-workflow-commmand.parse("compute quantile regression with probabilities from 0. to 1");

done-testing;
