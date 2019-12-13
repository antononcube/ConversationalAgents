use lib './lib';
use lib '.';
use QuantileRegressionWorkflows;


say "\n=======\n";

say to_QRMon_R('
create from tsData; delete missing;
echo data summary;
compute quantile regression with 20 knots and probabilities 0.01, 0.25, 0.5, 0.75, 0.98;
show date list plot;
plot absolute errors;
compute and display outliers;
echo pipeline value
');

say "\n=======\n";

say to_QRMon_WL('
create from tsData; delete missing;
echo data summary;
compute quantile regression with 20 knots and probabilities 0.01, 0.25, 0.5, 0.75, 0.98;
show date list plot;
plot absolute errors;
compute and display outliers;
echo pipeline value
');
