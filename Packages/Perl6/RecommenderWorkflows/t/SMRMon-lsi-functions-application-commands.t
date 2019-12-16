use v6;
use lib 'lib';
use RecommenderWorkflows::Grammar;
use Test;

plan 11;

# Shortcut
my $pSMRMONCOMMAND = RecommenderWorkflows::Grammar::WorkflowCommand;


#-----------------------------------------------------------
# LSI command tests
#-----------------------------------------------------------

ok $pSMRMONCOMMAND.parse('apply to the entries idf'),
'apply to the entries idf';

ok $pSMRMONCOMMAND.parse('apply to the matrix idf'),
'apply to the matrix idf';

ok $pSMRMONCOMMAND.parse('apply to the matrix entries idf'),
'apply to the matrix entries idf';

ok $pSMRMONCOMMAND.parse('apply to item term matrix entries the functions cosine'),
'apply to item term matrix entries the functions cosine';

ok $pSMRMONCOMMAND.parse('apply to the matrix entries lsi functions frequency'),
'apply to the matrix entries lsi functions frequency';

ok $pSMRMONCOMMAND.parse('apply to matrix entries idf, cosine and binary'),
'apply to matrix entries idf, cosine and binary';

ok $pSMRMONCOMMAND.parse('apply to the matrix entries idf, binary and cosine normalization'),
'apply to the matrix entries idf, binary and cosine normalization';

ok $pSMRMONCOMMAND.parse('apply lsi functions idf, none, cosine'),
'apply lsi functions idf, none, cosine';

ok $pSMRMONCOMMAND.parse('use the lsi functions idf none cosine'),
'use the lsi functions idf none cosine';

ok $pSMRMONCOMMAND.parse('apply lsi functions global weight function idf, local term weight function none, normalizer function cosine'),
'apply lsi functions global weight function idf, local term weight function none, normalizer function cosine';

ok $pSMRMONCOMMAND.parse('apply the lsi normalization function cosine'),
'apply the lsi normalization function cosine';

done-testing;