use lib './lib';
use lib '.';
use RecommenderWorkflows;

say to_SMRMon_R("create from dfTitanic");

say to_SMRMon_R("recommend for history hr:3, rr:4, ra:1");

say to_SMRMon_R('create from dfTitanic; recommend for history id.5, id.7');

say to_SMRMon_R("use the recommender smr");

say to_SMRMon_R("use the recommender smr; display the tag types");
