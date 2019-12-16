use v6;
use lib 'lib';
use RecommenderWorkflows::Grammar;
use Test;

plan 13;

# Shortcut
my $pSMRMONCOMMAND = RecommenderWorkflows::Grammar::WorkflowCommand;

#-----------------------------------------------------------
# Find anomalies
#-----------------------------------------------------------

ok $pSMRMONCOMMAND.parse('find anomalies by proximity'),
'find anomalies by proximity';

ok $pSMRMONCOMMAND.parse('find proximity anomalies'),
'find proximity anomalies';

ok $pSMRMONCOMMAND.parse('compute anomalies with 12 nns'),
'compute anomalies with 12 nns';

ok $pSMRMONCOMMAND.parse('compute anomalies with 12 nns and the aggregation function Median'),
'compute anomalies with 12 nns and the aggregation function Median';

ok $pSMRMONCOMMAND.parse('find anomalies with 12 nns and aggregate using the function Mean'),
'compute anomalies with 12 nns and aggregate using the function Mean';

ok $pSMRMONCOMMAND.parse('find anomalies with 12 nns and the property Distances'),
'find anomalies with 12 nns and using the property Distances';

ok $pSMRMONCOMMAND.parse('compute proximity anomalies using 20 nearest neighbors'),
'compute anomalies using 20 nearest neighbors';

ok $pSMRMONCOMMAND.parse('find anomalies by proximity with the SPLUS outlier identifier'),
'find anomalies with the SPLUS outlier identifier';

ok $pSMRMONCOMMAND.parse('find anomalies with the outlier identifier Hampel'),
'find anomalies with the outlier identifier Hampel';

ok $pSMRMONCOMMAND.parse('find anomalies using outlier identifier Hampel and 12 nearest neighbors'),
'find anomalies using outlier identifier Hampel and 12 nearest neighbors';

ok $pSMRMONCOMMAND.parse('find anomalies by proximity using 20 nns and the SPLUS outlier identifier'),
'find anomalies by proximity using 20 nns and the SPLUS outlier identifier';

ok $pSMRMONCOMMAND.parse('find anomalies using 20 nns, aggregate with the function Median and the SPLUS outlier identifier'),
'find anomalies using 20 nns, aggregate with the function Median and the SPLUS outlier identifier';

ok $pSMRMONCOMMAND.parse('find anomalies using 20 nns, aggregate with the function Median, the Hampel outlier identifier and the property Distances'),
'find anomalies using 20 nns, aggregate with the function Median, the Hampel outlier identifier, and the property Distances';

done-testing;