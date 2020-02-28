use v6;
use lib 'lib';
use LatentSemanticAnalysisWorkflows::Grammar;
use Test;

plan 43;

# Shortcut
my $pLSAMONCOMMAND = LatentSemanticAnalysisWorkflows::Grammar::WorkflowCommmand;


#-----------------------------------------------------------
# Statistics command tests
#-----------------------------------------------------------

ok $pLSAMONCOMMAND.parse('compute the document term statistics'),
'compute the document term statistics';

ok $pLSAMONCOMMAND.parse('show the term document histogram'),
'show the term document histogram';




done-testing;
