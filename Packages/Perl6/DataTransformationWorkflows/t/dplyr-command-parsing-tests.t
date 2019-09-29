use Test;
use lib '../lib';
use lib './lib';
use DataTransformationWorkflowsGrammar;

plan 8;

# Shortcut
my $pDPLYRCOMMAND = DataTransformationWorkflowsGrammar::Data-transformation-workflow-commmand;

#-----------------------------------------------------------
# Data load
#-----------------------------------------------------------

ok $pDPLYRCOMMAND.parse('load data'),
'load data';


#-----------------------------------------------------------
# Column selection
#-----------------------------------------------------------

ok $pDPLYRCOMMAND.parse('select the columns cyl, mpg and gear'),
'select the columns cyl, mpg, and gear';

ok $pDPLYRCOMMAND.parse('keep only the variable cyl'),
'keep only the variable cyl';

ok $pDPLYRCOMMAND.parse('keep only cyl and gear'),
'keep only cyl and gear';


#-----------------------------------------------------------
# Mutation
#-----------------------------------------------------------

ok $pDPLYRCOMMAND.parse('mutate mass1 := mass, const <- 100'),
'mutate mass1 := mass, const <- 100';


#-----------------------------------------------------------
# Groping
#-----------------------------------------------------------

ok $pDPLYRCOMMAND.parse('group over mass, mass1 & const'),
'group over mass, mass1 & const';


#-----------------------------------------------------------
# Summarization
#-----------------------------------------------------------

ok $pDPLYRCOMMAND.parse('find counts'),
'find counts';


#-----------------------------------------------------------
# Sorting
#-----------------------------------------------------------

ok $pDPLYRCOMMAND.parse('arrange by n'),
'arrange by n';




done-testing;
