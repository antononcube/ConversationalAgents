use v6;

#use QuantileRegressionWorkflows::Grammar::FuzzyMatch;
use QuantileRegressionWorkflows::Grammar::CommonParts;

# Epidemiology specific phrases
role QuantileRegressionWorkflows::Grammar::TimeSeriesAndRegressionPhrases
        does QuantileRegressionWorkflows::Grammar::CommonParts {

    # Proto tokens
    token absolute { 'absolute' }
    token anomalies { 'anomalies' }
    token anomaly { 'anomaly' }
    token average { 'average' | 'mean' }
    token curve { 'curve' }
    token curves { 'curves' }
    token date { 'date' }
    token dates { 'dates' }
    token degree { 'degree' }
    token error { 'error' }
    token errors { 'error' | 'errors' }
    token fit { 'fit' | 'fitting' }
    token fitted { 'fitted' }
    token hold-verb { 'hold' }
    token identifier { 'identifier' }
    token ingest { 'ingest' | 'load' | 'use' | 'get' }
    token interpolation { 'interpolation' }
    token knots { 'knots' }
    token least { 'least' }
    token linear { 'linear' }
    token map-noun { 'map' }
    token mean { 'mean' }
    token median { 'median' }
    token moving { 'moving' }
    token order { 'order'  }
    token origin { 'origin' }
    token outlier { 'outlier' }
    token outliers { 'outliers' | 'outlier' }
    token probabilities { 'probabilities' }
    token probability { 'probability' }
    token quantile { 'quantile' }
    token quantiles { 'quantiles' }
    token regression { 'regression' }
    token regressor { 'regressor' }
    token regressand { 'regressand' }
    token relative { 'relative' }
    token residuals { 'residuals' }
    token squares { 'squares' }
    token threshold { 'threshold' }
    token x-symbol { 'x' | 'X' }
    token y-symbol { 'y' | 'Y' }

    token resample-directive { 'resample' }
    token rescale-directive { 'rescale' }

    # Rules
    rule least-squares-phrase { <least> <squares> }
    rule quantile-regression-phrase { <quantile> <regression> }
    rule qr-object { [ 'QR' | 'qr' | <quantile-regression-phrase> ]? <object> }
    rule the-outliers { <the-determiner> <outliers> }
    rule value-from-left-phrase { 'value' 'from' 'left' }
}
