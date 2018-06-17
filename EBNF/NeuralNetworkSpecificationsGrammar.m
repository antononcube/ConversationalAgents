(*
    Classifier workflows grammar in EBNF
    Copyright (C) 2018  Anton Antonov

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.

	Written by Anton Antonov,
	antononcube @@@ gmail ... com,
	Windermere, Florida, USA.
*)

(* :Title: NeuralNetworkSpecificationsGrammar *)
(* :Context: NeuralNetworkSpecificationsGrammar` *)
(* :Author: Anton Antonov *)
(* :Date: 2018-06-13 *)

(* :Package Version: 0.1 *)
(* :Mathematica Version: *)
(* :Copyright: (c) 2018 Anton Antonov *)
(* :Keywords: *)
(* :Discussion:

   # In brief

   The Extended Backus-Naur Form (EBNF) grammar in this file is intended to be used in a natural language commands
   interface for the creation and testing of classifiers using the monad NetMon:

     https://github.com/antononcube/MathematicaForPrediction/blob/master/MonadicProgramming/MonadicNeuralNetworksTraining.m

   The grammar is partitioned into separate sub-grammars, each sub-grammar corresponding to a conceptual set of
   functionalities. (The intent is to facilitate understanding and further development.)


   # How to use

   This grammar is intended to be parsed by the functions in the Mathematica package FunctionalParses.m at GitHub,
   see https://github.com/antononcube/MathematicaForPrediction/blob/master/FunctionalParsers.m .

   (The file can be run in Mathematica with Get or Import.)


   # Example

   The following sequence of commands are parsed by the parsers generated with the grammar.

      Import["https://raw.githubusercontent.com/antononcube/ConversationalAgents/master/EBNF/NeuralNetworkSpecificationsGrammar.m"]
      Import["https://raw.githubusercontent.com/antononcube/MathematicaForPrediction/master/FunctionalParsers.m"]

      Keys[NetMonCommandsSubGrammars[]]

      TNetMonTokenizer = (ParseToTokens[#, {",", "'", "%", "-", "/", "[", "]", "\[DoubleLongRightArrow]", "->"}, {" ", "\t", "\n"}] &);

   Anton Antonov
   Oxford, UK
   2018-06-14
*)

If[Length[DownValues[FunctionalParsers`ParseToEBNFTokens]] == 0,
  Echo["FunctionalParsers.m", "Importing from GitHub:"];
  Import["https://raw.githubusercontent.com/antononcube/MathematicaForPrediction/master/FunctionalParsers.m"]
];


BeginPackage["NeuralNetworkSpecificationsGrammar`"]

pNETMONCOMMAND::usage = "Parses natural language commands for neural network specification and training."

NetMonCommandsSubGrammars::usage = "Gives an association of the EBNF sub-grammars for parsing natural language commands \
specifying NetMon pipelines construction."

NetMonCommandsGrammar::usage = "Gives as a string an EBNF grammar for parsing natural language commands \
specifying NetMon pipelines construction."

Begin["`Private`"]

Needs["FunctionalParsers`"]


(************************************************************)
(* Common parts                                             *)
(************************************************************)

ebnfCommonParts = "
  <determiner> = 'a' | 'an' | 'the' ;
  <list-delimiter> = 'and' | ',' | ',' , 'and' | 'together' , 'with' <@ ListDelimiter ;
  <with-preposition> =  'using' | 'by' | 'with' ;
  <using-preposition> = 'using' | 'with' | 'over' | 'for' ;
  <for-preposition> = 'for' | 'of' ;
  <number-value> = '_?NumberQ' <@ NumericValue ;
  <percent-value> = <number-value> <& ( '%' | 'percent' ) <@ PercentValue ;
  <boolean-value> = 'True' | 'False' | 'true' | 'false' <@ BooleanValue ;
  <display-directive> = 'show' | 'give' | 'display' <@ DisplayDirective ;
  <list-directive> = 'list' | <display-directive> <@ ListDirective ;
  <compute-directive> = 'compute' | 'calculate' | 'find' <@ ComputeDirective ;
  <compute-and-display> = <compute-directive> , [ 'and' &> <display-directive> ] <@ ComputeAndDisplay ;
  <generate-directive> = 'make' | 'create' | 'generate' <@ GenerateDirective ;
  <class-label> = '_String' <@ ClassLabel ;
  <neural-network> = [ 'neural' ] , ( 'net' | 'network' | 'model' ) ;
  <neural-networks> = [ 'neural' ] , ( 'nets' | 'networks' | 'models' ) ;
";


(************************************************************)
(* Repository queries                                       *)
(************************************************************)

ebnfRepositoryQuery = "
  <repository-query> = <list-networks> | <how-many> <@ NetRepositoryQuery ;
  <list-networks> = <list-directive> , [ 'the' ] , [ 'names' , 'of' , [ 'the' ] ] , [ 'available' ] , <neural-networks>
                    <@ ListNetworks@*Flatten@*List ;
  <how-many> = ( 'how' , 'many' | 'what' , 'is' , [ 'the' ] , 'number' , 'of' , [ 'the' ] ) , <neural-networks> ,
               [ 'in' , [ 'the' ] , 'repository' ] <@ HowMany@*Flatten@*List ;
";


(************************************************************)
(* Network training                                         *)
(************************************************************)

ebnfNetTraining = "
  <net-training-command> = <training-opening> &> <training-spec-list> <@ NetTrainingCommand ;
  <training-opening> = 'train' , [ 'the' ] , <neural-network> ;
  <training-spec-list> = <training-spec> , { [ <list-delimiter> ] &> <training-spec> } <@ NetTrainingSpecList ;
  <training-spec> = <training-epochs-spec> | <training-time-spec> | <training-batch-spec> ;
  <training-epochs-spec> =  [ <using-preposition> ] &> '_?IntegerQ' , ( 'epochs' | 'rounds' ) <@ NetTrainingEpochsSpec ;
  <training-time-spec> = [ <using-preposition> ] &> '_?NumberQ' , <training-time-unit> <@ NetTrainingTimeSpec ;
  <training-time-unit> =  'second' | 'seconds' | 'minute' | 'minutes' | 'hour' | 'hours' | 'day' | 'days'  <@ NetTrainingTimeUnit ;
  <training-batch-spec> = ( [ <with-preposition> ] , 'batch' , 'size' ) &> '_?IntegerQ' <@ NetTrainingBatchSize ;
";


(************************************************************)
(* Net state                                                *)
(************************************************************)

ebnfNetOperationCommand = "
  <net-operation-command> = <net-state-command> | <net-initialize-command> ;
  <net-state-command> = ( <generate-directive> &> [ 'the' ] , <neural-network> , 'state' , [ 'object' ] , <for-preposition> )
                        &>  <net-reference> <@ NetStateCommand ;
  <net-initialize-command> = ( 'initialize' , [ 'the' ] , <neural-network> ) &> <net-reference> <@ NetInitializeCommand ;
  <net-reference> = '_String' <@ NetReference ;
";


(************************************************************)
(* Net layer chain                                          *)
(************************************************************)

ebnfNetLayerChain = "
  <net-layer-chain> = [ <net-layer-chain-opening> ] &> <layer-list> <@ NetLayerChain ;
  <net-layer-chain-opening> = [ 'net' ] , 'chain' , <with-preposition> ;
  <layer-list> = ( <layer-spec> | <layer-name-spec> ), [ { <layer-list-delimiter> &> ( <layer-spec> | <layer-name-spec> ) } ]
                 <@ LayerList@*Flatten@*List ;
  <layer-list-delimiter> = <list-delimiter> | 'then' | '->' | '\[DoubleLongRightArrow]' ;
  <layer-spec> = <layer> , [ '[' , ']' | '[' &> ( <layer-func-name> | <layer-common-func> | '_String' ) <& ']' ]
                 <@ LayerSpec ;
  <layer-name-spec> = [ <determiner> ] &> ( <layer-name> ) ,
                      [ <using-preposition> &> ( <layer-func-name> | <layer-common-func> ) ]
                      <@ LayerNameSpec@*Flatten ;
  <layer> =  'AggregationLayer' | 'AppendLayer' | 'BasicRecurrentLayer' |
             'BatchNormalizationLayer' | 'CatenateLayer' | 'ConstantArrayLayer' |
             'ConstantPlusLayer' | 'ConstantTimesLayer' | 'ContrastiveLossLayer' |
             'ConvolutionLayer' | 'CrossEntropyLossLayer' | 'CTCLossLayer' |
             'DeconvolutionLayer' | 'DotLayer' | 'DotPlusLayer' | 'DropoutLayer' |
             'ElementwiseLayer' | 'EmbeddingLayer' | 'FlattenLayer' |
             'GatedRecurrentLayer' | 'ImageAugmentationLayer' |
             'InstanceNormalizationLayer' | 'LinearLayer' |
             'LocalResponseNormalizationLayer' | 'LongShortTermMemoryLayer' |
             'MeanAbsoluteLossLayer' | 'MeanSquaredLossLayer' | 'PaddingLayer' |
             'PartLayer' | 'pLayer' | 'PoolingLayer' | 'ReplicateLayer' |
             'ReshapeLayer' | 'ResizeLayer' | 'SequenceAttentionLayer' |
             'SequenceLastLayer' | 'SequenceMostLayer' | 'SequenceRestLayer' |
             'SequenceReverseLayer' | 'SoftmaxLayer' |
             'SpatialTransformationLayer' | 'SummationLayer' | 'ThreadingLayer' |
             'TotalLayer' | 'TransposeLayer' | 'UnitVectorLayer' <@ Layer ;
  <layer-name> = 'aggregation' , 'layer' | 'append' , 'layer' | 'basic' , 'recurrent' , 'layer' |
                 'batch' , 'normalization' , 'layer' | 'catenate' , 'layer' |
                 'constant' , 'array' , 'layer' | 'constant' , 'plus' , 'layer' |
                 'constant' , 'times' , 'layer' | 'contrastive' , 'loss' , 'layer' |
                 'convolution' , 'layer' | 'cross' , 'entropy' , 'loss' , 'layer' |
                 'loss' , 'layer' | 'deconvolution' , 'layer' |
                 'dot' , 'layer' | 'dot' , 'plus' , 'layer' | 'dropout' , 'layer' |
                 'elementwise' , 'layer' | 'embedding' , 'layer' | 'flatten' , 'layer' |
                 'gated' , 'recurrent' , 'layer' | 'image' , 'augmentation' , 'layer' |
                 'instance' , 'normalization' , 'layer' | 'linear' , 'layer' |
                 'local' , 'response' , 'normalization' , 'layer' |
                 'long' , 'short' , 'term' , 'memory' , 'layer' |
                 'mean' , 'absolute' , 'loss' , 'layer' |
                 'mean' , 'squared' , 'loss' , 'layer' | 'padding' , 'layer' |
                 'part' , 'layer' | 'layer' | 'pooling' , 'layer' | 'replicate' , 'layer' |
                 'reshape' , 'layer' | 'resize' , 'layer' | 'sequence' , 'attention' , 'layer' |
                 'sequence' , 'last' , 'layer' | 'sequence' , 'most' , 'layer' |
                 'sequence' , 'rest' , 'layer' | 'sequence' , 'reverse' , 'layer' |
                 'softmax' , 'layer' | 'spatial' , 'transformation' , 'layer' |
                 'summation' , 'layer' | 'threading' , 'layer' | 'total' , 'layer' | 'transpose' , 'layer' |
                 'unit' , 'vector' , 'layer' <@ LayerName@*Flatten@*List ;
  <layer-func-name> = 'RectifiedLinearUnit' | 'ReLU' | 'ExponentialLinearUnit' | 'ELU' |
                      'ScaledExponentialLinearUnit' | 'SELU' | 'SoftSign' | 'SoftPlus' |
                      'HardTanh' | 'HardSigmoid' | 'Sigmoid' <@ LayerFuncName ;
  <layer-common-func> = 'Tanh' | 'Ramp' | 'Total' <@ LayerCommonFunc ;
";



(************************************************************)
(* Net surgery                                              *)
(************************************************************)




(************************************************************)
(* Combination                                              *)
(************************************************************)

ebnfCommand = "
  <netmon-command> = <repository-query> | <net-layer-chain> | <net-training-command> | <net-operation-command> ;
";

(************************************************************)
(* Generate parsers                                         *)
(************************************************************)

res =
    GenerateParsersFromEBNF[ParseToEBNFTokens[#]] & /@
        {ebnfCommonParts, ebnfRepositoryQuery,
          ebnfNetTraining, ebnfNetLayerChain,
          ebnfNetOperationCommand,
          ebnfCommand};
(* LeafCount /@ res *)


(************************************************************)
(* Modify parsers                                           *)
(************************************************************)

(* No parser modification. *)

(************************************************************)
(* Grammar exposing functions                               *)
(************************************************************)

Clear[NetMonCommandsSubGrammars]

Options[NetMonCommandsSubGrammars] = { "Normalize" -> False };

NetMonCommandsSubGrammars[opts:OptionsPattern[]] :=
    Block[{ normalizeQ = TrueQ[OptionValue[NetMonCommandsSubGrammars, "Normalize"]], res},

      res =
          Association[
            Map[
              StringReplace[#, "NeuralNetworkSpecificationsGrammar`Private`"->"" ] -> ToExpression[#] &,
              Names["NeuralNetworkSpecificationsGrammar`Private`ebnf*"]
            ]
          ];

      If[ normalizeQ,
        Map[StringReplace[#, {"&>" -> ",", "<&" -> ",", ("<@" ~~ (Except[{">", "<"}] ..) ~~ ";") :> ";"}]&, res],
        res
      ]
    ];


Clear[NetMonCommandsGrammar]

Options[NetMonCommandsGrammar] = Options[NetMonCommandsSubGrammars];

NetMonCommandsGrammar[opts:OptionsPattern[]] :=
    Block[{ normalizeQ = TrueQ[OptionValue[NetMonCommandsGrammar, "Normalize"]], res},

      res = NetMonCommandsSubGrammars[ opts ];

      res =
          StringRiffle[
            Prepend[ Values[KeyDrop[res, "ebnfCommand"]], res["ebnfCommand"]],
            "\n"
          ];

      If[ normalizeQ,
        StringReplace[res, {"&>" -> ",", "<&" -> ",", ("<@" ~~ (Except[{">", "<"}] ..) ~~ ";") :> ";"}],
        res
      ]
    ];

End[] (* `Private` *)

EndPackage[]