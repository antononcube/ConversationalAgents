(*
    Latent semantic analysis workflows grammar in EBNF
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

(* Version 0.3 *)

(*

   # In brief

   The grammar is intended to interface the creation and testing of text latent semantic analysis workflows.

   The grammar is partitioned into separate sub-grammars, each sub-grammar corresponding to a conceptual set of
   functionalities. (The intent is to facilitate understanding and further development.)


   # How to use

   This grammar is intended to be parsed by the functions in the Mathematica package FunctionalParses.m at GitHub,
   see https://github.com/antononcube/MathematicaForPrediction/blob/master/FunctionalParsers.m .

   (The file can be run in Mathematica with Get or Import.)


   # Example

   The following sequence of commands are parsed by the parsers generated with the grammar.

      Clear["ebnf*"]

      Import["https://raw.githubusercontent.com/antononcube/ConversationalAgents/master/EBNF/LatentSemanticAnalysisWorkflowsGrammar.m"]
      Import["https://raw.githubusercontent.com/antononcube/MathematicaForPrediction/master/FunctionalParsers.m"]

      Names["ebnf*"]

*)


If[Length[DownValues[FunctionalParsers`ParseToEBNFTokens]] == 0,
  Echo["FunctionalParsers.m", "Importing from GitHub:"];
  Import["https://raw.githubusercontent.com/antononcube/MathematicaForPrediction/master/FunctionalParsers.m"]
];

BeginPackage["LatentSemanticAnalysisWorkflowsGrammar`"];

pLSAMONCOMMAND::usage = "Parses natural language commands for latent semantic analysis workflows.";

LSAMonCommandsSubGrammars::usage = "Gives an association of the EBNF sub-grammars for parsing natural language commands \
specifying LSAMon pipelines construction.";

LSAMonCommandsGrammar::usage = "Gives as a string an EBNF grammar for parsing natural language commands \
specifying LSAMon pipelines construction.";

Begin["`Private`"];

Needs["FunctionalParsers`"];

(************************************************************)
(* Common parts                                             *)
(************************************************************)

(*
Same as ebnfCommonParts in ClassifierWorkflowsGrammar.m .
Some of the rules are not needed here. E.g. <class-label> .

*)

ebnfCommonParts = "
  <list-delimiter> = 'and' | ',' | ',' , 'and' | 'together' , 'with' <@ ListDelimiter ;
  <with-preposition> =  'using' | 'by' | 'with' ;
  <using-preposition> = 'using' | 'with' | 'over' | 'for' ;
  <number-value> = '_?NumberQ' <@ NumericValue ;
  <percent-value> = <number-value> <& ( '%' | 'percent' ) <@ PercentValue ;
  <boolean-value> = 'True' | 'False' | 'true' | 'false' <@ BooleanValue ;
  <display-directive> = 'show' | 'give' | 'display' <@ DisplayDirective ;
  <compute-directive> = 'compute' | 'calculate' | 'find' <@ ComputeDirective ;
  <compute-and-display> = <compute-directive> , [ 'and' &> <display-directive> ] <@ ComputeAndDisplay ;
  <generate-directive> = 'make' | 'create' | 'generate' <@ GenerateDirective ;
  <class-label> = '_String' <@ ClassLabel ;
";


(************************************************************)
(* Data load                                                *)
(************************************************************)

(* Note that this sub-grammar is pretty much the same for all Machine Learning workflows. *)

ebnfDataLoad = "
  <data-reference> = 'data' | ( 'texts' | 'text' , [ 'corpus' | 'collection' ] , [ 'data' ] ) ;
  <load-data-opening> = ( 'load' | 'get' | 'consider' ) , [ 'the' ] , <data-reference> ;
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
  <data-transformation> = <data-partition> <@ DataTransform ;
  <data-partition> = 'partition' , [ <data-reference> ] , ( 'to' | 'into' ) , <data-elements> ;
  <data-element> = 'sentence' | 'paragraph' | 'section' | 'chapter' | 'word' ;
  <data-elements> = 'sentences' | 'paragraphs' | 'sections' | 'chapters' | 'words' ;
  <data-spec-opening> = 'transform' ;
  <data-type-filler> =  'data' | 'records' ;
  ";


(************************************************************)
(* Statistics commands                                      *)
(************************************************************)

ebnfStatistics = "
  <statistics-command> = <statistics-preamble> &> ( <docs-per-term> | <terms-per-doc> ) , [ <statistic-spec> ] <@ StatisticsCommand ;
  <statistics-preamble> = ( <compute-and-display> | <display-directive> ) , [ 'the' | 'a' | 'some' ] ;
  <docs-per-term> = <docs> , [ 'per' ] , <terms> <@ DocsPerTerm@*Flatten ;
  <terms-per-doc> = <terms> , [ 'per' ] , <docs> <@ TermsPerDoc@*Flatten ;
  <docs> = 'document' | 'documents' | 'item' | 'items' ;
  <terms> = 'word' | 'words' | 'term' | 'terms' ;
  <statistic-spec> = <diagram-spec> | <summary-spec> ;
  <diagram-spec> = 'histogram' ;
  <summary-spec> = 'quantiles' | 'summary' | 'statistics' ;
";

(************************************************************)
(* Document-term matrix commands                            *)
(************************************************************)

ebnfDocTermMat = "
  <make-doc-term-mat> = ( ( <compute-directive> | <generate-directive> ) , [ 'the' | 'a' ] ) &> <doc-term-mat> <@ MakeDocumentTermMatrix ;
  <doc-term-mat> = ( 'document' | 'item' ) , ( 'term' | 'word' ) , 'matrix' ;
  ";


(************************************************************)
(* LSI functions application commands                       *)
(************************************************************)

ebnfLSIApplyFuncs = "
  <lsi-apply-command> = <lsi-apply-phrase> &> <lsi-funcs-list> <@ LSICommand ;
  <lsi-apply-verb> = ( 'apply' , 'to' | 'transform' ) ;
  <lsi-apply-phrase> = <lsi-apply-verb> , [ 'the' ] , [ ( 'matrix' | <doc-term-mat> ) , 'entries' ] ,
                       [ 'the' ] , [ 'lsi' ] , [ 'functions' ] ;
  <lsi-funcs-list> = <lsi-func> , [ { <list-delimiter> &> <lsi-func> } ] <@ LSIFuncsList@*Flatten ;
  <lsi-func> = <lsi-global-func> | <lsi-local-func> | <lsi-normal-func> ;
  <lsi-global-func> = <lsi-global-func-idf> | <lsi-global-func-entropy> <@ LSIGlobalFunc ;
  <lsi-global-func-idf> = 'IDF' | 'idf' | 'inverse' , 'document' , 'frequency' <@ LSIGlobalFuncIDF ;
  <lsi-global-func-entropy> = 'Entropy' | 'entropy' <@ LSIGlobalFuncEntropy ;
  <lsi-local-func> = <lsi-local-func-frequency> | <lsi-local-func-binary> <@ LSILocalFunc;
  <lsi-local-func-frequency> = 'frequency' <@ LSILocalFuncFrequency ;
  <lsi-local-func-binary> = 'binary' <& [ 'frequency' ] <@ LSILocalFuncBinary ;
  <lsi-normal-func> = ( <lsi-normal-func-sum> | <lsi-normal-func-max> | <lsi-normal-func-cosine> ) <& [ 'normalization' ] <@ LSINormalFunc@*Flatten ;
  <lsi-normal-func-sum> = 'sum' <@ LSILocalFuncSum ;
  <lsi-normal-func-max> = 'cosine' <@ LSILocalFuncMax ;
  <lsi-normal-func-cosine> = 'cosine' <@ LSILocalFuncCosine ;
  ";


(************************************************************)
(* Topics extraction commands                           *)
(************************************************************)

(* The parameter specification has to be done as a list of parameters. *)

ebnfTopicsExtraction = "
  <topics-extraction-command> = ( <compute-directive> | 'extract' ) &> <topics-spec> , [ <topics-parameters-spec> ] <@ TopicsExtractionCommand ;
  <topics-spec> = <number-value> <& 'topics' <@ TopicsNumber ;
  <topics-parameters-spec> = <with-preposition> &> <topics-parameters-list> <@ TopicsParametersSpec ;
  <topics-parameters-list> = <topics-parameter> , [ { <list-delimiter> &> <topics-parameter> } ] <@ TopicsParametersList ;
  <topics-parameter> = <topics-max-iterations> | <topics-initialization> | <topics-method> ;
  <topics-max-iterations> = <max-iterations-phrase> &> <number-value> | <number-value> <& <max-iterations-phrase> <@ TopicsMaxIterations ;
  <max-iterations-phrase> = ( 'max' | 'maximum' ) , ( 'iterations' | 'steps' ) ;
  <topics-initialization> = [ 'random' ] , <number-value> , 'columns' , 'clusters' <@ TopicsInitialization ;
  <topics-method> = [ [ 'the' ] , 'method' ] &> ( 'SVD' | 'PCA' | 'NNMF' | 'NMF' ) <@ TopicsExtractionMethod ;
  ";


(************************************************************)
(* Statistical thesaurus extraction commands                *)
(************************************************************)

ebnfThesaurusExtraction = "
  <thesaurus-extraction-command> = ( <compute-directive> | 'extract' ) &> <thesaurus-spec> <@ ThesaurusExtractionCommand ;
  <thesaurus-spec> = ( [ 'statistical' ] , 'thesaurus' ) &> [ <with-preposition> &> <thesaurus-parameters-spec> ] ;
  <thesaurus-parameters-spec> = <thesaurus-number-of-nns> <@ ThesaurusParametersSpec ;
  <thesaurus-number-of-nns> = <number-value> <& ( [ 'number' , 'of' ] , ( [ 'nearest' ] , 'neighbors'  | 'synonyms' | 'synonym' ,  ( 'words' | 'terms' ) ) , [ 'per' , ( 'word' | 'term' ) ] ) <@ ThesaurusNumberOfSynonyms ;
  ";


(************************************************************)
(* General pipeline commands                                *)
(************************************************************)

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
  <generate-pipeline> = <generate-pipeline-phrase> , [ <using-preposition> &> <topics-spec> ] <@ GeneratePipeline ;
  <generate-pipeline-phrase> = <generate-directive> , [ 'an' | 'a' | 'the' ] , [ 'standard' ] , <lsa-phrase> , 'pipeline' <@ Flatten ;
  <lsa-phrase> = <lsa-phrase-word> , [ { <lsa-phrase-word> } ] ;
  <lsa-phrase-word> = 'text' | 'latent' | 'semantic' | 'analysis' ;
";

ebnfSecondOrderCommand = "
   <second-order-command> = <generate-pipeline>  <@ SecondOrderCommand ;
";


(************************************************************)
(* Combination                                              *)
(************************************************************)

ebnfCommand = "
  <lsamon-command> = <load-data> | <data-transformation> |
              <make-doc-term-mat> | <statistics-command> | <lsi-apply-command> |
              <topics-extraction-command> | <thesaurus-extraction-command> |
              <pipeline-command> | <second-order-command> ;
  ";


(************************************************************)
(* Generate parsers                                         *)
(************************************************************)

res =
    GenerateParsersFromEBNF[ParseToEBNFTokens[#]] & /@
        {ebnfCommonParts, ebnfDataLoad, ebnfDataTransform, ebnfStatistics,
          ebnfDocTermMat, ebnfLSIApplyFuncs, ebnfTopicsExtraction, ebnfThesaurusExtraction,
          ebnfPipelineCommand,
          ebnfGeneratePipeline, ebnfSecondOrderCommand, ebnfCommand};
(* LeafCount /@ res *)


(************************************************************)
(* Modify parsers                                           *)
(************************************************************)

(* No parser modification. *)

(************************************************************)
(* Grammar exposing functions                               *)
(************************************************************)

Clear[LSAMonCommandsSubGrammars];

Options[LSAMonCommandsSubGrammars] = { "Normalize" -> False };

LSAMonCommandsSubGrammars[opts:OptionsPattern[]] :=
    Block[{ normalizeQ = TrueQ[OptionValue[LSAMonCommandsSubGrammars, "Normalize"]], res},

      res =
          Association[
            Map[
              StringReplace[#, "LatentSemanticAnalysisWorkflowsGrammar`Private`"->"" ] -> ToExpression[#] &,
              Names["LatentSemanticAnalysisWorkflowsGrammar`Private`ebnf*"]
            ]
          ];

      If[ normalizeQ, Map[GrammarNormalize, res], res ]
    ];


Clear[LSAMonCommandsGrammar];

Options[LSAMonCommandsGrammar] = Options[LSAMonCommandsSubGrammars];

LSAMonCommandsGrammar[opts:OptionsPattern[]] :=
    Block[{ normalizeQ = TrueQ[OptionValue[LSAMonCommandsGrammar, "Normalize"]], res},

      res = LSAMonCommandsSubGrammars[ opts ];

      res =
          StringRiffle[
            Prepend[ Values[KeyDrop[res, "ebnfCommand"]], res["ebnfCommand"]],
            "\n"
          ];

      If[ normalizeQ, GrammarNormalize[res], res ]
    ];

End[]; (* `Private` *)

EndPackage[]