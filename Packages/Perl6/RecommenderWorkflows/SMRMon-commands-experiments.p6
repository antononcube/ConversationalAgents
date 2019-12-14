use lib './lib';
use lib '.';
use RecommenderWorkflows;
use RecommenderWorkflows::Grammar;

#say RecommenderWorkflows::Grammar::WorkflowCommand.parse("show recommender matrix properties");

#say to_SMRMon_R('
#    use recommender smrObj;
#     show recommender matrix properties;
#     show recommender matrix property;
#     display the tag types;
#     show the recommender itemColumnName;
#     show the sparse matrix number of rows;
#     show the sparse matrix number of columns;
#     display the recommender matrix density;
#     show the sparse matrix columns;
#     filter the recommendation matrix with male, 30, 40;
#     show sparse matrix dimensions;
#     show the sub-matrix passengerClass columns;
#     show the tag type passengerSurvival density;'
#);


say "\n=======\n";

say to_SMRMon_WL('
     use recommender smrObj2;
     recommend by profile female, 30;
     extend recommendations with dfTitanic;
     echo value;
     classify to passengerSurvival the profile male, 1st using 30 nns;
     echo value
');

say "\n=======\n";

say to_SMRMon_R('
     use recommender smrObj2;
     recommend by profile female, 30;
     extend recommendations with dfTitanic;
     echo value;
     classify to passengerSurvival the profile male, 1st using 30 nns;
     echo value
');

say "\n=======\n";

say to_SMRMon_Py('
     use recommender smrObj2;
     recommend by profile female, 30;
     extend recommendations with dfTitanic;
     echo value;
     classify to passengerSurvival the profile male, 1st using 30 nns;
     echo value
');

