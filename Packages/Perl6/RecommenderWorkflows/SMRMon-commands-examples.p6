use lib './lib';
#use lib '.';
use RecommenderWorkflows;
use RecommenderWorkflowsGrammar;
use SMRMon-R-actions;

#say RecommenderWorkflowsGrammar::Recommender-workflow-commmand.parse("load data s2");

say RecommenderWorkflowsGrammar::Recommender-workflow-commmand.parse("use the smr object smr2");

say RecommenderWorkflowsGrammar::Recommender-workflow-commmand.parse("use the smr object smr2", actions => SMRMon-R-actions::SMRMon-R-actions).made;

#say RecommenderWorkflowsGrammar::Recommender-workflow-commmand.subparse("create from matrices smr2");

say RecommenderWorkflowsGrammar::Recommender-workflow-commmand.parse("create from matrices smr2", actions => SMRMon-R-actions::SMRMon-R-actions).made;

#say RecommenderWorkflowsGrammar::Recommender-workflow-commmand.parse("create a recommender in a simple way with ds2");

#say RecommenderWorkflowsGrammar::Recommender-workflow-commmand.parse("create with ds2");

say RecommenderWorkflowsGrammar::Recommender-workflow-commmand.parse("recommend with history id.12:3 and id.13:4");

say RecommenderWorkflowsGrammar::Recommender-workflow-commmand.parse("recommend with history id.12:3 and id.13:4", actions => SMRMon-R-actions::SMRMon-R-actions).made;

#say RecommenderWorkflowsGrammar::Recommender-workflow-commmand.parse("recommend by profile hr.12->3 & rr.12->4");

#say RecommenderWorkflowsGrammar::Recommender-workflow-commmand.parse("recommend by history hr:3, rr:4, ra:1");

#say RecommenderWorkflowsGrammar::Recommender-workflow-commmand.parse("recommend by profile hr=3, rr=4, ra=1");

#say RecommenderWorkflowsGrammar::Recommender-workflow-commmand.parse("compute the profile for the history hr=3, rr=4, ra=1");

#say RecommenderWorkflowsGrammar::Recommender-workflow-commmand.parse("compute profile for history gog");

#say RecommenderWorkflowsGrammar::Recommender-workflow-commmand.parse("compute profile for the item gog");

#say RecommenderWorkflowsGrammar::Recommender-workflow-commmand.parse("compute the profile for the job history O-2185977=3, O-2140979=2, O-2219692=1");
