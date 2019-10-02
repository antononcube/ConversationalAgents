use Test;
use lib '../lib';
use lib './lib';
use LatentSemanticAnalysisWorkflowsGrammar;

plan 18;

# Shortcut
my $pLSAMONCOMMAND = LatentSemanticAnalysisWorkflowsGrammar::Latent-semantic-analysis-workflow-commmand;

#-----------------------------------------------------------
# Make document-term matrix command tests
#-----------------------------------------------------------

ok $pLSAMONCOMMAND.parse('create a document term matrix'),
'create a document term matrix';

ok $pLSAMONCOMMAND.parse('make the document word matrix'),
'make the document word matrix';

#-----------------------------------------------------------
# Statistics command tests
#-----------------------------------------------------------

ok $pLSAMONCOMMAND.parse('compute the document term statistics'),
'compute the document term statistics';

ok $pLSAMONCOMMAND.parse('show the term document histogram'),
'show the term document histogram';

#-----------------------------------------------------------
# LSI command tests
#-----------------------------------------------------------

ok $pLSAMONCOMMAND.parse('apply to the entries idf'),
'apply to the entries idf';

ok $pLSAMONCOMMAND.parse('apply to the matrix idf'),
'apply to the matrix idf';

ok $pLSAMONCOMMAND.parse('apply to the matrix entries idf'),
'apply to the matrix entries idf';

ok $pLSAMONCOMMAND.parse('apply to item term matrix entries the functions cosine'),
'apply to item term matrix entries the functions cosine';

ok $pLSAMONCOMMAND.parse('apply to the matrix entries lsi functions frequency'),
'apply to the matrix entries lsi functions frequency';

ok $pLSAMONCOMMAND.parse('apply to matrix entries idf, cosine and binary'),
'apply to matrix entries idf, cosine and binary';

ok $pLSAMONCOMMAND.parse('apply to the matrix entries idf, binary and cosine normalization'),
'apply to the matrix entries idf, binary and cosine normalization';


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

ok $pLSAMONCOMMAND.parse('extract 23 topics with the method NNMF'),
'extract 23 topics with the method NNMF';

#-----------------------------------------------------------
# Extract statistical thesaurus command tests
#-----------------------------------------------------------

ok $pLSAMONCOMMAND.parse('extract statistical thesaurus'),
'extract statistical thesaurus';

ok $pLSAMONCOMMAND.parse('extract statistical thesaurus with 12 synonyms'),
'extract statistical thesaurus with 12 synonyms';

done-testing;
