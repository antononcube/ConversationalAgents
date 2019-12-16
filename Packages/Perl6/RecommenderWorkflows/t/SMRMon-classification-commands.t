use v6;
use lib 'lib';
use RecommenderWorkflows::Grammar;
use Test;

plan 8;

# Shortcut
my $pSMRMONCOMMAND = RecommenderWorkflows::Grammar::WorkflowCommand;



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

done-testing;