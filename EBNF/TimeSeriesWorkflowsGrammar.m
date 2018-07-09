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
  <error> = 'error' ;
  <outliers> = 'outliers' | 'outlier' ;
  <ingest> = 'ingest' | 'load' | 'use' | 'get' ;
  <data> = 'data' | 'dataset' | 'time' , 'series' ;
  <range-spec> = ( 'from' &> <number-value> ) , ( 'to' &> <number-value> ) ,
                 ( <with-preposition> | [ <with-preposition> ] , 'step' ) &> <number-value> <@ RangeSpec@*Flatten ;
  <number-value-list> = <number-value> , [ { <list-delimiter> &> <number-value> } ] <@ NumberValueList@*Flatten ;
";

(************************************************************)
(* Data load                                                *)
(************************************************************)

ebnfDataLoad = "
  <load-data> = <ingest> , <data> , ( 'with' | 'that' , 'has' ) , 'id' , <data-id> |
                <ingest> , [ 'the' ] , <data-id> , <data> <@ DataLoad ;
  <data-id> = '_WordString' <@ DataID ;
  <load-cloud-data> = <load-data> , 'from' , [ 'the' ] , 'cloud' <@ CloudDataLoad ;
";


(************************************************************)
(* Transform data                                           *)
(************************************************************)

ebnfDataTransform = "
  <data-transformation-command> = <rescale-command> | <resample-command> ;
  <rescale-command> = <rescale-axis> | <rescale-both-axes> ;
  <rescale-axis> = 'rescale' , [ 'the' ] , [ 'x' | 'y' ] , 'axis' <@ RescaleAxis ;
  <rescale-both-axes> = 'rescale' , [ 'the' | 'both' ] , 'axes' <@ RescaleBothAxes ;
  <resample-command> = 'resample' , [ 'the' ] , [ <time-series-data> ] ,
                       [ <using-preposition> &> <resampling-method-spec> ] ,
                       [ <using-preposition> &> <sampling-step-spec> ] <@ ResampleCommand@*Flatten ;
  <sampling-step-spec> = <default-sampling-step> | 'step' &> <number-value> <@ SamplingStepSpec ;
  <default-sampling-step> = ( 'smallest' , 'difference' | 'default' | 'automatic' ) , 'step' <@ DefaultSamplingStep ;
  <resampling-method-spec> = <resampling-method> | <resampling-method-name> ;
  <resampling-method> = 'LinearInterpolation' | 'HoldValueFromLeft' <@ ResamplingMethod ;
  <resampling-method-name> =  'linear' , 'interpolation' | 'hold' , 'value' , 'from' , 'left' <@ ResamplingMethodName@*Flatten ;
";


(************************************************************)
(* Data summaries and statistics                            *)
(************************************************************)

ebnfDataStatistics = "
  <data-statistics-command> = <summarize-data> | <cross-tabulate-data> <@ DataStatisticsCommand ;
  <summarize-data> = 'summarize' , [ 'the' ] , 'data' | <display-directive>  <&
                     ( [ 'data' ] , ( 'summary' | 'summaries' ) ) <@ SummarizeData ;
  <cross-tabulate-data> = <cross-tabulate-data-simple> | <cross-tabulate-vars> <@ CrossTabulateData ;
  <cross-tabulate> = 'cross-tabulate' | 'cross' , 'tabulate' | 'xtabs' , [ 'for' ] <@ CrossTabulate ;
  <cross-tabulate-data-simple> = <cross-tabulate> , [ [ 'the' ] , <data> ] <@ CrossTabulateDataSimple ;
  <cross-tabulate-vars> = <cross-tabulate> , <var-spec> , ( 'vs' | 'against' ) &> <var-spec>
                          <@ CrossTabulateVars@*Flatten ;
  <var-spec> = <feature-var> | <dependent-var> | ( <var-position> <& [ <variable> ] ) <@ VarSpec ;
  <variable> = 'variable' | 'column' ;
  <dependent-var> = ( 'dependent' ) <& <variable> <@ DependentVar ;
  <feature-var> = ( 'time' | 'input' | 'explaining' ) <& <variable> <@ FeatureVar ;
  <var-name> = '_String' <@ VarName ;
  <var-position> = 'last' | ( '_?IntegerQ' <& [ 'st' | 'nd' | 'rd' | 'th' ] ) <@ VarPosition ;
 ";



(************************************************************)
(* Regression                                               *)
(************************************************************)

ebnfRegression = "
  <regression-command> = ( <compute-directive> | 'do' ) &> <quantile-regression-spec> <@ ComputeRegression ;
  <quantile-regression> = 'quantile' , 'regression' | 'QuantileRegression' ;
  <quantile-regression-spec> = <quantile-regression> ,
                               [ <using-preposition>  &>  <quantile-regression-spec-element-list> ]
                               <@ QuantileRegressionSpec ;
  <quantile-regression-spec-element> = <quantiles-spec-phrase> | <knots-spec-phrase> | <interpolation-order-spec-phrase> ;
  <quantile-regression-spec-element-list> = <quantile-regression-spec-element> ,
                                            [ { ( <list-delimiter> , [ <using-preposition> ] ) &> <quantile-regression-spec-element> } ]
                                            <@ QuantileRegressionSpecElementList@*Flatten ;
  <quantiles-spec-phrase> = ( [ 'the' ] , ( 'quantiles' | 'quantile' , [ 'list' ] ) ) &> <quantiles-spec> |
                               [ 'the' ] &> <quantiles-spec> <& ( 'quantiles' | 'quantile' , [ 'list' ] ) ;
  <quantiles-spec> = { '_?NumberQ' } | <number-value-list> | <range-spec> <@ QuantilesSpec ;
  <knots-spec-phrase> = ( [ 'the' ] , 'knots' ) &> <knots-spec> | <knots-spec> <& 'knots' ;
  <knots-spec> = '_?IntegerQ' | <number-value-list> | <range-spec> <@ KnotsSpec ;
  <interpolation-order-spec-phrase> = ( [ 'interpolation' ] , ( 'order' | 'degree' ) ) &> <interpolation-order-spec> |
                                      <interpolation-order-spec> <& ( [ 'interpolation' ] , ( 'order' | 'degree' ) );
  <interpolation-order-spec> = '_?IntegerQ' <@ InterpolationOrderSpec ;
";


(************************************************************)
(* Regression fit                                           *)
(************************************************************)

ebnfRegressionFit = "
  <regression-fit-command> = ( <compute-directive> | 'do' ) &> ( <quantile-regression-fit-spec> | <least-squares-fit> ) <@ ComputeRegression ;
  <least-squares-fit> = 'least' , 'squares' , [ 'regression' | 'fit' ] | 'LeastSquares' | 'Fit' ;
  <least-squares-fit-spec> = <least-squares-fit> , <using-preposition> , <basis-functions-spec> <@ LeastSquaresFitSpec ;
  <quantile-regression-fit> = 'quantile' , 'regression' , 'fit' | 'QuantileRegressionFit' ;
  <using-basis-functions-phrase> = ( <using-preposition> , [ 'the' ] , [ 'basis' ] , [ 'functions' ] ) &> <basis-functions-spec> ;
  <using-quantiles-phrase> = ( <using-preposition> , [ 'the' ] , [ 'quantiles' ] ) &> <quantiles-spec> ;
  <quantile-regression-fit-spec> = <quantile-regression-fit> &>
                                   ( <using-basis-functions-phrase> , [ 'and' ] , [ <using-quantiles-phrase> ] |
                                     <using-quantiles-phrase> , [ 'and' ] , [ <using-basis-functions-phrase> ] )
                                   <@ QuantileRegressionFitSpec ;
  <basis-functions-spec> = { '_String' } <@ BasisFunctionsSpec@*Flatten@*List ;
";


(************************************************************)
(* Find outliers                                            *)
(************************************************************)

ebnfFindOutliers = "
  <find-outliers-command> = <find-outliers-simple> | <find-type-outliers> | <find-outliers-spec> <@ FindOutliersCommand ;
  <outliers-phrase> = [ 'the' ] , [ <data> ] , 'outliers' ;
  <find-outliers-simple> = <compute-and-display> <& <outliers-phrase> <@ FindOutliersSimple ;
  <outlier-type> = ( [ 'the' ] , [ <data> ] ) &> ( 'top' | 'bottom' ) <@ OutlierType ;
  <find-type-outliers> = <compute-and-display> , ( <outlier-type> <& <outliers-phrase> ) ,
                         [ ( <with-preposition> , [ [ 'the' ] , 'quantile' ] ) &> <number-value> , [ 'quantile' ] ]
                         <@ FindTypeOutliers@*Flatten ;
  <find-outliers-spec> = <compute-and-display> , <outliers-phrase> , <with-preposition> ,
                         [ ( [ 'the' ] , 'quantiles' ] ) &> <quantiles-spec> , [ 'quantiles' ] <@ FindTypeOutliers@Flatten ;
";


(************************************************************)
(* Data and regression functions plot                       *)
(************************************************************)

ebnfPlot = "
  <plot-command> = <display-directive> , [ <diagram-type> ] , <diagram>  <@ DataAndRegressionFunctionsPlot;
  <diagram-type> = <regression-curve-spec> | <error> | <outliers> <@ DiagramType ;
  <regression-curve-spec> = [ 'fitted' ] , ( <regression-function> | <regression-function-name> ) <& [ 'curve' | 'curves' | 'function' | 'functions' ] ;
  <diagram> = ( 'plot' | 'plots' | 'graph' | 'chart' ) <@ Diagram ;
  <regression-function-list> = ( <regression-function> | <regression-function-name> ) ,
                               [ { <list-delimiter> &> ( <regression-function> | <regression-function-name> ) } ] <@ RegressionFunctionList@*Flatten ;
  <regression-function> =  'QuantileRegression' | 'LeastSquares'  <@ RegressionFunction ;
  <regression-function-name> = 'quantile' , [ 'regression' ] | 'least' , 'squares' , [ 'regression' ] <@ RegressionFunctionName ;
";



(************************************************************)
(* General pipeline commands                                *)
(************************************************************)
(* This has to be refactored at some point since it is used in other workflow grammars. *)

ebnfPipelineCommand = "
  <pipeline-command> = <get-pipeline-value> | <get-pipeline-context> |
                       <pipeline-context-add> | <pipeline-context-retrieve> <@ PipelineCommand ;
  <pipeline-filler> = [ 'the' ] , [ 'current' ] , [ 'pipeline' ] ;
  <pipeline-value> = <pipeline-filler> &> 'value' <@ PipelineValue ;
  <get-pipeline-value> = <display-directive> &> <pipeline-value> <@ GetPipelineValue ;
  <pipeline-context> =  <pipeline-filler> &> 'context' <@ PipelineContext ;
  <pipeline-context-keys> =  <pipeline-filler> &> 'context' , 'keys' <@ PipelineContextKeys ;
  <context-key> = '_String' <@ ContextKey ;
  <pipeline-context-value> = ( <pipeline-filler> , 'context' , 'value' , ( 'for' | 'of' ) ) &> <context-key> |
                             ( ( 'value' , ( 'for' | 'of' ) , [ 'the' ] , 'context' , ( 'key' | 'element' | 'variable' ) ) &> <context-key>)
                             <@ PipelineContextValue ;
  <get-pipeline-context> = <display-directive> , ( <pipeline-context> | <pipeline-context-keys> | <pipeline-context-value> ) <@ GetPipelineContext ;
  <pipeline-context-add> = ( ( 'put' | 'add' ) , ( 'in' | 'into' | 'to' ) , 'context' , 'as' ) &> <context-key> <@ PipelineContextAdd ;
  <pipeline-context-retrieve> = ( 'get' | 'retrieve' ) &>
                                ( ( 'from' , 'context' ) &> <context-key> | <context-key> <& ( 'from' , 'context' ) )
                                <@ PipelineContextRetrieve ;
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
  <qrmon-command> = <load-data> |  <data-transformation-command> | <data-statistics-command> |
                    <regression-command> | <regression-fit-command> | <find-outliers-command> |
                    <plot-command> |  <pipeline-command> | <second-order-command> ;
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
          ebnfPlot,
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
              StringReplace[#, "TimeSeriesWorkflowsGrammar`Private`"->"" ] -> ToExpression[#] &,
              Names["TimeSeriesWorkflowsGrammar`Private`ebnf*"]
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