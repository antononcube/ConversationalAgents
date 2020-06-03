use v6;
use lib 'lib';
use RecommenderWorkflows::Grammar;
use Test;

plan 4;

# Shortcut
my $pSMRMONCOMMAND = RecommenderWorkflows::Grammar::WorkflowCommand;

#-----------------------------------------------------------
# Tag type recommender making
#-----------------------------------------------------------

ok $pSMRMONCOMMAND.parse('make tag type recommender for passengerClass'),
'make tag type recommender for passengerClass';

ok $pSMRMONCOMMAND.parse('make a metadata recommender for passengerClass'),
'make a metadata recommender for passengerClass';

ok $pSMRMONCOMMAND.parse('make a metadata recommender for passengerClass over passengerSex and passngerAge'),
'make a metadata recommender for passengerClass over passengerSex and passngerAge';

ok $pSMRMONCOMMAND.parse('make a metadata recommender for the tag type passengerClass over the tag types passengerSex and passngerAge'),
'make a metadata recommender for passengerClass over passengerSex and passngerAge';

done-testing;