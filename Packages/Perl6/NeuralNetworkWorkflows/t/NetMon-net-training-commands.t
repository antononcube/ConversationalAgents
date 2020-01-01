use v6;
use lib 'lib';
use lib '../lib';
use lib './lib';
use NeuralNetworkWorkflows::Grammar;
use Test;

plan 5;

# Shortcut
my $pNETMONCOMMAND = NeuralNetworkWorkflows::Grammar::WorkflowCommmand;

#-----------------------------------------------------------
# Net training commands
#-----------------------------------------------------------

ok $pNETMONCOMMAND.parse('train'),
'train';

ok $pNETMONCOMMAND.parse('train it'),
'train it';

ok $pNETMONCOMMAND.parse('train the chain'),
'train the chain';

ok $pNETMONCOMMAND.parse('train the network for 20 epochs'),
'train the network for 20 epochs';

ok $pNETMONCOMMAND.parse('train the net for 10 days with batch size 128'),
'train the net for 10 days with batch size 128';

done-testing;