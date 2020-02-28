use v6;
use lib 'lib';
use LatentSemanticAnalysisWorkflows::Grammar;
use Test;

plan 6;

# Shortcut
my $pLSAMONCOMMAND = LatentSemanticAnalysisWorkflows::Grammar::WorkflowCommmand;

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


done-testing;
