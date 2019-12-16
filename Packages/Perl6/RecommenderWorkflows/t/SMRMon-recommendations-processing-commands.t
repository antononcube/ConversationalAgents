use v6;
use lib 'lib';
use RecommenderWorkflows::Grammar;
use Test;

plan 9;

# Shortcut
my $pSMRMONCOMMAND = RecommenderWorkflows::Grammar::WorkflowCommand;

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

done-testing;