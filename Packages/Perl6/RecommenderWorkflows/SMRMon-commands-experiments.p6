use lib './lib';
use lib '.';
use RecommenderWorkflows;
use RecommenderWorkflows::Grammar;

#say RecommenderWorkflows::Grammar::WorkflowCommand.parse("prove the recommendation id.123 using the profile");
#
#say "\n=======\n";
#
#say RecommenderWorkflows::Grammar::WorkflowCommand.parse("prove the recommendation id.123 using the profile tag.1->1, tag.2->1, and tag.3->0.5");
#
#say "\n=======\n";

say to_SMRMon_R('
     use recommender smrObj2;
     make metadata recommender for tag type passengerClass over passengerAge and passengerSex' );

say "\n=======\n";

#say to_SMRMon_R('
#     use recommender smrObj2;
#     recommend by profile female, 30;
#     echo value;
#     prove recommendations by metadata' );
#
#say "\n=======\n";
#
#say to_SMRMon_R('
#     use recommender smrObj2;
#     recommend by profile female, 30;
#     echo value;
#     prove recommended items id.123, id.99 by metadata' );
#
#say "\n=======\n";
#
#say to_SMRMon_R('
#     use recommender smrObj2;
#     recommend by profile female, 30;
#     echo value;
#     display proof follows;
#     prove recommended items id.123, id.99 with the profile tag.1, tag.23' );

#say to_SMRMon_R('
#     use recommender smrObj2;
#     recomend by profile female, 30;
#     extend recommendations with dfTitanic;
#     echo value;
#     classify to passengerSurvival the profile male, 1st using 30 nns;
#     echo value' );

#say to_SMRMon_R('
#     use recommender smrObj2;
#     compute profile for the history id.5, id.993;
#     echo value;
#     find top 5 recommendations;
#     extend recommendations with dfTitanic;
#     echo value;');

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


#say "\n=======\n";
#
#say to_SMRMon_WL('
#     use recommender smrObj2;
#     recommend by profile female, 30;
#     extend recommendations with dfTitanic;
#     echo value;
#     prove the recommendated item
#     classify to passengerSurvival the profile male, 1st using 30 nns;
#     echo value
#');
#
#say "\n=======\n";
#
#say to_SMRMon_R('
#     use recommender smrObj2;
#     recommend by profile female, 30;
#     extend recommendations with dfTitanic;
#     echo value;
#     classify to passengerSurvival the profile male, 1st using 30 nns;
#     echo value
#');
#
#say "\n=======\n";
#
#say to_SMRMon_Py('
#     use recommender smrObj2;
#     recommend by profile female, 30;
#     extend recommendations with dfTitanic;
#     echo value;
#     classify to passengerSurvival the profile male, 1st using 30 nns;
#     echo value
#');

