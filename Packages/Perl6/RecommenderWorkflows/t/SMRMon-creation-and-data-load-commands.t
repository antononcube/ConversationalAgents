use v6;
use lib 'lib';
use RecommenderWorkflows::Grammar;
use Test;

plan 10;

# Shortcut
my $pSMRMONCOMMAND = RecommenderWorkflows::Grammar::WorkflowCommand;

#-----------------------------------------------------------
# Creation commands
#-----------------------------------------------------------

ok $pSMRMONCOMMAND.parse('create with ds2'),
'create with ds2';

ok $pSMRMONCOMMAND.parse('create recommender with ds2'),
'create recommender with ds2';

ok $pSMRMONCOMMAND.parse('create recommender object with ds2'),
'create recommender object with ds2';

ok $pSMRMONCOMMAND.parse('generate the recommender'),
'generate the recommender';

ok $pSMRMONCOMMAND.parse('create the recommender with dataset ds1 using the column id'),
'create the recommender with dataset ds1 using the column id';

ok $pSMRMONCOMMAND.parse('create using the matrices <||>'),
'create using the matrices <||>';


#-----------------------------------------------------------
# Data load commands
#-----------------------------------------------------------

ok $pSMRMONCOMMAND.parse('load data dfTitanic'),
'load data dfTitanic';

ok $pSMRMONCOMMAND.parse('use recommender smr'),
'use recommender smr';

ok $pSMRMONCOMMAND.parse('load data s2'),
'load data s2';

ok $pSMRMONCOMMAND.parse('use the smr object smr2'),
'use the smr object smr2';

done-testing;