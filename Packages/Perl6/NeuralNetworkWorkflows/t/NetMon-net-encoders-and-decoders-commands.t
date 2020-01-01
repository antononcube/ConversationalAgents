use v6;
use lib 'lib';
use NeuralNetworkWorkflows::Grammar;
use Test;

plan 5;

# Shortcut
my $pNETMONCOMMAND = NeuralNetworkWorkflows::Grammar::WorkflowCommmand;

#-----------------------------------------------------------
# Net encoders / decoders commands
#-----------------------------------------------------------

ok $pNETMONCOMMAND.parse('set encoder image 3d'),
'set encoder image 3d';

ok $pNETMONCOMMAND.parse('set class decoder'),
'set class decoder';

ok $pNETMONCOMMAND.parse('set decoder class using male female'),
'set decoder class using male female';

ok $pNETMONCOMMAND.parse('assign encoder audio mel spectrogram'),
'assign encoder audio mel spectrogram';

ok $pNETMONCOMMAND.parse('assign audio mfcc encoder'),
'assign audio mfcc encoder';

done-testing;
