use lib './lib';
use lib '.';
use QuantileRegressionWorkflows;
use QuantileRegressionWorkflowsGrammar;

#say QuantileRegressionWorkflowsGrammar::Quantile-regression-workflow-commmand.parse("compute quantile regression for the probabilities 0.1, 0.5 and 0.9");

#say QuantileRegressionWorkflowsGrammar::Quantile-regression-workflow-commmand.subparse("compute quantile regression with 0.1, 0.5, 0.9");

#say QuantileRegressionWorkflowsGrammar::Quantile-regression-workflow-commmand.subparse("compute quantile regression with 0.1, 0.5, 0.9 and knots 12");

#say QuantileRegressionWorkflowsGrammar::Quantile-regression-workflow-commmand.subparse("compute quantile regression with 0.1, 0.5, 0.9 and with knots 12");

#say to_QRMon_R("compute quantile regression with the probabilities 0.1, 0.5, 0.9 and knots 12");

#say to_QRMon_R("compute quantile regression with the probabilities 0.1, 0.5, 0.9 and with knots 12");

#say to_QRMon_R("compute quantile regression with the probabilities 0.1, 0.5, 0.9");

#say to_QRMon_R("use the quantile regression object qrmon0; compute quantile regression with the probabilities 0.1, 0.5, 0.9; show plot");

say to_QRMon_R("use qr object qrmon0; compute quantile regression with the probabilities 0.1, 0.5, 0.9; show plot");
