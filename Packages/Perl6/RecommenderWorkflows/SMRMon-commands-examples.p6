use lib './lib';
#use lib '.';
use RecommenderWorkflows;
use RecommenderWorkflows::Grammar;
use RecommenderWorkflows::Actions::SMRMon-R;

# Shortcut
my $pSMRMONCOMMAND = RecommenderWorkflows::Grammar::WorkflowCommand;

#use MLWorflows::Recommender::Actions::SMRMon-R;
#use MLWorflows::QuantileRegression::Actions::SMRMon-R;

say $pSMRMONCOMMAND.subparse( 'make a metadata recommender for passengerClass over passengerSex and passngerAge' );

# say $pSMRMONCOMMAND.parse('find proximity anomalies using 20 nns');
#
# say $pSMRMONCOMMAND.parse('20 nns and SPLUS outlier identifier', :rule<proximity-anomalies-spec-list>);

#say $pSMRMONCOMMAND.parse('make with dataset ds2');

#say $pSMRMONCOMMAND.parse('generate the recommender system');

#say $pSMRMONCOMMAND.parse('generate the recommender system directly');

#say $pSMRMONCOMMAND.parse('load data dfTitanic');

#say $pSMRMONCOMMAND.parse('load data dfTitanic', actions => SMRMon-R-actions::SMRMon-R-actions).made;

#say $pSMRMONCOMMAND.parse('use recommender smr');

#say $pSMRMONCOMMAND.parse('use recommender smr', actions => SMRMon-R-actions::SMRMon-R-actions).made;

#say $pSMRMONCOMMAND.parse('load data s2');

#say $pSMRMONCOMMAND.parse('use the smr object smr2');

#say $pSMRMONCOMMAND.parse('use the smr object smr2', actions => SMRMon-R-actions::SMRMon-R-actions).made;

#say $pSMRMONCOMMAND.subparse('create from matrices smr2');

#say $pSMRMONCOMMAND.parse('create from matrices smr2', actions => SMRMon-R-actions::SMRMon-R-actions).made;

#say $pSMRMONCOMMAND.parse('create a recommender in a simple way with ds2');

#say $pSMRMONCOMMAND.parse('create with ds2');

#say $pSMRMONCOMMAND.parse('recommend with history id.12:3 and id.13:4');

#say $pSMRMONCOMMAND.parse('recommend with history id.12:3 and id.13:4', actions => SMRMon-R-actions::SMRMon-R-actions).made;

#say $pSMRMONCOMMAND.parse('recommend by profile hr.12->3 & rr.12->4');

#say $pSMRMONCOMMAND.parse('recommend by history hr:3, rr:4, ra:1');

#say $pSMRMONCOMMAND.subparse('find recommendations for history hr:3, rr:4, ra:1');

#say $pSMRMONCOMMAND.subparse('find the top 12 recommendations for history hr:3, rr:4, ra:1');

#say $pSMRMONCOMMAND.subparse('compute 12 recommendations for the history hr:3, rr:4, ra:1');

#say $pSMRMONCOMMAND.subparse('compute 12 recommendations for the history hr:3, rr:4, ra:1', actions => SMRMon-R-actions::SMRMon-R-actions).made;

#say $pSMRMONCOMMAND.subparse('find the top 5 recommendations');

#say $pSMRMONCOMMAND.subparse('find the top 5 recommendations', actions => SMRMon-R-actions::SMRMon-R-actions).made;

#say $pSMRMONCOMMAND.subparse('find the top 15 profile recommendations');

#say $pSMRMONCOMMAND.subparse('find the top 15 profile recommendations', actions => SMRMon-R-actions::SMRMon-R-actions).made;

#say $pSMRMONCOMMAND.subparse('find the top 15 recommendations for the profile hr=2, jj=2');

#say $pSMRMONCOMMAND.subparse('find the top 15 recommendations for the profile hr=2, jj=2', actions => SMRMon-R-actions::SMRMon-R-actions).made;

#say $pSMRMONCOMMAND.subparse('what are the top 7 recommendations');

#say $pSMRMONCOMMAND.subparse('what are the most relevant recommendations');

#say $pSMRMONCOMMAND.subparse('compute the 12 most relevant recommendations');

#say $pSMRMONCOMMAND.parse('compute the 12 most relevant recommendations', actions => SMRMon-R-actions::SMRMon-R-actions).made;

#say $pSMRMONCOMMAND.parse('recommend by profile hr=3, rr=4, ra=1');

#say $pSMRMONCOMMAND.parse('compute the profile for the history hr=3, rr=4, ra=1');

#say $pSMRMONCOMMAND.parse('compute profile for history gog');

#say $pSMRMONCOMMAND.parse('compute profile for the item gog');

#say $pSMRMONCOMMAND.parse('compute recommendations');

#say $pSMRMONCOMMAND.parse('find profile for the history O-2185977=3, O-2140979=2, O-2219692=1');

#say $pSMRMONCOMMAND.parse('compute the profile for the history O-2185977=3, O-2140979=2, O-2219692=1');

#say $pSMRMONCOMMAND.parse('classify the profile hh1=1, hh2=4, uu4=3 to travelClass', actions => SMRMon-R-actions::SMRMon-R-actions).made;

#say $pSMRMONCOMMAND.parse('classify hh1=1, hh2=4, uu4=3 to travelClass');

#say $pSMRMONCOMMAND.parse('classify hh1=1, hh2=4, uu4=3 to travelClass using 220 top nns');

#say $pSMRMONCOMMAND.parse('classify hh1=1, hh2=4, uu4=3 to travelClass using 220 top nns', actions => SMRMon-R-actions::SMRMon-R-actions).made;

#say $pSMRMONCOMMAND.parse('classify hh1=1, hh2=4, uu4=3 to travelClass', actions => SMRMon-R-actions::SMRMon-R-actions).made;

#say $pSMRMONCOMMAND.parse('classify to travelClass the profile hh1=1, hh2=4, uu4=3 using 333 nearest neighbors');

#say $pSMRMONCOMMAND.parse('classify to travelClass the profile hh1=1, hh2=4, uu4=3 using 333 nearest neighbors', actions => SMRMon-R-actions::SMRMon-R-actions).made;

#say $pSMRMONCOMMAND.parse('classify to travelClass the profile hh1=1, hh2=4, uu4=3');

#say $pSMRMONCOMMAND.parse('classify to travelClass hh1=1, hh2=4, uu4=3');

#say $pSMRMONCOMMAND.parse('classify to travelClass hh1=1, hh2=4, uu4=3', actions => SMRMon-R-actions::SMRMon-R-actions).made;

#say $pSMRMONCOMMAND.subparse('classify to travelClass the profile hh1=1, hh2=4, uu4=3 using 300 top nearest neighbors');

#say $pSMRMONCOMMAND.parse('echo pipeline value', actions => SMRMon-R-actions::SMRMon-R-actions).made;

#say $pSMRMONCOMMAND.parse('extend recommendations with the data frame dfTitanic', actions => SMRMon-R-actions::SMRMon-R-actions).made;

#say $pSMRMONCOMMAND.parse('display the sparse matrix number of columns');

#say $pSMRMONCOMMAND.parse('show the sparse matrix number of rows');

#say $pSMRMONCOMMAND.parse('display the tag types');

#say $pSMRMONCOMMAND.parse('display the number of columns');

#say $pSMRMONCOMMAND.parse("display the tag types", actions => SMRMon-R-actions::SMRMon-R-actions).made;

#say $pSMRMONCOMMAND.parse("show the recommender sub-matrices", actions => SMRMon-R-actions::SMRMon-R-actions).made;

#say $pSMRMONCOMMAND.parse("show the sparse matrix number of rows", actions => SMRMon-R-actions::SMRMon-R-actions).made;

#say $pSMRMONCOMMAND.parse("show the sub matrix Skills number of rows", actions => SMRMon-R-actions::SMRMon-R-actions).made;

#say $pSMRMONCOMMAND.parse("show tag type Skills columns", actions => SMRMon-R-actions::SMRMon-R-actions).made;

#say $pSMRMONCOMMAND.parse("show the matrix number of rows", actions => SMRMon-R-actions::SMRMon-R-actions).made;

#say $pSMRMONCOMMAND.parse("show the recommender matrix density", actions => SMRMon-R-actions::SMRMon-R-actions).made;

#say $pSMRMONCOMMAND.subparse("show the recommendation matrix density", actions => SMRMon-R-actions::SMRMon-R-actions).made;

#say $pSMRMONCOMMAND.parse('display the item column name');

#say $pSMRMONCOMMAND.parse('filter the recommendation matrix with rr, jj, kk, pp');

#say $pSMRMONCOMMAND.parse('filter the recommendation matrix with rr, jj, kk, pp', actions => SMRMon-R-actions::SMRMon-R-actions).made;

#say $pSMRMONCOMMAND.parse('display the recommender matrix properties', actions => SMRMon-R-actions::SMRMon-R-actions).made;

#say $pSMRMONCOMMAND.parse('display the recommender properties', actions => SMRMon-R-actions::SMRMon-R-actions).made;

#say $pSMRMONCOMMAND.parse('show the tag type passengerClass density');

#say $pSMRMONCOMMAND.parse('show pipeline value');
