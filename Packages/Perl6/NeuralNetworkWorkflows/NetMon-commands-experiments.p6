use lib './lib';
use lib '.';
use NeuralNetworkWorkflows;


# my $*HIGHWATER = 0;
# my $*LASTRULE = 0;

say NeuralNetworkWorkflows::Grammar::WorkflowCommmand.subparse('train the network for 20 epochs');

#say NeuralNetworkWorkflows::Grammar::WorkflowCommmand.parse('an elementwise layer with Tanh then a convolution layer and softmax layer');
#
# say NeuralNetworkWorkflows::Grammar::WorkflowCommmand.parse('train the chain');

#
#say "\n=======\n";
#
#say to_NetMon_WL('
#create from aText;
#make document term matrix with no stemming and automatic stop words;
#echo data summary;
#apply lsi functions global weight function idf, local term weight function none, normalizer function cosine;
#extract 12 topics using method NNMF and max steps 12;
#show topics table with 12 columns and 10 terms;
#show thesaurus table for sing, left, home;
#');
#
#say "\n=======\n";
#
#say to_NetMon_R('
#create from aText;
#make document term matrix with no stemming and automatic stop words;
#echo data summary;
#apply lsi functions global weight function idf, local term weight function none, normalizer function cosine;
#extract 12 topics using method NNMF and max steps 12;
#show topics table with 12 columns and 10 terms;
#show thesaurus table for sing, left, home;
#');
#
#say "\n=======\n";
#
#say to_NetMon_Py('
#create from aText;
#make document term matrix with no stemming and automatic stop words;
#echo data summary;
#apply lsi functions global weight function idf, local term weight function none, normalizer function cosine;
#extract 12 topics using method NNMF and max steps 12;
#show topics table with 12 columns and 10 terms;
#show thesaurus table for sing, left, home;
#');
