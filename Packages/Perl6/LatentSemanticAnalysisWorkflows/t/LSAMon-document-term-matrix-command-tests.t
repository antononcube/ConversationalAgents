use v6;
use lib 'lib';
use LatentSemanticAnalysisWorkflows::Grammar;
use Test;

plan 5;

# Shortcut
my $pLSAMONCOMMAND = LatentSemanticAnalysisWorkflows::Grammar::WorkflowCommmand;

#-----------------------------------------------------------
# Make document-term matrix command tests
#-----------------------------------------------------------

ok $pLSAMONCOMMAND.parse('create a document term matrix'),
'create a document term matrix';

ok $pLSAMONCOMMAND.parse('make the document word matrix'),
'make the document word matrix';

ok $pLSAMONCOMMAND.parse('make the document word matrix using no stop words'),
'make the document word matrix using no stop words';

ok $pLSAMONCOMMAND.parse('make the document term matrix using automatic stop words and automatic stemming rules'),
'make the document term matrix using automatic stop words and automatic stemming rules';

ok $pLSAMONCOMMAND.parse('make document term matrix with no stemming rules and no stop words'),
'make document term matrix with no stemming rules and no stop words';


done-testing;
