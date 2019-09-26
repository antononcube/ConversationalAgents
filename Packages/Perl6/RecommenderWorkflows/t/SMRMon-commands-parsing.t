use Test;
use lib '../lib';
use lib './lib';
use RecommenderWorkflowsGrammar;

plan 85;

# Shortcut
my $pSMRMONCOMMAND = RecommenderWorkflowsGrammar::Recommender-workflow-commmand;

#-----------------------------------------------------------
# Creation commands
#-----------------------------------------------------------

ok $pSMRMONCOMMAND.parse('create with ds2'),
'create with ds2';

ok $pSMRMONCOMMAND.parse('create recommender with ds2'),
'create recommender with ds2';

ok $pSMRMONCOMMAND.parse('create recommender object with ds2'),
'create recommender object with ds2';

ok $pSMRMONCOMMAND.parse('generate the recommender'),
'generate the recommender';

ok $pSMRMONCOMMAND.parse('create the recommender with dataset ds1 using the column id'),
'create the recommender with dataset ds1 using the column id';

ok $pSMRMONCOMMAND.parse('create using the matrices <||>'),
'create using the matrices <||>';


#-----------------------------------------------------------
# Data load commands
#-----------------------------------------------------------

ok $pSMRMONCOMMAND.parse('load data dfTitanic'),
'load data dfTitanic';

ok $pSMRMONCOMMAND.parse('use recommender smr'),
'use recommender smr';

ok $pSMRMONCOMMAND.parse('load data s2'),
'load data s2';

ok $pSMRMONCOMMAND.parse('use the smr object smr2'),
'use the smr object smr2';


#-----------------------------------------------------------
# Recommendations by history commands
#-----------------------------------------------------------

ok $pSMRMONCOMMAND.parse('recommend with history id.2:3 and id.13:4'),
'recommend with history id.2:3 and id.13:4';

ok $pSMRMONCOMMAND.parse('recommend with history id.12:3 and id.13:4'),
'recommend with history id.12:3 and id.13:4';

ok $pSMRMONCOMMAND.parse('recommend by history hr:3, rr:4, ra:1'),
'recommend by history hr:3, rr:4, ra:1';

ok $pSMRMONCOMMAND.parse('find recommendations for history hr:3, rr:4, ra:1'),
'find recommendations for history hr:3, rr:4, ra:1';

ok $pSMRMONCOMMAND.parse('find the top 12 recommendations for history hr:3, rr:4, ra:1'),
'find the top 12 recommendations for history hr:3, rr:4, ra:1';

ok $pSMRMONCOMMAND.parse('compute 12 recommendations for the history hr:3, rr:4, ra:1'),
'compute 12 recommendations for the history hr:3, rr:4, ra:1';


#-----------------------------------------------------------
# Recommendations by profile commands
#-----------------------------------------------------------

ok $pSMRMONCOMMAND.parse('recommend by profile hr.12->3 & rr.12->4'),
'recommend by profile hr.12->3 & rr.12->4';

ok $pSMRMONCOMMAND.parse('recommend with profile hr.12 -> 3 and rr.12 -> 4'),
'recommend with profile hr.12 -> 3 and rr.12 -> 4';

ok $pSMRMONCOMMAND.parse('recommend by profile hr.12 -> 3 and rr.12 -> 4'),
'recommend by profile hr.12 -> 3 and rr.12 -> 4';

ok $pSMRMONCOMMAND.parse('recommend by profile hr=3, rr=4, ra=1'),
'recommend by profile hr=3, rr=4, ra=1';


#-----------------------------------------------------------
# Recommendations universal commands
#-----------------------------------------------------------

ok $pSMRMONCOMMAND.parse('find the top 5 recommendations'),
'find the top 5 recommendations';

ok $pSMRMONCOMMAND.parse('find the top 15 profile recommendations'),
'find the top 15 profile recommendations';

ok $pSMRMONCOMMAND.parse('find the top 15 recommendations for the profile hr=2, jj=2'),
'find the top 15 recommendations for the profile hr=2, jj=2';

ok $pSMRMONCOMMAND.parse('what are the top 7 recommendations'),
'what are the top 7 recommendations';

ok $pSMRMONCOMMAND.parse('what are the most relevant recommendations'),
'what are the most relevant recommendations';

ok $pSMRMONCOMMAND.parse('compute the 12 most relevant recommendations'),
'compute the 12 most relevant recommendations';

#-----------------------------------------------------------
# Explanations commands
#-----------------------------------------------------------

ok $pSMRMONCOMMAND.parse('explain the recommendations'),
'explain the recommendations';

ok $pSMRMONCOMMAND.parse('explain the recommendations with the consumption history'),
'explain the recommendations with the consumption history';

ok $pSMRMONCOMMAND.parse('explain the recommended items by profile'),
'explain the recommended items by profile';

ok $pSMRMONCOMMAND.parse('explain recommended items using the profile'),
'explain recommended items using the profile';


#-----------------------------------------------------------
# Profile finding commands
#-----------------------------------------------------------

ok $pSMRMONCOMMAND.parse('compute the profile for the history hr=3, rr=4, ra=1'),
'compute the profile for the history hr=3, rr=4, ra=1';

ok $pSMRMONCOMMAND.parse('compute profile for history gog'),
'compute profile for history gog';

ok $pSMRMONCOMMAND.parse('compute profile for the item gog'),
'compute profile for the item gog';

ok $pSMRMONCOMMAND.parse('compute recommendations'),
'compute recommendations';

ok $pSMRMONCOMMAND.parse('find profile for the history K-2108=3, K-2179=2, M-2292=1'),
'find profile for the history K-2108=3, K-2179=2, M-2292=1';

ok $pSMRMONCOMMAND.parse('compute the profile for the history K-2108=3, K-2179=2, M-2292=1'),
'compute the profile for the history K-2108=3, K-2179=2, M-2292=1';

ok $pSMRMONCOMMAND.parse('make profile with the history id.1 : 1 and id.12 : 9 '),
'make profile with the history id.1 : 1 and id.12 : 9 ';


#-----------------------------------------------------------
# Classify commands
#-----------------------------------------------------------

ok $pSMRMONCOMMAND.parse('classify the profile hh1=1, hh2=4, uu4=3 to travelClass'),
'classify the profile hh1=1, hh2=4, uu4=3 to travelClass';

ok $pSMRMONCOMMAND.parse('classify hh1=1, hh2=4, uu4=3 to travelClass'),
'classify hh1=1, hh2=4, uu4=3 to travelClass';

ok $pSMRMONCOMMAND.parse('classify hh1=1, hh2=4, uu4=3 to travelClass using 220 top nns'),
'classify hh1=1, hh2=4, uu4=3 to travelClass using 220 top nns';

ok $pSMRMONCOMMAND.parse('classify hh1=1, hh2=4, uu4=3 to travelClass'),
'classify hh1=1, hh2=4, uu4=3 to travelClass';

ok $pSMRMONCOMMAND.parse('classify to travelClass the profile hh1=1, hh2=4, uu4=3 using 333 nearest neighbors'),
'classify to travelClass the profile hh1=1, hh2=4, uu4=3 using 333 nearest neighbors';

ok $pSMRMONCOMMAND.parse('classify to travelClass the profile hh1=1, hh2=4, uu4=3'),
'classify to travelClass the profile hh1=1, hh2=4, uu4=3';

ok $pSMRMONCOMMAND.parse('classify to travelClass hh1=1, hh2=4, uu4=3'),
'classify to travelClass hh1=1, hh2=4, uu4=3';

ok $pSMRMONCOMMAND.parse('classify to travelClass the profile hh1=1, hh2=4, uu4=3 using 300 top nearest neighbors'),
'classify to travelClass the profile hh1=1, hh2=4, uu4=3 using 300 top nearest neighbors';


#-----------------------------------------------------------
# SMR queries commands
#-----------------------------------------------------------

ok $pSMRMONCOMMAND.parse('display the column names'),
'display the column names';

ok $pSMRMONCOMMAND.parse('show the recommendation matrix dimensions'),
'show the recommendation matrix dimensions';

ok $pSMRMONCOMMAND.parse('show the number of rows'),
'show the number of rows';

ok $pSMRMONCOMMAND.parse('show tag types'),
'show tag types';

ok $pSMRMONCOMMAND.parse('display recommendation matrix'),
'display recommendation matrix';

ok $pSMRMONCOMMAND.parse('display the sparse matrix number of columns'),
'display the sparse matrix number of columns';

ok $pSMRMONCOMMAND.parse('show the sparse matrix number of rows'),
'show the sparse matrix number of rows';

ok $pSMRMONCOMMAND.parse('display the tag types'),
'display the tag types';

ok $pSMRMONCOMMAND.parse('display the number of columns'),
'show the recommender sub-matrices';

ok $pSMRMONCOMMAND.parse('show the recommender sub-matrices'),
'show the recommender sub-matrices';

ok $pSMRMONCOMMAND.parse('show the sparse matrix number of rows'),
'show the sparse matrix number of rows';

ok $pSMRMONCOMMAND.parse('show the sub matrix Skills number of rows'),
'show the sub matrix Skills number of rows';

ok $pSMRMONCOMMAND.parse('show tag type Skills columns'),
'show tag type Skills columns';

ok $pSMRMONCOMMAND.parse('show the matrix number of rows'),
'show the matrix number of rows';

ok $pSMRMONCOMMAND.parse('show the recommender matrix density'),
'show the recommender matrix density';

ok $pSMRMONCOMMAND.parse('show the recommendation matrix density'),
'show the recommendation matrix density';

# ok $pSMRMONCOMMAND.parse('display the item column name'),
# 'display the item column name';

ok $pSMRMONCOMMAND.parse('display the recommender matrix properties'),
'display the recommender matrix properties';

ok $pSMRMONCOMMAND.parse('display the recommender properties'),
'display the recommender properties';

ok $pSMRMONCOMMAND.parse('show the tag type passengerClass density'),
'show the tag type passengerClass density';

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

#-----------------------------------------------------------
# Recommendations processing commands
#-----------------------------------------------------------

ok $pSMRMONCOMMAND.parse('extend recommendations with dataset ds1'),
'extend recommendations with dataset ds1';

ok $pSMRMONCOMMAND.parse('extend recommendations with the dataset ds1 by column passenger'),
'extend recommendations with the dataset ds1 by column passenger';

ok $pSMRMONCOMMAND.parse('join recommendations with the dataset ds1 via the column passenger'),
'join recommendations with the dataset ds1 via the column passenger';

ok $pSMRMONCOMMAND.parse('join recommendations with the dataset ds1 using the column passenger'),
'join recommendations with the dataset ds1 using the column passenger';

ok $pSMRMONCOMMAND.parse('filter recommendations with tag1 and tag2'),
'filter recommendations with tag1 and tag2';


#-----------------------------------------------------------
# General pipeline commands
#-----------------------------------------------------------

ok $pSMRMONCOMMAND.parse('filter the recommendation matrix with rr, jj, kk, pp'),
'filter the recommendation matrix with rr, jj, kk, pp';


ok $pSMRMONCOMMAND.parse('show pipeline value'),
'show pipeline value';
