#==============================================================================
#
#   Neural Network workflows grammar in Raku Perl 6
#   Copyright (C) 2020  Anton Antonov
#
#   This program is free software: you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation, either version 3 of the License, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
#   Written by Anton Antonov,
#   antononcube @ gmai l . c om,
#   Windermere, Florida, USA.
#
#==============================================================================
#
#   For more details about Raku Perl6 see https://perl6.org/ .
#
#==============================================================================
#
#  The grammar design in this file follows very closely the EBNF grammar
#  for Mathematica in the GitHub file:
#    https://github.com/antononcube/ConversationalAgents/blob/master/EBNF/English/Mathematica/NeuralNetworkSpecificationsGrammar.m
#
#==============================================================================

use v6;
use NeuralNetworkWorkflows::Grammar::CommonParts;
use NeuralNetworkWorkflows::Grammar::PipelineCommand;

grammar NeuralNetworkWorkflows::Grammar::WorkflowCommmand
        does NeuralNetworkWorkflows::Grammar::PipelineCommand
        does NeuralNetworkWorkflows::Grammar::CommonParts {
    # TOP
    rule TOP {
        <repository-query> | <net-layer-chain> |
        <net-training-command> | <net-operation-command> |
        <net-coder-command> | <net-loss-func-command> |
        <net-info-command> }

    # Repository query command
    rule repository-query { <list-networks> | <how-many> }
    rule list-networks {<list-directive> <.the-determiner>? [ 'names' 'of' <.the-determiner>? ]? [ 'available' ]? <neural-networks>}
    rule how-many {[ 'how' 'many' | 'what' 'is' <.the-determiner>? 'number' 'of' <.the-determiner>? ] <neural-networks> [ 'in' <.the-determiner>? 'repository' ]?}

    # Net Layer Chain command
    rule net-layer-chain { <net-layer-chain-opening>? <layer-list>}
    rule net-layer-chain-opening {['net']? 'chain' <with-preposition> }
    rule layer-list {[ <layer-spec> | <layer-name-spec> ]+ % <layer-list-delimiter> }
    rule layer-list-delimiter { <list-separator> | 'then' | '->' |  '==>' | '⟹' | '\[DoubleLongRightArrow]' }
    rule layer-spec {<layer> [ [ '[' ']' | '[' [ <layer-func-name> | <layer-common-func> | <number-value> ] ']' ] ]?}
    rule layer-name-spec { [ <a-determiner> | <the-determiner> ]? <layer-name> [ <using-preposition> [ <layer-func-name> | <layer-common-func> | <number-value> ] ]?}
    rule layer {
        'AggregationLayer' | 'AppendLayer' |
        'BasicRecurrentLayer' | 'BatchNormalizationLayer' | 'CatenateLayer' |
        'ConstantArrayLayer' | 'ConstantPlusLayer' | 'ConstantTimesLayer' |
        'ContrastiveLossLayer' | 'ConvolutionLayer' | 'CrossEntropyLossLayer'|
        'CTCLossLayer' | 'DeconvolutionLayer' | 'DotLayer' | 'DotPlusLayer' |
        'DropoutLayer' | 'ElementwiseLayer' | 'EmbeddingLayer' |
        'FlattenLayer' | 'GatedRecurrentLayer' | 'ImageAugmentationLayer' |
        'InstanceNormalizationLayer' | 'LinearLayer' |
        'LocalResponseNormalizationLayer' | 'LongShortTermMemoryLayer' |
        'MeanAbsoluteLossLayer' | 'MeanSquaredLossLayer' | 'PaddingLayer' |
        'PartLayer' | 'pLayer' | 'PoolingLayer' | 'ReplicateLayer' |
        'ReshapeLayer' | 'ResizeLayer' | 'SequenceAttentionLayer' |
        'SequenceLastLayer' | 'SequenceMostLayer' | 'SequenceRestLayer' |
        'SequenceReverseLayer' | 'SoftmaxLayer' |
        'SpatialTransformationLayer' | 'SummationLayer' | 'ThreadingLayer' |
        'TotalLayer' | 'TransposeLayer' | 'UnitVectorLayer'}

    rule layer-name {
        'aggregation' 'layer' | 'append' 'layer' |
        'basic' 'recurrent' 'layer' | 'batch' 'normalization' 'layer' |
        'catenate' 'layer' | 'constant' 'array' 'layer' | 'constant' 'plus' 'layer' |
        'constant' 'times' 'layer' | 'contrastive' 'loss' 'layer' |
        'convolution' 'layer' | 'cross' 'entropy' 'loss' 'layer' | 'loss' 'layer' |
        'deconvolution' 'layer' | 'dot' 'layer' | 'dot' 'plus' 'layer' |
        'dropout' 'layer' | 'elementwise' 'layer' | 'embedding' 'layer' |
        'flatten' 'layer' | 'gated' 'recurrent' 'layer' | 'image' 'augmentation' 'layer' |
        'instance' 'normalization' 'layer' | 'linear' 'layer' |
        'local' 'response' 'normalization' 'layer' |
        'long' 'short' 'term' 'memory' 'layer' | 'mean' 'absolute' 'loss' 'layer' |
        'mean' 'squared' 'loss' 'layer' | 'padding' 'layer' |
        'part' 'layer' | 'layer' | 'pooling' 'layer' | 'replicate' 'layer' |
        'reshape' 'layer' | 'resize' 'layer' | 'sequence' 'attention' 'layer' |
        'sequence' 'last' 'layer' | 'sequence' 'most' 'layer' | 'sequence' 'rest' 'layer' |
        'sequence' 'reverse' 'layer' | 'softmax' 'layer' |
        'spatial' 'transformation' 'layer' | 'summation' 'layer' |
        'threading' 'layer' | 'total' 'layer' | 'transpose' 'layer' | 'unit' 'vector' 'layer'}

    rule layer-func-name {
        'RectifiedLinearUnit' | 'ReLU' |
        'ExponentialLinearUnit' | 'ELU' | 'ScaledExponentialLinearUnit' |
        'SELU' | 'SoftSign' | 'SoftPlus' | 'HardTanh' | 'HardSigmoid' | 'Sigmoid' }

    rule layer-common-func { 'Tanh' | 'Ramp' | 'Total' }

    # Net Training command
    rule net-training-command { <net-training-spec-command> | <net-train-it> }
    rule net-train-it {<train-directive> [ 'it' | <.the-determiner>? [ <neural-network> | <neural-network-chain> | <neural-network-graph> ] ]?}
    rule net-training-spec-command {<training-opening> <training-spec-list>}
    rule training-opening {'train' <.the-determiner>? <neural-network>}
    rule training-spec-list { <training-spec>+ % <list-separator>? }
    rule training-spec { <training-epochs-spec> | <training-time-spec> | <training-batch-spec> }
    rule training-epochs-spec { [ <.using-preposition> | <.for-preposition> ]? <integer-value> [ 'epochs' | 'rounds' ]}
    rule training-time-spec { [ <using-preposition> | <for-preposition> ]? <number-value> <training-time-unit> }
    rule training-time-unit { 'second' | 'seconds' | 'minute' | 'minutes' | 'hour' | 'hours' | 'day' | 'days' }
    rule training-batch-spec {[ <.with-preposition>? 'batch' 'size'] <integer-value> }

    # Net Operation command
    rule net-operation-command { <net-state-command> | <net-initialize-command> }
    rule net-state-command { [<generate-directive> <.the-determiner>? <neural-network> 'state' [ 'object' ]? <.for-preposition>] <net-reference>}
    rule net-initialize-command { ['initialize' <.the-determiner>? <neural-network>] <net-reference>}
    rule net-reference { <variable-name> }

    # Net coder command
    rule net-coder-command { <set-directive> [ <encoder-spec> | <decoder-spec> ] }
    rule decoder-type {'decoder'}
    rule decoder-spec {[ <decoder-type> [ <decoder> | <decoder-name> ] | [ <decoder> | <decoder-name> ] <decoder-type> ] [ <with-preposition> <parameters-list> ]?}

    rule decoder { 'Boolean' | 'Characters' | 'Class' | 'CTCBeamSearch' | 'Image' | 'Image3D' | 'Scalar' | 'Tokens' }
    rule decoder-name { 'boolean' | 'characters' | 'class' | 'ctc' 'beam' 'search' | 'image' | 'image' '3d' | 'scalar' | 'tokens' }
    rule encoder-type {'encoder'}
    rule encoder-spec {[ <encoder-type> [ <encoder> | <encoder-name> ] | [ <encoder> | <encoder-name> ] <encoder-type> ] [ <with-preposition> <parameters-list> ]?}
    rule encoder { 'Audio' | 'AudioMelSpectrogram' | 'AudioMFCC' | 'AudioSpectrogram' | 'AudioSTFT' | 'Boolean' | 'Characters' | 'Class' | 'Function' | 'Image' | 'Image3D' | 'Scalar' | 'Tokens' | 'UTF8' }
    rule encoder-name { 'audio' | 'audio' 'mel' 'spectrogram' | 'audio' 'mfcc' | 'audio' 'spectrogram' | 'audio' 'stft' | 'boolean' | 'characters' | 'class' | 'function' | 'image' | 'image' '3d' | 'scalar' | 'tokens' | 'utf8' }
    rule parameters-list {[ <parameter> ]+}
    rule parameter { <variable-name> }

    # Net Loss Func Command
    rule net-loss-func-command { [<set-directive> [ <loss-function-phrase> ]?] <loss-func-spec>}
    rule loss-function-phrase {'loss' 'function'}
    rule loss-func-spec {[ <loss-func> | <loss-func-name> ]}
    rule loss-func { 'MeanAbsoluteLossLayer' | 'MeanSquaredLossLayer' | 'CrossEntropyLossLayer' | 'CTCLossLayer' | 'ContrastiveLossLayer' }
    rule loss-func-name {[ 'mean' 'absolute' 'loss' 'layer' | 'mean' 'squared' 'loss' 'layer' | 'cross' 'entropy' 'loss' 'layer' | 'ctc' 'loss' 'layer' | 'contrastive' 'loss' 'layer' ]}

    # Net info command
    rule net-info-command { <display-directive>? <net-info-spec>}
    rule net-info-spec { <net-info-property> | <net-info-property-name> }
    rule net-info-property {
        'Arrays' | 'ArraysByteCounts' |
        'ArraysCount' | 'ArraysDimensions' | 'ArraysElementCounts' |
        'ArraysList' | 'ArraysPositionList' | 'ArraysSizes' |
        'ArraysTotalByteCount' | 'ArraysTotalElementCount' |
        'ArraysTotalSize' | 'FullSummaryGraphic' | 'InputForm' |
        'InputPortNames' | 'InputPorts' | 'Layers' | 'LayersCount' |
        'LayersGraph' | 'LayersList' | 'LayerTypeCounts' | 'MXNetNodeGraph' |
        'MXNetNodeGraphPlot' | 'OutputPortNames' | 'OutputPorts' |
        'Properties' | 'RecurrentStatesCount' | 'RecurrentStatesPositionList'|
        'SharedArraysCount' | 'SummaryGraphic' | 'TopologyHash' }

    # Error message
    # method error($msg) {
    #   my $parsed = self.target.substr(0, self.pos).trim-trailing;
    #   my $context = $parsed.substr($parsed.chars - 15 max 0) ~ '⏏' ~ self.target.substr($parsed.chars, 15);
    #   my $line-no = $parsed.lines.elems;
    #   die "Cannot parse code: $msg\n" ~ "at line $line-no, around " ~ $context.perl ~ "\n(error location indicated by ⏏)\n";
    # }

    method ws() {
        if self.pos > $*HIGHWATER {
            $*HIGHWATER = self.pos;
            $*LASTRULE = callframe(1).code.name;
        }
        callsame;
    }

    method parse($target, |c) {
        my $*HIGHWATER = 0;
        my $*LASTRULE;
        my $match = callsame;
        self.error_msg($target) unless $match;
        return $match;
    }

    method subparse($target, |c) {
        my $*HIGHWATER = 0;
        my $*LASTRULE;
        my $match = callsame;
        self.error_msg($target) unless $match;
        return $match;
    }

    method error_msg($target) {
        my $parsed = $target.substr(0, $*HIGHWATER).trim-trailing;
        my $un-parsed = $target.substr($*HIGHWATER, $target.chars).trim-trailing;
        my $line-no = $parsed.lines.elems;
        my $msg = "Cannot parse the command";
        # say 'un-parsed : ', $un-parsed;
        # say '$*LASTRULE : ', $*LASTRULE;
        $msg ~= "; error in rule $*LASTRULE at line $line-no" if $*LASTRULE;
        $msg ~= "; target '$target' position $*HIGHWATER";
        $msg ~= "; parsed '$parsed', un-parsed '$un-parsed'";
        $msg ~= ' .';
        say $msg;
    }
}
