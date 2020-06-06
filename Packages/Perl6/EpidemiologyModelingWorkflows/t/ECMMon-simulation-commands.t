use v6;
use lib 'lib';
use EpidemiologyModelingWorkflows::Grammar;
use Test;

plan 9;

# Shortcut
my $pECMMONCOMMAND = EpidemiologyModelingWorkflows::Grammar::WorkflowCommand;

#-----------------------------------------------------------
# Simulations commands
#-----------------------------------------------------------

ok $pECMMONCOMMAND.parse('simulate'),
'simulate';

ok $pECMMONCOMMAND.parse('simulate over 365 days'),
'simulate over 365 days';

ok $pECMMONCOMMAND.parse('simulate for 365 days'),
'simulate for 365 days';

ok $pECMMONCOMMAND.parse('simulate over time range 365'),
'simulate over time range 365';

ok $pECMMONCOMMAND.parse('simulate for max time 365'),
'simulate for max time 365';

ok $pECMMONCOMMAND.parse('simulate over min time 0 max time 365'),
'simulate over min time 0 max time 365';

ok $pECMMONCOMMAND.parse('simulate over min time 0, max time 365'),
'simulate over min time 0, max time 365';

ok $pECMMONCOMMAND.parse('simulate over min time 0 max time 365 step 12'),
'simulate over min time 0 max time 365 step 12';

ok $pECMMONCOMMAND.parse('simulate over time range min 0 max 365'),
'simulate over time range min 0 max 365';

done-testing;
