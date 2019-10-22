use lib './lib';
use lib '.';
use QuantileRegressionWorkflows;
use QuantileRegressionWorkflowsGrammar;

# my $*HIGHWATER = 0;
# my $*LASTRULE = 0;

#say QuantileRegressionWorkflowsGrammar::Quantile-regression-workflow-commmand.parse("show relative errors plots");

#say to_QRMon_WL('show absolute errors plots');

#say QuantileRegressionWorkflowsGrammar::Quantile-regression-workflow-commmand.parse("compute quantile regression for the probabilities 0.1, 0.5 and 0.9");

#say QuantileRegressionWorkflowsGrammar::Quantile-regression-workflow-commmand.subparse("compute quantile regression with 0.1, 0.5, 0.9");

#say QuantileRegressionWorkflowsGrammar::Quantile-regression-workflow-commmand.subparse("compute quantile regression with 0.1, 0.5, 0.9 and with 12 knots");

#say QuantileRegressionWorkflowsGrammar::Quantile-regression-workflow-commmand.parse("delete rows with missing values");

#say to_QRMon_R("compute quantile regression with the probabilities 0.1, 0.5, 0.9 and knots 12");

# say to_QRMon_WL("compute quantile regression with the probabilities 0.1, 0.5, 0.9 and with knots 10");
#
# say to_QRMon_WL("compute quantile regression with knots 20 and with the probabilities 0.1, 0.5, 0.9");
#
# say to_QRMon_WL("compute quantile regression with the probabilities 0.1, 0.5, 0.9");

#say to_QRMon_R("compute quantile regression with the probabilities 0.1, 0.5, 0.9");

#say to_QRMon_R("use the quantile regression object qrmon0; compute quantile regression with the probabilities 0.1, 0.5, 0.9; show plot");

#say to_QRMon_R("use qr object qrmon0; compute quantile regression with the probabilities 0.1, 0.5, 0.9; show plot");

#say to_QRMon_R('use object qrmon');

# say "\n=======\n";
#
# say to_QRMon_R("use object qrmon; rescale both axes; echo data summary; compute quantile regression with the probabilities 0.1, 0.5, 0.9, with knots 20; show plot");
#
# say "\n=======\n";
#
# say to_QRMon_R("use qr object qrmon0; resample; echo data summary; compute quantile regression with the probabilities 0.1, 0.5, 0.9; show plot");
#
# say to_QRMon_WL("create from dfTemperature; rescale both axes; echo data summary; compute quantile regression with the probabilities 0.1, 0.5, 0.9, with knots 20; show plot");
#
# say "\n=======\n";
#
say to_QRMon_WL('
create from tsData; delete missing;
echo data summary;
compute quantile regression with 20 knots and probabilities 0.01, 0.25, 0.5, 0.75, 0.98;
show date list plot;
plot absolute errors;
compute and display outliers;
echo pipeline value
')
