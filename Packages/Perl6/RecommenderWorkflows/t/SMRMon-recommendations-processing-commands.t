use v6;
use lib 'lib';
use RecommenderWorkflows::Grammar;
use Test;

plan 15;

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

ok $pSMRMONCOMMAND.parse('prove the recommended items by profile'),
'prove the recommended items by profile';

ok $pSMRMONCOMMAND.parse('explain recommended items using the profile'),
'explain recommended items using the profile';

ok $pSMRMONCOMMAND.parse('explain the recommendation id.122 using the profile of id.999'),
'explain the recommendation id.122 using the profile of id.999';

ok $pSMRMONCOMMAND.parse('explain recommended item id.122 using metadata'),
'explain recommended item id.122 using metadata';

ok $pSMRMONCOMMAND.parse('prove the recommendation id.122 using history'),
'prove the recommendation id.122 using history';

ok $pSMRMONCOMMAND.parse('explain by metadata the recommendation id.123'),
'explain by metadata the recommendation id.123';

ok $pSMRMONCOMMAND.parse('prove by history the recommendation id.123'),
'prove by history the recommendation id.123';


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
