use lib './lib';
#use lib '.';
use RecommenderWorkflows;
use RecommenderWorkflowsGrammar;
use SMRMon-R-actions;

#say RecommenderWorkflowsGrammar::Recommender-workflow-commmand.parse('load data dfTitanic');

#say RecommenderWorkflowsGrammar::Recommender-workflow-commmand.parse('load data dfTitanic', actions => SMRMon-R-actions::SMRMon-R-actions).made;

#say RecommenderWorkflowsGrammar::Recommender-workflow-commmand.parse('use recommender smr');

#say RecommenderWorkflowsGrammar::Recommender-workflow-commmand.parse('use recommender smr', actions => SMRMon-R-actions::SMRMon-R-actions).made;

#say RecommenderWorkflowsGrammar::Recommender-workflow-commmand.parse('load data s2');

#say RecommenderWorkflowsGrammar::Recommender-workflow-commmand.parse('use the smr object smr2');

#say RecommenderWorkflowsGrammar::Recommender-workflow-commmand.parse('use the smr object smr2', actions => SMRMon-R-actions::SMRMon-R-actions).made;

#say RecommenderWorkflowsGrammar::Recommender-workflow-commmand.subparse('create from matrices smr2');

#say RecommenderWorkflowsGrammar::Recommender-workflow-commmand.parse('create from matrices smr2', actions => SMRMon-R-actions::SMRMon-R-actions).made;

#say RecommenderWorkflowsGrammar::Recommender-workflow-commmand.parse('create a recommender in a simple way with ds2');

#say RecommenderWorkflowsGrammar::Recommender-workflow-commmand.parse('create with ds2');

#say RecommenderWorkflowsGrammar::Recommender-workflow-commmand.parse('recommend with history id.12:3 and id.13:4');

#say RecommenderWorkflowsGrammar::Recommender-workflow-commmand.parse('recommend with history id.12:3 and id.13:4', actions => SMRMon-R-actions::SMRMon-R-actions).made;

#say RecommenderWorkflowsGrammar::Recommender-workflow-commmand.parse('recommend by profile hr.12->3 & rr.12->4');

#say RecommenderWorkflowsGrammar::Recommender-workflow-commmand.parse('recommend by history hr:3, rr:4, ra:1');

#say RecommenderWorkflowsGrammar::Recommender-workflow-commmand.subparse('find recommendations for history hr:3, rr:4, ra:1');

#say RecommenderWorkflowsGrammar::Recommender-workflow-commmand.subparse('find the top 12 recommendations for history hr:3, rr:4, ra:1');

#say RecommenderWorkflowsGrammar::Recommender-workflow-commmand.subparse('compute 12 recommendations for the history hr:3, rr:4, ra:1');

#say RecommenderWorkflowsGrammar::Recommender-workflow-commmand.subparse('compute 12 recommendations for the history hr:3, rr:4, ra:1', actions => SMRMon-R-actions::SMRMon-R-actions).made;

#say RecommenderWorkflowsGrammar::Recommender-workflow-commmand.subparse('find the top 5 recommendations');

#say RecommenderWorkflowsGrammar::Recommender-workflow-commmand.subparse('find the top 5 recommendations', actions => SMRMon-R-actions::SMRMon-R-actions).made;

#say RecommenderWorkflowsGrammar::Recommender-workflow-commmand.subparse('find the top 15 profile recommendations');

#say RecommenderWorkflowsGrammar::Recommender-workflow-commmand.subparse('find the top 15 profile recommendations', actions => SMRMon-R-actions::SMRMon-R-actions).made;

#say RecommenderWorkflowsGrammar::Recommender-workflow-commmand.subparse('find the top 15 recommendations for the profile hr=2, jj=2');

#say RecommenderWorkflowsGrammar::Recommender-workflow-commmand.subparse('find the top 15 recommendations for the profile hr=2, jj=2', actions => SMRMon-R-actions::SMRMon-R-actions).made;

#say RecommenderWorkflowsGrammar::Recommender-workflow-commmand.subparse('what are the top 7 recommendations');

#say RecommenderWorkflowsGrammar::Recommender-workflow-commmand.subparse('what are the most relevant recommendations');

#say RecommenderWorkflowsGrammar::Recommender-workflow-commmand.subparse('compute the 12 most relevant recommendations');

#say RecommenderWorkflowsGrammar::Recommender-workflow-commmand.parse('compute the 12 most relevant recommendations', actions => SMRMon-R-actions::SMRMon-R-actions).made;

#say RecommenderWorkflowsGrammar::Recommender-workflow-commmand.parse('recommend by profile hr=3, rr=4, ra=1');

#say RecommenderWorkflowsGrammar::Recommender-workflow-commmand.parse('compute the profile for the history hr=3, rr=4, ra=1');

#say RecommenderWorkflowsGrammar::Recommender-workflow-commmand.parse('compute profile for history gog');

#say RecommenderWorkflowsGrammar::Recommender-workflow-commmand.parse('compute profile for the item gog');

#say RecommenderWorkflowsGrammar::Recommender-workflow-commmand.parse('compute recommendations');

#say RecommenderWorkflowsGrammar::Recommender-workflow-commmand.parse('find profile for the history O-2185977=3, O-2140979=2, O-2219692=1');

#say RecommenderWorkflowsGrammar::Recommender-workflow-commmand.parse('compute the profile for the history O-2185977=3, O-2140979=2, O-2219692=1');

#say RecommenderWorkflowsGrammar::Recommender-workflow-commmand.parse('classify the profile hh1=1, hh2=4, uu4=3 to travelClass', actions => SMRMon-R-actions::SMRMon-R-actions).made;

#say RecommenderWorkflowsGrammar::Recommender-workflow-commmand.parse('classify hh1=1, hh2=4, uu4=3 to travelClass');

#say RecommenderWorkflowsGrammar::Recommender-workflow-commmand.parse('classify hh1=1, hh2=4, uu4=3 to travelClass using 220 top nns');

#say RecommenderWorkflowsGrammar::Recommender-workflow-commmand.parse('classify hh1=1, hh2=4, uu4=3 to travelClass using 220 top nns', actions => SMRMon-R-actions::SMRMon-R-actions).made;

#say RecommenderWorkflowsGrammar::Recommender-workflow-commmand.parse('classify hh1=1, hh2=4, uu4=3 to travelClass', actions => SMRMon-R-actions::SMRMon-R-actions).made;

#say RecommenderWorkflowsGrammar::Recommender-workflow-commmand.parse('classify to travelClass the profile hh1=1, hh2=4, uu4=3 using 333 nearest neighbors');

#say RecommenderWorkflowsGrammar::Recommender-workflow-commmand.parse('classify to travelClass the profile hh1=1, hh2=4, uu4=3 using 333 nearest neighbors', actions => SMRMon-R-actions::SMRMon-R-actions).made;

#say RecommenderWorkflowsGrammar::Recommender-workflow-commmand.parse('classify to travelClass the profile hh1=1, hh2=4, uu4=3');

#say RecommenderWorkflowsGrammar::Recommender-workflow-commmand.parse('classify to travelClass hh1=1, hh2=4, uu4=3');

#say RecommenderWorkflowsGrammar::Recommender-workflow-commmand.parse('classify to travelClass hh1=1, hh2=4, uu4=3', actions => SMRMon-R-actions::SMRMon-R-actions).made;

#say RecommenderWorkflowsGrammar::Recommender-workflow-commmand.subparse('classify to travelClass the profile hh1=1, hh2=4, uu4=3 using 300 top nearest neighbors');

#say RecommenderWorkflowsGrammar::Recommender-workflow-commmand.parse('echo pipeline value', actions => SMRMon-R-actions::SMRMon-R-actions).made;

#say RecommenderWorkflowsGrammar::Recommender-workflow-commmand.parse('extend recommendations with the data frame dfTitanic', actions => SMRMon-R-actions::SMRMon-R-actions).made;

#say RecommenderWorkflowsGrammar::Recommender-workflow-commmand.parse('display the sparse matrix number of columns');

#say RecommenderWorkflowsGrammar::Recommender-workflow-commmand.parse('show the sparse matrix number of rows');

#say RecommenderWorkflowsGrammar::Recommender-workflow-commmand.parse('display the tag types');

#say RecommenderWorkflowsGrammar::Recommender-workflow-commmand.parse('display the number of columns');

#say RecommenderWorkflowsGrammar::Recommender-workflow-commmand.parse("display the tag types", actions => SMRMon-R-actions::SMRMon-R-actions).made;

#say RecommenderWorkflowsGrammar::Recommender-workflow-commmand.parse("show the recommender sub-matrices", actions => SMRMon-R-actions::SMRMon-R-actions).made;

#say RecommenderWorkflowsGrammar::Recommender-workflow-commmand.parse("show the sparse matrix number of rows", actions => SMRMon-R-actions::SMRMon-R-actions).made;

#say RecommenderWorkflowsGrammar::Recommender-workflow-commmand.parse("show the sub matrix Skills number of rows", actions => SMRMon-R-actions::SMRMon-R-actions).made;

#say RecommenderWorkflowsGrammar::Recommender-workflow-commmand.parse("show tag type Skills columns", actions => SMRMon-R-actions::SMRMon-R-actions).made;

#say RecommenderWorkflowsGrammar::Recommender-workflow-commmand.parse("show the matrix number of rows", actions => SMRMon-R-actions::SMRMon-R-actions).made;

#say RecommenderWorkflowsGrammar::Recommender-workflow-commmand.parse("show the recommender matrix density", actions => SMRMon-R-actions::SMRMon-R-actions).made;

#say RecommenderWorkflowsGrammar::Recommender-workflow-commmand.subparse("show the recommendation matrix density", actions => SMRMon-R-actions::SMRMon-R-actions).made;

#say RecommenderWorkflowsGrammar::Recommender-workflow-commmand.parse('display the item column name');

say RecommenderWorkflowsGrammar::Recommender-workflow-commmand.parse('filter the recommendation matrix with rr, jj, kk, pp');

say RecommenderWorkflowsGrammar::Recommender-workflow-commmand.parse('filter the recommendation matrix with rr, jj, kk, pp', actions => SMRMon-R-actions::SMRMon-R-actions).made;
