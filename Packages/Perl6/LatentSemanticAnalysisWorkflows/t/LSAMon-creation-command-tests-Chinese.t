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

# use lsa object lsaObj
ok $pLSAMONCOMMAND.parse('使用 lsa 对象 lsaObj'),
'使用 lsa 对象 lsaObj';

# use lsa object lsaObj
ok $pLSAMONCOMMAND.parse('使用 lsa 對象 lsaObj'),
'使用 lsa 對象 lsaObj';

# use lsa object lsaObj
ok $pLSAMONCOMMAND.parse('shǐyòng lsa duìxiàng lsaObj'),
'shǐyòng lsa duìxiàng lsaObj';

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
