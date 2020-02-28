use v6;
use lib 'lib';
use LatentSemanticAnalysisWorkflows::Grammar;
use Test;

plan 6;

# Shortcut
my $pLSAMONCOMMAND = LatentSemanticAnalysisWorkflows::Grammar::WorkflowCommmand;


#-----------------------------------------------------------
# Creation
#-----------------------------------------------------------

ok $pLSAMONCOMMAND.parse('use lsa object lsaObj'),
'use lsa object lsaObj';

ok $pLSAMONCOMMAND.parse('use object lsaObj2'),
'use object lsaObj2';

ok $pLSAMONCOMMAND.parse('create from aText'),
'create from aText';

ok $pLSAMONCOMMAND.parse('create a simple object'),
'create a simple object';

ok $pLSAMONCOMMAND.parse('create object'),
'create object';

ok $pLSAMONCOMMAND.parse('simple object creation'),
'simple object creation';




done-testing;
