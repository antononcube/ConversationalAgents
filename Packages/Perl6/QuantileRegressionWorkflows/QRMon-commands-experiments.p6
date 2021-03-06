use lib './lib';
use lib '.';
use QuantileRegressionWorkflows;


my $commands = '
create from tsData; delete missing;
echo data summary;
rescale the time axis;
compute quantile regression with 20 knots and probabilities 0.01, 0.25, 0.5, 0.75, 0.98;
show date list plot;
plot absolute errors;
compute and display outliers;
echo pipeline value
';


say "\n=======\n";

say to_QRMon_Py( $commands );

say "\n=======\n";

say to_QRMon_R( $commands );

say "\n=======\n";

say to_QRMon_WL( $commands );
