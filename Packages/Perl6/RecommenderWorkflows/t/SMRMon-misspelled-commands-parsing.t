use Test;
use lib '../lib';
use lib './lib';
use RecommenderWorkflows::Grammar;

plan 10;

# Shortcut
my $pSMRMONCOMMAND = RecommenderWorkflows::Grammar::WorkflowCommand;

#-----------------------------------------------------------
# Creation commands
#-----------------------------------------------------------

ok $pSMRMONCOMMAND.parse('crate with ds2'),
'crate with ds2';

ok $pSMRMONCOMMAND.parse('create recomender with ds2'),
'create recomender with ds2';

ok $pSMRMONCOMMAND.parse('crate recomender obect with ds2'),
'crate recommnder obect with ds2';

ok $pSMRMONCOMMAND.parse('generate the recommender'),
'generate the recommender';

ok $pSMRMONCOMMAND.parse('create the recommender wiff dataset ds1 uzing the colum id'),
'create the recommender wiff dataset ds1 uzing the colum id';

ok $pSMRMONCOMMAND.parse('create using the matrixes <||>'),
'create using the matrixes <||>';


#-----------------------------------------------------------
# Recommendations by history commands
#-----------------------------------------------------------

ok $pSMRMONCOMMAND.parse('recomend with histry id.2:3 and id.13:4'),
'recomend with histry id.2:3 and id.13:4';

ok $pSMRMONCOMMAND.parse('reccomend with history id.12:3 and id.13:4'),
'reccomend with history id.12:3 and id.13:4';

ok $pSMRMONCOMMAND.parse('sugest by historie hr:3, rr:4, ra:1'),
'sugest by historie hr:3, rr:4, ra:1';

ok $pSMRMONCOMMAND.parse('find recommendasions for history hr:3, rr:4, ra:1'),
'find recommendasions for history hr:3, rr:4, ra:1';
