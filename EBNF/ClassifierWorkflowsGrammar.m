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

(* Version 0.8 *)

(*

   # In brief

   The grammar is intended to interface the creation and testing of classifiers.

   The grammar is partitioned into separate sub-grammars, each sub-grammar corresponding to a conceptual set of
   functionalities. (The intent is to facilitate understanding and further development.)


   # How to use

   This grammar is intended to be parsed by the functions in the Mathematica package FunctionalParses.m at GitHub,
   see https://github.com/antononcube/MathematicaForPrediction/blob/master/FunctionalParsers.m .

   (The file can be run in Mathematica with Get or Import.)


   # Example

   The following sequence of commands are parsed by the parsers generated with the grammar.

      Clear["ebnf*"]

      Import["https://raw.githubusercontent.com/antononcube/ConversationalAgents/master/EBNF/ClassifierWorkflowsGrammar.m"]
      Import["https://raw.githubusercontent.com/antononcube/MathematicaForPrediction/master/FunctionalParsers.m"]

      Names["ebnf*"]

      (* {"ebnfClassifierMaking", "ebnfClassifierTesting", "ebnfCommand",
          "ebnfDataLoad", "ebnfDataOutliers", "ebnfDataStatistics",
          "ebnfDataTransform", "ebnfSplitting", "ebnfVerification"} *)

      res =
        GenerateParsersFromEBNF[ParseToEBNFTokens[#]] & /@ {ebnfDataLoad, ebnfDataTransform,
               ebnfDataStatistics, ebnfSplitting, ebnfDataOutliers, ebnfClassifierMaking,
               ebnfClassifierTesting, ebnfVerification, ebnfCommand};

      LeafCount /@ res

      queries = {
         "load the titanic data",
         "transform numerical columns into categorical",
         "split data with 70 percent for training",
         "show test data summary",
         "find data outliers per class",
         "show the outliers",
         "remove the outliers",
         "show training and test data summaries",
         "create a logistic regression classifier",
         "show precision and recall",
         "show roc over the test data",
         "verify the recall of high is larger than 0.8"};

      pres = ParsingTestTable[ParseShortest[pCOMMAND], queries, "Layout" -> "Vertical"]

*)

If[Length[DownValues[FunctionalParsers`ToTokens]] == 0,
  Echo["FunctionalParsers.m", "Importing from GitHub:"];
  Import["https://raw.githubusercontent.com/antononcube/MathematicaForPrediction/master/FunctionalParsers.m"]
];

BeginPackage["ClassifierWorkflowsGrammar`"]

pCLCONCOMMAND::usage = "Parses natural language commands for classification workflows."

Begin["`Private`"]

Needs["FunctionalParsers`"]

(************************************************************)
(* Data load                                                *)
(************************************************************)

ebnfDataLoad = "
  <display-directive> = 'show' | 'give' | 'display' <@ DisplayDirective ;
  <compute-directive> = 'compute' | 'calculate' | 'find' <@ ComputeDirective ;
  <compute-and-display> = <compute-directive> , [ 'and' &> <display-directive> ] <@ ComputeAndDisplay ;
  <load-data-opening> = ( 'load' | 'get' | 'consider' ) , [ 'data' ] ;
  <load-preposition> = 'for' | 'of' | 'at' | 'from' ;
  <load-data> = ( <load-data-opening> , [ 'the' ] ) &> <data-kind> , ( [ 'data' ] , <load-preposition> ) &> <location-specification> |
  ( <load-data-opening> , [ 'the' ] ) &> <location-specification> <& [ 'data' ] <@ LoadData ;
  <location-specification> = <dataset-name> | <web-address> | <database-name> <@ LocationSpec ;
  <web-address> = '_?StringQ' <@ WebAddress ;
  <dataset-name> = '_WordString' <@ DatasetName ;
  <database-name> = '_WordString' <@ DatabaseName ;
  <data-kind> = '_String' <@ DataKind ;
  ";


(************************************************************)
(* Data transformation                                      *)
(************************************************************)

ebnfDataTransform = "
  <data-spec-opening> = 'transform' ;
  <data-type-filler> =  'data' | 'records' ;
  <data-type> = <data-type-boolean> | <data-type-numeric> | <data-type-string> | <data-type-symbolic> | <data-type-time> ;
  <data-type-boolean> = 'logical' | 'logic' | 'boolean' <@ TypeBoolean ;
  <data-type-numeric> = 'numeric' | 'numerical' | 'integer' | 'double' <@ TypeNumeric ;
  <data-type-string> = 'character' | 'string' | 'categorical' <@ TypeString ;
  <data-type-symbolic> = 'symbolic' <@ TypeSymbolic ;
  <data-type-time> = 'timestamp' , 'time' , 'date' , 'temporal' <@ TypeTime ;
  <data-columns> = 'columns' | 'variables' ;
  <data-transformation-opening> = 'transform' | 'modify' ;
  <data-transformation-of-columns> = [ 'the' ] , ( <data-type> <& <data-columns> ) , ( 'to' | 'into' ) &> <data-type> <@ TransformColumns@*Flatten ;
  <data-transformation> = <data-transformation-opening> &> <data-transformation-of-columns> <@ DataTransform ;
  <number-value> = '_?NumberQ' <@ NumericValue ;
  <percent-value> = <number-value> <& ( '%' | 'percent' ) <@ PercentValue ;
  <boolean-value> = 'True' | 'False' | 'true' | 'false' <@ BooleanValue ;
  ";


(************************************************************)
(* Splitting                                                *)
(************************************************************)

ebnfSplitting = "
  <split-data-opening> = ( 'split' | 'divide' ) , [ 'the' ] , [ 'data' ] ;
  <split-part> = 'training' | 'train' | 'test' | 'testing' <@ SplitPart ;
  <split-part-list> = <split-part> , [ { 'and' &> <split-part> } ] <@ SplitPartList@*Flatten ;
  <split-data-spec> = <percent-value> , [ 'of' | 'for' ] &> <split-part> <& [ 'data' ];
  <with-preposition> =  'using' | 'by' | 'with' ;
  <split-data> = ( [ <split-data-opening> ] , <with-preposition> ) &> <split-data-spec> <@ SplitData ;
  ";


(************************************************************)
(* Data summaries and statistics                            *)
(************************************************************)

ebnfDataStatistics = "
  <summarize-data> = 'summarize' , [ 'the' ] , 'data' | <display-directive> , [ <split-part-list> ] <&
                     ( 'data' , ( 'summary' | 'summaries' ) ) <@ SummarizeData ;
  <cross-tabulate-data> = <cross-tabulate-data-simple> | <cross-tabulate-vars> <@ CrossTabulateData ;
  <cross-tabulate> = 'cross-tabulate' | 'cross' , 'tabulate' | 'xtabs' , [ 'for' ] <@ CrossTabulate ;
  <cross-tabulate-data-simple> = <cross-tabulate> , [ <split-part> ] , [ 'data' ] <@ CrossTabulateDataSimple ;
  <cross-tabulate-vars> = <cross-tabulate> , <var-spec> , ( 'vs' | 'against' ) &> <var-spec> ,
                          [ 'in' ] , [ <split-part> ] , [ 'data' ] <@ CrossTabulateVars@*Flatten ;
  <var-spec> = <feature-var> | <dependent-var> | ( <var-position> <& [ <variable> ] ) <@ VarSpec ;
  <variable> = 'variable' | 'column' ;
  <dependent-var> = ( 'dependent' | [ 'class' ] , 'label' ) <& <variable> <@ DependentVar ;
  <feature-var> = ( 'feature' | 'input' ) <& <variable> <@ FeatureVar ;
  <var-name> = '_String' <@ VarName ;
  <var-position> = 'last' | ( '_?IntegerQ' <& [ 'st' | 'nd' | 'rd' | 'th' ] ) <@ VarPosition ;
  ";


(************************************************************)
(* Outlier finding and removal                              *)
(************************************************************)

ebnfDataOutliers = "
  <data-outliers> = <find-outliers> | <remove-outliers> | <show-outliers> <@ OutlierHandling ;
  <find-outliers> = <find-outliers-per-class> | <find-outliers-all> <@ FindOutliers ;
  <find-outliers-all> = 'find' &> <outliers> <@ FindAllOutliers ;
  <find-outliers-per-class> = 'find' &> <outliers> , 'per' , 'class' , [ 'label ' ] <@ FindOutliersPerClass ;
  <remove-outliers> = 'remove' , <outliers> <@ RemoveOutliers ;
  <show-outliers> = <display-directive> , <outliers> <@ ShowOutliers ;
  <outliers> = ( [ 'the' ] , [ 'data' ] ) &> [ ( 'top' | 'bottom' | 'largest' | 'smallest' | 'all' ) ] , 'outliers' <@ Outliers@*Flatten ;
  ";


(************************************************************)
(* Classifier making                                        *)
(************************************************************)

ebnfClassifierMaking = "
  <classifier-method> = 'DecisionTree' | 'GradientBoostedTrees' | 'LogisticRegression' | 'NaiveBayes' |
                        'NearestNeighbors' | 'NeuralNetwork' | 'RandomForest' | 'SupportVectorMachine' <@ ClassifierMethod ;
  <classifier-algorithm-name> = 'decision' , 'tree' | 'gradient' , 'boosted' , 'trees' | 'logistic' , 'regression' | 'nearest' , 'neighbors' |
                                'naive' , 'bayes' | 'neural' , 'network' | 'random' , 'forest' |
                                'support' , 'vector' , 'machine'  <@ ClassifierAlgorithmName ;
  <library-name> = '_String' <@ LibraryName ;
  <classifier-algorithm> = ( <classifier-algorithm-name> | <classifier-method> ) , [ ( 'from' |'of' ) &> <library-name> ] <@ ClassifierAlgorithm ;
  <using-preposition> = 'using' | 'with' | 'over' | 'for' ;
  <classifier-creation-opening> = ( ( 'make' | 'create' | 'train' ) , [ 'a' | 'an' ] ) ;
  <classifier-creation> = <classifier-creation-opening> &> ( [ <classifier-algorithm> ] , 'classifier' , [ <using-preposition> &> <library-name> ] |
                                                                   'classifier' , <using-preposition> &> <classifier-algorithm> ) ,
                                                                 [ <using-preposition> &> <train-data-spec> ] <@ ClassifierCreation ;
  ";


(************************************************************)
(* Classifier ensemble making                               *)
(************************************************************)

ebnfClassifierEnsembleMaking = "
  <classifier-ensemble-creation> = ( <ensemble-creation-simple> | <ensemble-creation-num> ) ,
                                   [ <using-preposition> &> <resampling-spec> ] <@ ClassifierEnsembleCreation ;
  <classifier-ensemble-phrase> = ( [ 'classifier' ] , 'ensemble' ) | ( 'ensemble' , 'of' , 'classifiers' ) ;
  <ensemble-creation-simple> = <classifier-creation-opening>  &>
                               ( ( [ <classifier-algorithm> ] <& <classifier-ensemble-phrase> ) |
                                 ( ( <classifier-ensemble-phrase> , <using-preposition> ) &> <classifier-algorithm> ) ) ;
  <ensemble-creation-num> = ( <classifier-creation-opening> , <classifier-ensemble-phrase> ) &>
                            ( <using-preposition> | 'of' ) &>
                            <number-of-classifiers> , [ 'of' ] &> <classifier-algorithm> <& [ 'classifiers' ] ;
  <resampling-spec> = ( [ <percent-value> ] <& ( 'resampling' | 'of' , [ 'the' ] , 'data' ) ) , [ 'with' &> <resampling-function> ]  <@ ResamplingSpec ;
  <resampling-function> = 'RandomChoice' | 'RandomSample' <@ ResamplingFunction ;
  <number-of-classifiers> = <number-value> <@ NumberOfClassifiers ;
";


(************************************************************)
(* Classifier queries                                       *)
(************************************************************)

ebnfClassifierQuery = "
  <classifier-query> =  <classifier-get-info-property> | <classifier-info> | <classifier-counts> <@ ClassifierQuery ;
  <classifier-info-property> = 'Accuracy' | 'Classes' | 'ClassNumber' | 'EvaluationTime' | 'ExampleNumber' |
                               'FeatureNumber' | 'FunctionMemory' | 'FunctionProperties' | 'LearningCurve' |
                               'MaxTrainingMemory' | 'MeanCrossEntropy' | 'MethodDescription' | 'MethodOption' |
                               'Properties' | 'TrainingClassPriors' | 'TrainingTime' | 'ClassPriors' |
                               'FeatureNames' | 'FeatureTypes' | 'IndeterminateThreshold' | 'Method' |
                               'PerformanceGoal' | 'UtilityFunction' <@ ClassifierInfoProperty ;
  <classifier-info-property-name> = ( 'accuracy' | 'classes' | 'class' , 'number' | 'training' , 'time' )
                                     <@ ClassifierInfoPropertyName ;
  <classifier-get-info-property> = <display-directive> , 'classifier' &>
                                   ( <classifier-info-property> | <classifier-info-property-name> )
                                   <@ ClassifierGetInfoProperty ;
  <classifier-info> = [ <display-directive>  ] , 'classifier' , ( 'info' | 'information' | 'stats' ) <@ ClassifierInfo ;
  <classifier-counts> = ( 'how' , 'many' | 'what' , 'number', 'of' ) , ( 'classifiers' | 'classifiers?' ) <@ ClassifierCounts ;
";

(************************************************************)
(* Classifier testing                                       *)
(************************************************************)

ebnfClassifierTesting = "
  <classifier-testing-simple> = ( 'test' , [ 'a' | 'the' ] ) &> 'classifier' <@ TestClassifier ;
  <train-data-spec> = '_?NumberQ' , ( 'percent' | 'fraction' ) <& ( 'of' , [ 'the' ] , [ 'available' ] , ( 'records' | 'data' ) ) <@ TrainData;
  <test-results-preamble> = ( 'show' | 'display' | 'give' | 'compute' ) , [ 'classifier' ] ;
  <test-measure> = 'Accuracy' | 'AccuracyRejectionPlot' | 'AreaUnderROCCurve' |
                   'BestClassifiedExamples' | 'ClassifierFunction' |
                   'ClassMeanCrossEntropy' | 'ClassRejectionRate' | 'CohenKappa' |
                   'ConfusionFunction' | 'ConfusionMatrix' | 'ConfusionMatrixPlot' |
                   'CorrectlyClassifiedExamples' | 'DecisionUtilities' | 'Error' |
                   'Examples' | 'F1Score' | 'FalseDiscoveryRate' |
                   'FalseNegativeExamples' | 'FalseNegativeRate' |
                   'FalsePositiveExamples' | 'FalsePositiveRate' |
                   'GeometricMeanProbability' | 'IndeterminateExamples' |
                   'LeastCertainExamples' | 'Likelihood' | 'LogLikelihood' |
                   'MatthewsCorrelationCoefficient' | 'MeanCrossEntropy' |
                   'MeanDecisionUtility' | 'MisclassifiedExamples' |
                   'MostCertainExamples' | 'NegativePredictedValue' | 'Perplexity' |
                   'Precision' | 'Probabilities' | 'ProbabilityHistogram' | 'Properties' |
                   'Recall' | 'RejectionRate' | 'ROCCurve' | 'ScottPi' | 'Specificity' |
                   'TopConfusions' | 'TrueNegativeExamples' | 'TruePositiveExamples' |
                   'WorstClassifiedExamples' <@ TestMeasure ;
  <test-measure-name> = 'accuracy' | 'accuracy' , 'rejection' , 'plot' | 'area' , 'under' , 'roc' , 'curve' |
                        'best' , 'classified' , 'examples' | 'classifier' , 'function' |
                        'class' , 'mean' , 'cross' , 'entropy' | 'class' , 'rejection' , 'rate' |
                        'cohen' , 'kappa' |
                        'confusion' , 'function' | 'confusion' , 'matrix' | 'confusion' , 'matrix' , 'plot' |
                        'correctly' , 'classified' , 'examples' | 'decision' , 'utilities' |
                        'error' | 'examples' | 'score' | 'false' , 'discovery' , 'rate' |
                        'false' , 'negative' , 'examples' | 'false' , 'negative' , 'rate' |
                        'false' , 'positive' , 'examples' | 'false' , 'positive' , 'rate' |
                        'geometric' , 'mean' , 'probability' | 'indeterminate' , 'examples' |
                        'least' , 'certain' , 'examples' | 'likelihood' | 'log' , 'likelihood' |
                        'matthews' , 'correlation' , 'coefficient' | 'mean' , 'cross' , 'entropy' |
                        'mean' , 'decision' , 'utility' | 'misclassified' , 'examples' | 'most' , 'certain' , 'examples' |
                        'negative' , 'predicted' , 'value' | 'perplexity' | 'precision' |
                        'probabilities' | 'probability' , 'histogram' | 'properties' |
                        'recall' | 'rejection' , 'rate' | 'curve' | 'scott' , 'pi' |
                        'specificity' | 'top' , 'confusions' | 'true' , 'negative' , 'examples' |
                        'true' , 'positive' , 'examples' | 'worst' , 'classified' , 'examples'
                        <@ TestMeasureName@*Flatten@*List ;
  <list-delimiter> = 'and' | ',' | ',' , 'and' | 'together' , 'with' <@ ListDelimiter ;
  <test-measure-list> = ( <test-measure> | <test-measure-name> ) , [ { <list-delimiter> &> ( <test-measure> | <test-measure-name> ) } ] <@ TestMeasureList@*Flatten ;
  <test-classification-threshold> = 'classification' , 'threshold' , '_?NumberQ' <@ ClassThreshold ;
  <test-results-filler> = ( 'for' , [ 'the' ] , 'classifier' | 'over' , [ 'the' ] , 'available' , [ 'test' ] , 'data' );
  <test-results> = <test-results-preamble> &> ( 'test' , 'results' | <test-measure-list> ) ,
                   [ 'with' , <test-classification-threshold> ] <& [ <test-results-filler> ] <@ TestResults@*Flatten ;
  <accuracies-by-variable-shuffling> = <compute-and-display> ,
                                       ( ( [ 'the' ] , 'accuracies' , <with-preposition> , ( 'variable' | 'column' ) , 'shuffling' ) |
                                         ( [ 'the' ] , [ 'variable' | 'column' ] , 'shuffling' , 'accuracies' ) |
                                         ( [ 'the' ] , 'variable' , 'importance' , [ 'estimates' ] )
                                       ) <@ AccuraciesByVariableShuffling@*First ;
  <classifier-testing> = <classifier-testing-simple> | <test-results> | <accuracies-by-variable-shuffling> <@ ClassifierTesting ;
  ";

(************************************************************)
(* ROC plots                                                *)
(************************************************************)

ebnfROCPlot = "
  <roc-plot-command> = <display-directive> , <roc-diagram>, [ ( 'over' | 'with' | 'using' | 'for' | 'of' ) &> <roc-function-list> ] <@ ROCCurvesPlot;
  <roc-curve> = ( 'roc' | 'receiver' , 'operating' , 'characteristic' ) <& [ 'curve' | 'curves' ];
  <diagram> = ( 'plot' | 'plots' | 'graph' | 'chart' ) <@ Diagram ;
  <list-line-diagram> = [ 'list' ] , 'line' , <diagram> | 'ListLinePlot' <@ ListLineDiagram@*Flatten ;
  <list-line-roc-diagram> = [ 'list' ] , 'line' , <roc-curve> , <diagram>  <@ ListLineDiagram@*Flatten ;
  <roc-diagram> = <list-line-roc-diagram> | ( <roc-curve> &> ( <list-line-diagram> | <diagram> ) ) <@ ROCDiagram ;
  <roc-function-list> = ( <roc-function> | <roc-function-name> ) , [ { <list-delimiter> &> ( <roc-function> | <roc-function-name> ) } ] <@ ROCFunctionList@*Flatten ;
  <roc-function> =  'TPR' | 'TNR' | 'SPC' | 'PPV' | 'NPV' | 'FPR' | 'FDR' | 'FNR' | 'ACC' | 'AUROC' | 'FOR' | 'F1' |
                    'Recall' | 'Sensitivity' | 'Precision' | 'Accuracy' | 'Specificity' |
                    'FalsePositiveRate' | 'TruePositiveRate' | 'FalseNegativeRate' | 'TrueNegativeRate' |
                    'FalseDiscoveryRate' | 'FalseOmissionRate' | 'F1Score' | 'AreaUnderROCCurve' <@ ROCFunction ;
  <roc-function-name> = 'tpr' | 'tnr' | 'spc' | 'ppv' | 'npv' | 'fpr' | 'fdr' | 'fnr' | 'acc' | 'auroc' | 'for' | 'f1' |
                        'recall' | 'sensitivity' | 'precision' | 'accuracy' | 'specificity' |
                        'false' , 'positive' , 'rate' | 'true' , 'positive' , 'rate' | 'false' , 'negative' , 'rate' |
                        'true' , 'negative', 'rate' | 'false' , 'discovery' , 'rate' | 'false' , 'omission' , 'rate' |
                        'f1' , 'score' | 'area' , 'under' , 'roc' , 'curve' <@ ROCFunctionName ;

";

(************************************************************)
(* Verification                                             *)
(************************************************************)

ebnfVerification = "
  <verify-command> = <verify-preamble> , <verify-test-spec> <@ VerifyCommand ;
  <verify-preamble> = ( 'verify' | 'assert' ) <& [ 'that' ] <@ VerifyPreamble ;
  <verify-test-spec> = <verify-test-spec-simple> | <verify-test-spec-label> <@ VerifyTestSpec ;
  <verify-test-spec-simple> = [ 'the' ] &> <test-measure> , <verify-relation> , <verify-value> <@ VerifyTestSpecSimple ;
  <verify-test-spec-label> = ( [ 'the' ] &> <test-measure> , 'of' ) &> <class-label> , <verify-relation> , <verify-value> <@ VerifyTestSpecLabel ;
  <verify-relation> = 'is' &> ( 'greater' | 'larger' | 'smaller' | 'less' | 'greater' ) <& 'than' | 'equals' | 'is' , 'equal' , 'to' <@ VerifyRelation ;
  <verify-value> = <percent-value> | <number-value> | <boolean-value> <@ VerifyValue ;
  <class-label> = '_WordString' <@ ClassLabel ;
  ";


(************************************************************)
(* General pipeline commands                                *)
(************************************************************)

ebnfPipelineCommands = "
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
  <generate-verb> = 'make' | 'create' | 'generate' ;
  <generate-pipeline-phrase> = <generate-verb> , [ 'an' | 'a' | 'the' ] , [ 'standard' ] , [ 'classification' ] , 'pipeline' <@ Flatten ;
";

ebnfSecondOrderCommand = "
   <second-order-command> = <generate-pipeline>  <@ SecondOrderCommand ;
";

(************************************************************)
(* Combination                                              *)
(************************************************************)

ebnfCommand = "
  <clcon-command> = <load-data> | <data-transformation> | <split-data> |
              <summarize-data> | <cross-tabulate-data> | <data-outliers> |
              <classifier-creation> | <classifier-ensemble-creation> | <classifier-query> | <classifier-testing> |
              <roc-plot-command> | <verify-command> | <pipeline-command> |
              <second-order-command> ;
  ";


(************************************************************)
(* Generate parsers                                         *)
(************************************************************)

res =
    GenerateParsersFromEBNF[ParseToEBNFTokens[#]] & /@
        {ebnfDataLoad,
          ebnfDataTransform, ebnfDataStatistics, ebnfSplitting, ebnfDataOutliers,
          ebnfClassifierMaking, ebnfClassifierEnsembleMaking, ebnfClassifierQuery, ebnfClassifierTesting,
          ebnfROCPlot, ebnfVerification, ebnfPipelineCommands,
          ebnfGeneratePipeline, ebnfSecondOrderCommand, ebnfCommand};
(* LeafCount /@ res *)


(************************************************************)
(* Modify parsers                                           *)
(************************************************************)

End[] (* `Private` *)

EndPackage[]