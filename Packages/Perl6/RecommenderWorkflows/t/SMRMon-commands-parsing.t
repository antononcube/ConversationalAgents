use v6;
use lib 'lib';
use RecommenderWorkflows::Grammar;
use Test;

plan 2;

# Shortcut
my $pSMRMONCOMMAND = RecommenderWorkflows::Grammar::WorkflowCommand;


#-----------------------------------------------------------
# General pipeline commands
#-----------------------------------------------------------

ok $pSMRMONCOMMAND.parse('filter the recommendation matrix with rr, jj, kk, pp'),
'filter the recommendation matrix with rr, jj, kk, pp';


ok $pSMRMONCOMMAND.parse('show pipeline value'),
'show pipeline value';

done-testing;