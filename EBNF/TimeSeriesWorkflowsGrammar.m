(*
    Time series workflows grammar in EBNF
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


(* :Title: TimeSeriesWorkflowsGrammar *)
(* :Context: TimeSeriesWorkflowsGrammar` *)
(* :Author: Anton Antonov *)
(* :Date: 2018-07-07 *)

(* :Package Version: 0.2 *)
(* :Mathematica Version: 11.3 *)
(* :Copyright: (c) 2018 Anton Antonov *)
(* :Keywords: *)
(* :Discussion:

   # In brief

   The Extended Backus-Naur Form (EBNF) grammar in this file is intended to be used in a natural language commands
   interface for the creation and testing of time series using the monads QRMon and TSMon:

     https://github.com/antononcube/MathematicaForPrediction/blob/master/MonadicProgramming/MonadicQuantileRegression.m

   The grammar is partitioned into separate sub-grammars, each sub-grammar corresponding to a conceptual set of
   functionalities. (The intent is to facilitate understanding and further development.)


   # How to use

   This grammar is intended to be parsed by the functions in the Mathematica package FunctionalParses.m at GitHub,
   see https://github.com/antononcube/MathematicaForPrediction/blob/master/FunctionalParsers.m .

   (The file can be run in Mathematica with Get or Import.)


   # Example

   TBD...

   Anton Antonov
   Windermere, FL, USA
   2017-07-07

*)

BeginPackage["TimeSeriesWorkflowsGrammar`"]

pQRMONCOMMAND::usage = "Parses natural language commands for time series workflows."

QRMonCommandsSubGrammars::usage = "Gives an association of the EBNF sub-grammars for parsing natural language commands \
specifying QRMon pipelines construction."

QRMonCommandsGrammar::usage = "Gives as a string an EBNF grammar for parsing natural language commands \
specifying QRMon pipelines construction."

Begin["`Private`"]

Needs["FunctionalParsers`"]

(************************************************************)
(* Common parts                                             *)
(************************************************************)

ebnfCommonParts = "
  <list-delimiter> = 'and' | ',' | ',' , 'and' | 'together' , 'with' <@ ListDelimiter ;
  <with-preposition> =  'using' | 'by' | 'with' ;
  <using-preposition> = 'using' | 'with' | 'over' | 'for' ;
  <to-preposition> = 'to' | 'into' ;
  <by-preposition> = 'by' | 'through' | 'via' ;
  <number-value> = '_?NumberQ' <@ NumericValue ;
  <percent-value> = <number-value> <& ( '%' | 'percent' ) <@ PercentValue ;
  <boolean-value> = 'True' | 'False' | 'true' | 'false' <@ BooleanValue ;
  <display-directive> = 'show' | 'give' | 'display' <@ DisplayDirective ;
  <compute-directive> = 'compute' | 'calculate' | 'find' <@ ComputeDirective ;
  <compute-and-display> = <compute-directive> , [ 'and' &> <display-directive> ] <@ ComputeAndDisplay ;
  <generate-directive> = 'make' | 'create' | 'generate' <@ GenerateDirective ;
  <time-series-data> = 'time' , 'series' , [ 'data' ] <@ TimeSeriesData ;
";


(************************************************************)
(* Transform data                                           *)
(************************************************************)

ebnfDataTransform = "
  <data-transformation-command> = <rescale-command> | <resample-command> ;
  <rescale-command> = <rescale-axis> | <rescale-both-axes> ;
  <rescale-axis> = 'rescale' , [ 'the' ] , [ 'x' | 'y' ] , 'axis' <@ RescaleAxis ;
  <rescale-both-axes> = 'rescale' , [ 'the' | 'both' ] , 'axes' <@ RescaleBothAxes ;
  <resample-command> = 'resample' , [ 'the' ] , <time-series-data> ,
                       [ <using-preposition> &> <interpolation-spec> ] ,
                       [ <using-preposition> &> <sampling-step-spec> ] <@ ResampleCommand ;
  <sampling-step-spec> = <default-sampling-step> | 'step' , '_?NumberQ' <@ SamplingStepSpec ;
  <default-sampling-step> = ( 'smallest' , 'difference' | 'default' | 'automatic' ) , 'step' <@ DefaultSamplingStep ;
  <resampling-method-spec> = '<resampling-method> | <resampling-method-name> ;
  <resampling-method> = 'LinearInterpolation' | 'HoldValueFromLeft' ;
  <resampling-method-name> =  'linear' , 'interpolation' | 'hold' , 'value' , 'from' , 'left' ;
";


(************************************************************)
(* Second order commands                                    *)
(************************************************************)

ebnfGeneratePipeline = "
  <generate-pipeline> = <generate-pipeline-phrase> , [ <using-preposition> &> <classifier-algorithm> ] <@ GeneratePipeline ;
  <generate-pipeline-phrase> = <generate-directive> , [ 'an' | 'a' | 'the' ] , [ 'standard' ] , [ 'regression' ] , ( 'pipeline' | 'workflow' ) <@ Flatten ;
";

ebnfSecondOrderCommand = "
   <second-order-command> = <generate-pipeline>  <@ SecondOrderCommand ;
";


(************************************************************)
(* Combination                                              *)
(************************************************************)

ebnfCommand = "
  <qrmon-command> = <load-data> |  <data-transformation-command> | <data-summary-command> |
              <regression> | <regression-fit> | <outliers> |
              <plot-command> | <error-plot-command> | <outliers-plot-command> |
              <pipeline-command> | <second-order-command> ;
  ";


(************************************************************)
(* Generate parsers                                         *)
(************************************************************)

res =
    GenerateParsersFromEBNF[ParseToEBNFTokens[#]] & /@
        {ebnfCommonParts,
          ebnfDataLoad, ebnfDataTransform,
          ebnfDataStatistics, ebnfFindOutliers,
          ebnfRegression, ebnfRegressionFit,
          ebnfOutliersPlot, ebnfRegressionPlot, ebnfErrorPlot,
          ebnfPipelineCommand, ebnfGeneratePipeline, ebnfSecondOrderCommand,
          ebnfCommand};
(* LeafCount /@ res *)


(************************************************************)
(* Modify parsers                                           *)
(************************************************************)

(* No parser modification. *)

(************************************************************)
(* Grammar exposing functions                               *)
(************************************************************)

Clear[QRMonCommandsSubGrammars]

Options[QRMonCommandsSubGrammars] = { "Normalize" -> False };

QRMonCommandsSubGrammars[opts:OptionsPattern[]] :=
    Block[{ normalizeQ = TrueQ[OptionValue[QRMonCommandsSubGrammars, "Normalize"]], res},

      res =
          Association[
            Map[
              StringReplace[#, "ClassifierWorkflowsGrammar`Private`"->"" ] -> ToExpression[#] &,
              Names["ClassifierWorkflowsGrammar`Private`ebnf*"]
            ]
          ];

      If[ normalizeQ,
        Map[StringReplace[#, {"&>" -> ",", "<&" -> ",", ("<@" ~~ (Except[{">", "<"}] ..) ~~ ";") :> ";"}]&, res],
        res
      ]
    ];


Clear[QRMonCommandsGrammar]

Options[QRMonCommandsGrammar] = Options[QRMonCommandsSubGrammars];

QRMonCommandsGrammar[opts:OptionsPattern[]] :=
    Block[{ normalizeQ = TrueQ[OptionValue[QRMonCommandsGrammar, "Normalize"]], res},

      res = QRMonCommandsSubGrammars[ opts ];

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