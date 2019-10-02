use lib './lib';
use lib '.';
use LatentSemanticAnalysisWorkflows;
use LatentSemanticAnalysisWorkflowsGrammar;

# my $*HIGHWATER = 0;
# my $*LASTRULE = 0;

say LatentSemanticAnalysisWorkflowsGrammar::Latent-semantic-analysis-workflow-commmand.parse("create the document term matrix");

# say "\n=======\n";
#
# say to_LSAMon_R("create the document term matrix");
#
# say to_LSAMon_WL("create the document term matrix");
#
# say "\n=======\n";
#

# say to_LSAMon_WL('
# create the document term matrix;
# apply to the matrix entries idf;
# extract 23 topics with the method NNMF and max steps 12;
# extract statistical thesaurus with 12 synonyms
# ')
