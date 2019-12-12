use lib './lib';
use lib '.';
use LatentSemanticAnalysisWorkflows;


# my $*HIGHWATER = 0;
# my $*LASTRULE = 0;

# say LatentSemanticAnalysisWorkflowsGrammar::Latent-semantic-analysis-workflow-commmand.parse("create the document term matrix");
#
# say LatentSemanticAnalysisWorkflowsGrammar::Latent-semantic-analysis-workflow-commmand.parse("apply lsi functions idf, none, cosine");

# say "\n=======\n";
#

#
say "\n=======\n";
#

# say to_LSAMon_WL('
# use lsa object lsaObj;
# apply lsi functions idf, none, cosine;
# extract 12 topics;
# ');

say "\n=======\n";

say to_LSAMon_WL('
create from aText;
make document term matrix with no stemming and automatic stop words;
apply lsi functions global weight function idf, local term weight function none, normalizer function cosine;
extract 12 topics using method NNMF and max steps 12;
show topics table with 12 columns and 10 terms;
show thesaurus table for sing, left, home;
');

say "\n=======\n";

say to_LSAMon_R('
create from aText;
make document term matrix with no stemming and automatic stop words;
apply lsi functions global weight function idf, local term weight function none, normalizer function cosine;
extract 12 topics using method NNMF and max steps 12;
show topics table with 12 columns and 10 terms;
show thesaurus table for sing, left, home;
');

say "\n=======\n";

say to_LSAMon_Py('
create from aText;
make document term matrix with no stemming and automatic stop words;
apply lsi functions global weight function idf, local term weight function none, normalizer function cosine;
extract 12 topics using method NNMF and max steps 12;
show topics table with 12 columns and 10 terms;
show thesaurus table for sing, left, home;
');
