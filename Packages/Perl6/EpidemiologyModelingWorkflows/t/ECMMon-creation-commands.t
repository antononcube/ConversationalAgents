use v6;
use lib 'lib';
use EpidemiologyModelingWorkflows::Grammar;
use Test;

plan 12;

# Shortcut
my $pECMMONCOMMAND = EpidemiologyModelingWorkflows::Grammar::WorkflowCommand;

#-----------------------------------------------------------
# Creation commands
#-----------------------------------------------------------

ok $pECMMONCOMMAND.parse('create with sir'),
'create with sir';

ok $pECMMONCOMMAND.parse('create with seir'),
'create with seir';

ok $pECMMONCOMMAND.parse('create with sei2r'),
'create with sei2r';

ok $pECMMONCOMMAND.parse('create using sei2hr'),
'create using sei2hr';

ok $pECMMONCOMMAND.parse('create with economic sei2hr'),
'create with economic sei2hr';

ok $pECMMONCOMMAND.parse('create object with susceptible infected recovered'),
'create object with susceptible infected recovered';

ok $pECMMONCOMMAND.parse('create object with susceptible exposed infected recovered'),
'create object with susceptible exposed infected recovered';

ok $pECMMONCOMMAND.parse('create object with susceptible exposed infected two recovered'),
'create object with susceptible exposed infected two recovered';

ok $pECMMONCOMMAND.parse('create using susceptible exposed two infected recovered'),
'create using susceptible exposed two infected recovered';

ok $pECMMONCOMMAND.parse('create using economics susceptible exposed two infected recovered'),
'create using economics susceptible exposed two infected recovered';

ok $pECMMONCOMMAND.parse('create using susceptible exposed two infected recovered with economy'),
'create using susceptible exposed two infected recovered with economy';


done-testing;