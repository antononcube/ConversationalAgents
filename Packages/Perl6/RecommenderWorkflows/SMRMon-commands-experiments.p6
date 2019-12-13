use lib './lib';
use lib '.';
use RecommenderWorkflows;
use RecommenderWorkflows::Grammar;

say to_SMRMon_WL("create from dfTitanic; recommnd for histry 1");

say to_SMRMon_WL("find anomalies by proximity using 20 nns, the aggregation function Mean and the property Distances");

#say to_SMRMon_WL("create from dfTitanic; recommend for history 1");

#say to_SMRMon_WL("create from dfTitanic; compute 12 recommendations for the history 1, 10; join across with dfTitanic");

# say to_SMRMon_R("create from dfTitanic");
#
# say to_SMRMon_R("recommend for history hr:3, rr:4, ra:1");
#
# say to_SMRMon_R('create from dfTitanic; recommend for history id.5, id.7');
#
# say to_SMRMon_R("use the recommender smr");
#
# say to_SMRMon_R("use the recommender smr; display the tag types");
#
# say to_SMRMon_R("use the recommender smr; display the tag types;");

# my $command = "use the recommender smr; display the tag types;";
# say $command.split(/ ';' \s* /).perl;
#
# say (grep { $_.Str.chars > 0 }, $command.split(/ ';' \s* /)).perl;
