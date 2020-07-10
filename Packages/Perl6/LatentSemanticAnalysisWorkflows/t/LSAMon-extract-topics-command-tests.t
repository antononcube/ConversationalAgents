use v6;
use lib 'lib';
use LatentSemanticAnalysisWorkflows::Grammar;
use Test;

plan 13;

# Shortcut
my $pLSAMONCOMMAND = LatentSemanticAnalysisWorkflows::Grammar::WorkflowCommand;

#-----------------------------------------------------------
# Extract topics command tests
#-----------------------------------------------------------

ok $pLSAMONCOMMAND.parse('extract 60 topics'),
'extract 60 topics';

ok $pLSAMONCOMMAND.parse('extract 23 topics using SVD'),
'extract 23 topics using SVD';

ok $pLSAMONCOMMAND.parse('extract 23 topics using max steps 12'),
'extract 23 topics using max steps 12';

ok $pLSAMONCOMMAND.parse('extract 23 topics using 20 maximum iterations'),
'extract 23 topics using 20 maximum iterations';

ok $pLSAMONCOMMAND.parse('extract 23 topics with the method NonNegativeMatrixFactorization'),
'extract 23 topics with the method NonNegativeMatrixFactorization';

ok $pLSAMONCOMMAND.parse('extract 30 topics with the method ica and 20 max steps'),
'extract 23 topics with the method ica and 20 max steps';

ok $pLSAMONCOMMAND.parse('extract 30 topics with method SVD and maximum iterations 20'),
'extract 23 topics with the method NNMF and 20 max steps';

ok $pLSAMONCOMMAND.parse('extract 30 topics with NNMF and steps 20'),
'extract 23 topics with NNMF and steps 20';

ok $pLSAMONCOMMAND.parse('extract 30 topics with nnmf, max steps 20, and min number of documents per term 100'),
'extract 30 topics with nnmf, max steps 20, and min number of documents per term 100';

#-----------------------------------------------------------
# Show topics table
#-----------------------------------------------------------

ok $pLSAMONCOMMAND.parse('show topics table'),
'show topics table';

ok $pLSAMONCOMMAND.parse('show topics table with 6 columns'),
'show topics table with 6 columns';

ok $pLSAMONCOMMAND.parse('show topics table with 12 columns and 10 terms'),
'show topics table with 12 columns and 10 terms';

ok $pLSAMONCOMMAND.parse('echo topics table with number of table columns 12 and number of terms 20'),
'echo topics table with number of table columns 12 and number of terms 20';

done-testing;
