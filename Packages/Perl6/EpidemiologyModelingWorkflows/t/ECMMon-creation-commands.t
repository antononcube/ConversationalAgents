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

ok $pECMMONCOMMAND.parse('create with sei2hrecon'),
'create with sei2hrecon';

ok $pECMMONCOMMAND.parse('create with economic sei2hr'),
'create with economic sei2hr';

ok $pECMMONCOMMAND.parse('create with sei2hr model'),
'create with sei2hr model';

ok $pECMMONCOMMAND.parse('create with sei2hr single site model'),
'create with sei2hr single site model';

ok $pECMMONCOMMAND.parse('create object with sei2hr model'),
'create object with sei2hr model';

ok $pECMMONCOMMAND.parse('create object with susceptible infected recovered model'),
'create object with susceptible infected recovered model';

ok $pECMMONCOMMAND.parse('create object with susceptible exposed infected recovered single site model'),
'create object with susceptible exposed infected recovered single site model';

ok $pECMMONCOMMAND.parse('create object with susceptible exposed infected two recovered'),
'create object with susceptible exposed infected two recovered';

ok $pECMMONCOMMAND.parse('create using susceptible exposed two infected recovered'),
'create using susceptible exposed two infected recovered';

ok $pECMMONCOMMAND.parse('create using economics susceptible exposed two infected recovered'),
'create using economics susceptible exposed two infected recovered';

ok $pECMMONCOMMAND.parse('create using economics model for susceptible exposed two infected recovered'),
'create using economics model for susceptible exposed two infected recovered';

ok $pECMMONCOMMAND.parse('create using susceptible exposed two infected recovered with economy'),
'create using susceptible exposed two infected recovered with economy';


done-testing;