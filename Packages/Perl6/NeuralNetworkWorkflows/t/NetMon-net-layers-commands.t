use v6;
use lib 'lib';
use NeuralNetworkWorkflows::Grammar;
use Test;

plan 7;

# Shortcut
my $pNETMONCOMMAND = NeuralNetworkWorkflows::Grammar::WorkflowCommmand;

#-----------------------------------------------------------
# Net layers commands
#-----------------------------------------------------------

ok $pNETMONCOMMAND.parse('an elementwise layer with Tanh'),
'an elementwise layer with Tanh';

ok $pNETMONCOMMAND.parse('net chain with elementwise layer then softmax layer'),
'net chain with elementwise layer then softmax layer';

ok $pNETMONCOMMAND.parse('ElementwiseLayer[HardTanh]->ConvolutionLayer[]->SoftmaxLayer'),
'ElementwiseLayer[HardTanh]->ConvolutionLayer[]->SoftmaxLayer';

ok $pNETMONCOMMAND.parse('ElementwiseLayer[HardTanh]⟹ConvolutionLayer[]⟹SoftmaxLayer[]'),
'ElementwiseLayer[HardTanh]⟹ConvolutionLayer[]⟹SoftmaxLayer[]';

ok $pNETMONCOMMAND.parse('ElementwiseLayer[HardSigmoid]->ConvolutionLayer[]->SoftmaxLayer[Input->{3,2}]'),
'ElementwiseLayer[HardSigmoid]->ConvolutionLayer[]->SoftmaxLayer[Input->{3,2}]';

ok $pNETMONCOMMAND.parse('an elementwise layer with Tanh then a convolution layer and softmax layer'),
'an elementwise layer with Tanh then a convolution layer and softmax layer';

ok $pNETMONCOMMAND.parse('an elementwise layer with Tanh then a convolution layer and softmax layer with input three by two'),
'an elementwise layer with Tanh then a convolution layer and softmax layer with input three by two';

done-testing;
