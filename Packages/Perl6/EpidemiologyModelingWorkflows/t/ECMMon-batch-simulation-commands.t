use v6;
use lib 'lib';
use EpidemiologyModelingWorkflows::Grammar;
use Test;

plan 5;

# Shortcut
my $pECMMONCOMMAND = EpidemiologyModelingWorkflows::Grammar::WorkflowCommand;

#-----------------------------------------------------------
# Batch simulation commands
#-----------------------------------------------------------

ok $pECMMONCOMMAND.parse('batch simulate using dfParameters'),
'batch simulate using dfParameters';

ok $pECMMONCOMMAND.parse('batch simulate over dfParameters with max time 240'),
'batch simulate over dfParameters with max time 240';

ok $pECMMONCOMMAND.parse('batch simulate using max time 240 over dfParameters'),
'batch simulate using max time 240 over dfParameters';

ok $pECMMONCOMMAND.parse('batch simulate with aip in c(10, 40, 60) for max time 365'),
'batch simulate with aip in c(10, 40, 60) for max time 365';

ok $pECMMONCOMMAND.parse('batch simulate with aip = seq(20, 40, 10), aincp = seq(6, 18, 6) and lpcr = 0 for max time 365'),
'batch simulate with aip = seq(20, 40, 10), aincp = seq(6, 18, 6) and lpcr = 0 for max time 365';

done-testing;