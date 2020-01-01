use v6;
use lib 'lib';
use NeuralNetworkWorkflows::Grammar;
use Test;

plan 3;

# Shortcut
my $pNETMONCOMMAND = NeuralNetworkWorkflows::Grammar::WorkflowCommmand;

#-----------------------------------------------------------
# Net operations commands
#-----------------------------------------------------------

ok $pNETMONCOMMAND.parse('make the network state object for dfdf'),
'make the network state object for dfdf';

ok $pNETMONCOMMAND.parse('create net state of dsfddfd'),
'create net state of dsfddfd';

ok $pNETMONCOMMAND.parse('initialize the network mynet'),
'initialize the network mynet';

done-testing;
