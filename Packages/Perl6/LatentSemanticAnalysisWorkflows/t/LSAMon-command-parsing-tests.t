use v6;
use lib 'lib';
use LatentSemanticAnalysisWorkflows::Grammar;
use Test;

plan 43;

# Shortcut
my $pLSAMONCOMMAND = LatentSemanticAnalysisWorkflows::Grammar::WorkflowCommmand;


#-----------------------------------------------------------
# Creation
#-----------------------------------------------------------

ok $pLSAMONCOMMAND.parse('use lsa object lsaObj'),
'use lsa object lsaObj';

ok $pLSAMONCOMMAND.parse('use object lsaObj2'),
'use object lsaObj2';


#-----------------------------------------------------------
# Creation
#-----------------------------------------------------------

ok $pLSAMONCOMMAND.parse('create from aText'),
'create from aText';

ok $pLSAMONCOMMAND.parse('create a simple object'),
'create a simple object';

ok $pLSAMONCOMMAND.parse('create object'),
'create object';

ok $pLSAMONCOMMAND.parse('simple object creation'),
'simple object creation';


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

ok $pLSAMONCOMMAND.parse('apply lsi functions idf, none, cosine'),
'apply lsi functions idf, none, cosine';

ok $pLSAMONCOMMAND.parse('use the lsi functions idf none cosine'),
'use the lsi functions idf none cosine';

ok $pLSAMONCOMMAND.parse('apply lsi functions global weight function idf, local term weight function none, normalizer function cosine'),
'apply lsi functions global weight function idf, local term weight function none, normalizer function cosine';

ok $pLSAMONCOMMAND.parse('apply the lsi normalization function cosine'),
'apply the lsi normalization function cosine';

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
# Extract statistical thesaurus command tests
#-----------------------------------------------------------

ok $pLSAMONCOMMAND.parse('extract statistical thesaurus'),
'extract statistical thesaurus';

ok $pLSAMONCOMMAND.parse('extract statistical thesaurus with 12 synonyms'),
'extract statistical thesaurus with 12 synonyms';

ok $pLSAMONCOMMAND.parse('show statistical thesaurus of word1, word2, and word3' ),
'show statistical thesaurus of word1, word2, and word2';

ok $pLSAMONCOMMAND.parse('show statistical thesaurus of word1, word2, and word3 using 12 synonyms per word' ),
'show statistical thesaurus of word1, word2, and word2 using 12 synonyms per word';

ok $pLSAMONCOMMAND.parse('what are the top nearest neighbors of word1, word2, and word3' ),
'what are the top nearest neighbors of word1, word2, and word3';

ok $pLSAMONCOMMAND.parse('what are the nns of word1, word2, word3' ),
'what are the nns of word1, word2, word2';

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
