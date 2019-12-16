use v6;
use lib 'lib';
use RecommenderWorkflows::Grammar;
use Test;

plan 7;

# Shortcut
my $pSMRMONCOMMAND = RecommenderWorkflows::Grammar::WorkflowCommand;


#-----------------------------------------------------------
# Profile finding commands
#-----------------------------------------------------------

ok $pSMRMONCOMMAND.parse('compute the profile for the history hr=3, rr=4, ra=1'),
'compute the profile for the history hr=3, rr=4, ra=1';

ok $pSMRMONCOMMAND.parse('compute profile for history gog'),
'compute profile for history gog';

ok $pSMRMONCOMMAND.parse('compute profile for the item gog'),
'compute profile for the item gog';

ok $pSMRMONCOMMAND.parse('compute recommendations'),
'compute recommendations';

ok $pSMRMONCOMMAND.parse('find profile for the history K-2108=3, K-2179=2, M-2292=1'),
'find profile for the history K-2108=3, K-2179=2, M-2292=1';

ok $pSMRMONCOMMAND.parse('compute the profile for the history K-2108=3, K-2179=2, M-2292=1'),
'compute the profile for the history K-2108=3, K-2179=2, M-2292=1';

ok $pSMRMONCOMMAND.parse('make profile with the history id.1 : 1 and id.12 : 9 '),
'make profile with the history id.1 : 1 and id.12 : 9 ';


done-testing;