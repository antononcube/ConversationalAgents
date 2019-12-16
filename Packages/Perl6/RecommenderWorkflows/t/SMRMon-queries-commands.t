use v6;
use lib 'lib';
use RecommenderWorkflows::Grammar;
use Test;

plan 20;

# Shortcut
my $pSMRMONCOMMAND = RecommenderWorkflows::Grammar::WorkflowCommand;



#-----------------------------------------------------------
# SMR queries commands
#-----------------------------------------------------------

ok $pSMRMONCOMMAND.parse('display the column names'),
'display the column names';

ok $pSMRMONCOMMAND.parse('show the recommendation matrix dimensions'),
'show the recommendation matrix dimensions';

ok $pSMRMONCOMMAND.parse('show the number of rows'),
'show the number of rows';

ok $pSMRMONCOMMAND.parse('show tag types'),
'show tag types';

ok $pSMRMONCOMMAND.parse('display recommendation matrix'),
'display recommendation matrix';

ok $pSMRMONCOMMAND.parse('display the sparse matrix number of columns'),
'display the sparse matrix number of columns';

ok $pSMRMONCOMMAND.parse('show the sparse matrix number of rows'),
'show the sparse matrix number of rows';

ok $pSMRMONCOMMAND.parse('display the tag types'),
'display the tag types';

ok $pSMRMONCOMMAND.parse('display the number of columns'),
'show the recommender sub-matrices';

ok $pSMRMONCOMMAND.parse('show the recommender sub-matrices'),
'show the recommender sub-matrices';

ok $pSMRMONCOMMAND.parse('show the sparse matrix number of rows'),
'show the sparse matrix number of rows';

ok $pSMRMONCOMMAND.parse('show the sub matrix Skills number of rows'),
'show the sub matrix Skills number of rows';

ok $pSMRMONCOMMAND.parse('show tag type Skills columns'),
'show tag type Skills columns';

ok $pSMRMONCOMMAND.parse('show the matrix number of rows'),
'show the matrix number of rows';

ok $pSMRMONCOMMAND.parse('show the recommender matrix density'),
'show the recommender matrix density';

ok $pSMRMONCOMMAND.parse('show the recommendation matrix density'),
'show the recommendation matrix density';

ok $pSMRMONCOMMAND.parse('show the recommendation matrix properties'),
'show the recommendation matrix properties';

# ok $pSMRMONCOMMAND.parse('display the item column name'),
# 'display the item column name';

ok $pSMRMONCOMMAND.parse('display the recommender matrix properties'),
'display the recommender matrix properties';

ok $pSMRMONCOMMAND.parse('display the recommender properties'),
'display the recommender properties';

ok $pSMRMONCOMMAND.parse('show the tag type passengerClass density'),
'show the tag type passengerClass density';


done-testing;