(*
    Recommender workflows grammar in EBNF
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

(* :Title: RecommenderWorkflowsGrammar *)
(* :Context: RecommenderWorkflowsGrammar` *)
(* :Author: Anton Antonov *)
(* :Date: 2018-09-16 *)

(* :Package Version: 0.1 *)
(* :Mathematica Version: 11.3 *)
(* :Copyright: (c) 2018 Anton Antonov *)
(* :Keywords: EBNF, recommender, grammar *)
(* :Discussion:

   # In brief

   The Extended Backus-Naur Form (EBNF) grammar in this file is intended to be used in a natural language commands
   interface for the creation recommenders and making recommendations using the monad SMRMon:

     https://github.com/antononcube/MathematicaForPrediction/blob/master/MonadicProgramming/MonadicSparseMatrixRecommender.m

   The grammar is partitioned into separate sub-grammars, each sub-grammar corresponding to a conceptual set of
   functionalities. (The intent is to facilitate understanding and further development.)


   # How to use

   This grammar is intended to be parsed by the functions in the Mathematica package FunctionalParses.m at GitHub,
   see https://github.com/antononcube/MathematicaForPrediction/blob/master/FunctionalParsers.m .

   (The file can be run in Mathematica with Get or Import.)


   # Example

   The following sequence of commands are parsed by the parsers generated with the grammar.

      Import["https://raw.githubusercontent.com/antononcube/ConversationalAgents/master/EBNF/RecommenderWorkflowsGrammar.m"]
      Import["https://raw.githubusercontent.com/antononcube/MathematicaForPrediction/master/FunctionalParsers.m"]


   ...


   # Implementation considerations

   - Currently the implementation symbols refer to SMRMon, but probably a more universal prefix should be used
     like "IIRMon".



   Anton Antonov
   2018-09-16
*)


If[Length[DownValues[FunctionalParsers`ParseToEBNFTokens]] == 0,
  Echo["FunctionalParsers.m", "Importing from GitHub:"];
  Import["https://raw.githubusercontent.com/antononcube/MathematicaForPrediction/master/FunctionalParsers.m"]
];

BeginPackage["RecommenderWorkflowsGrammar`"]

pSMRMONCOMMAND::usage = "Parses natural language commands for recommendations workflows."

SMRMonCommandsSubGrammars::usage = "Gives an association of the EBNF sub-grammars for parsing natural language commands \
specifying SMRMon pipelines construction."

SMRMonCommandsGrammar::usage = "Gives as a string an EBNF grammar for parsing natural language commands \
specifying SMRMon pipelines construction."

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
  <recommend-directive> = 'recommend' | 'suggest' <@ RecommendDirective ;
  <recommendation-matrix>  = [ 'recommendation' ] , 'matrix' <@ RecommendationMatrix ;
  <number-of> = [ 'the' ] , ( 'number' | 'count' ) , 'of' <@ NumberOf ;
  <score-association-symbol> = '->' | ':' <@ ScoreAssociationSymbol ;
  <consumption-profile> = [ 'consumption' ] , 'profile' <@ ConsumptionProfile ;
";

(************************************************************)
(* SMR create command                                       *)
(************************************************************)

ebnfCreateCommand = "
  <create-command> = <generate-directive> , <using-preposition> , <smr-dataset-spec> [ <with-proposition> , <id-column-spec> ] <@ SMRCreateCommand ;
  <smr-dataset-spec> = '_String' <@ SMRDatasetSpec ;
  <smr-matrix-association-spec> = '_String' <@ SMRMatrixAssociation ;
  <id-column-spec> = '_String' <@ SMRIDColumnSpec ;
";

(************************************************************)
(* SMR object properties queries                            *)
(************************************************************)

ebnfSMRQuery = "
  <smr-property-query> = <display-directive> , [ 'the' ] , <smr-property-spec> <@ SMRPropertyQuery ;
  <smr-property-spec> = <smr-context-property> | <smr-matrix-property> <@ SMRPropertySpec ;
  <smr-context-property> = 'tag' , 'types' | 'tags' | [ 'sparse' ] , 'matrices' | <recommendation-matrix> <@ SMRContextProperty@*Flatten@*List ;
  <smr-matrix-property> = <smr-matrix-columns> | <smr-matrix-rows> | <smr-matrix-dimensions> | <smr-matrix-density> <@ SMRMatrixProperty ;
  <smr-matrix-columns> = <recommendation-matrix> , <number-of> , 'columns' <@ SMRMatrixColumns ;
  <smr-matrix-rows> = <recommendation-matrix> , <number-of> , 'rows' <@ SMRMatrixRows ;
  <smr-matrix-dimensions> = <recommendation-matrix> , 'dimensions' <@ SMRMatrixDimensions ;
  <smr-matrix-density> = <recommendation-matrix> , 'density' <@ SMRMatrixDensity ;
";

(************************************************************)
(* Recommendations                                          *)
(************************************************************)

ebnfRecommend = "
  <recommend-by-history-command> = <recommend-directive> , <using-preposition> , <history-spec> ;
  <recommend-by-history-command> = <recommend-directive> , <using-preposition> , [ 'the' ] , <consumption-profile> , <profile-spec> ;
";

ebnfHistorySpec = "
  <history-spec> = <items-list> | <scored-items-list> ;
  <item> = '_String' <@ SMRItem ;
  <items-list> = <item> , [ { <list-delimiter> , <item> } ] <@ SMRItemsList ;
  <scored-item> = <item> , <score-association-symbol> , <number-value> <@ SMRScoredItem ;
  <scored-items-list> = <scored-item> , [ { <list-delimiter> , <scored-item> } ] <@ SMRScoredItemsList ;
";

ebnfProfileSpec = "
  <profile-spec> = <items-list> | <scored-items-list> ;
";

(************************************************************)
(* Additional SMR commands                                  *)
(************************************************************)

ebnfMakeProfile = "
  <make-profile> = <compute-directive> , [ 'the' ] , <consumption-profile> , <using-preposition> , <item-history-spec> <@ SMRMakeProfile ;
";


(************************************************************)
(* Combination                                              *)
(************************************************************)

ebnfCommand = "
  <smrmon-command> =
     <create-command> | <summarize-data> |
     <apply-term-weight-functions> |
     <apply-global-term-weight-function> | <apply-local-term-weight-function> | <apply-term-normalizer-function> |
     <recommender-creation> | <recommend-by-history> | <recommend-by-profile> |
     <set-tag-type-weights> | <set-tags-weight> |
     <pipeline-command> | <second-order-command> ;
  ";


(************************************************************)
(* Generate parsers                                         *)
(************************************************************)

res =
    GenerateParsersFromEBNF[ParseToEBNFTokens[#]] & /@
        {ebnfCommonParts,
          ebnfCreateCommand, ebnfSMRQuery,
          ebnfRecommend, ebnfHistorySpec, ebnfProfileSpec,
          ebnfMakeProfile,
          ebnfPipelineCommand, ebnfGeneratePipeline, ebnfSecondOrderCommand, ebnfCommand};
(* LeafCount /@ res *)


(************************************************************)
(* Modify parsers                                           *)
(************************************************************)

(* No parser modification. *)

(************************************************************)
(* Grammar exposing functions                               *)
(************************************************************)

Clear[SMRConCommandsSubGrammars]

Options[SMRConCommandsSubGrammars] = { "Normalize" -> False };

SMRConCommandsSubGrammars[opts:OptionsPattern[]] :=
    Block[{ normalizeQ = TrueQ[OptionValue[SMRMonCommandsSubGrammars, "Normalize"]], res},

      res =
          Association[
            Map[
              StringReplace[#, "RecommenderWorkflowsGrammar`Private`"->"" ] -> ToExpression[#] &,
              Names["RecommenderWorkflowsGrammar`Private`ebnf*"]
            ]
          ];

      If[ normalizeQ, Map[GrammarNormalize, res], res ]
    ];


Clear[SMRMonCommandsGrammar]

Options[SMRMonCommandsGrammar] = Options[SMRMonCommandsSubGrammars];

SMRMonCommandsGrammar[opts:OptionsPattern[]] :=
    Block[{ normalizeQ = TrueQ[OptionValue[SMRMonCommandsGrammar, "Normalize"]], res},

      res = SMRMonCommandsSubGrammars[ opts ];

      res =
          StringRiffle[
            Prepend[ Values[KeyDrop[res, "ebnfCommand"]], res["ebnfCommand"]],
            "\n"
          ];

      If[ normalizeQ, GrammarNormalize[res], res ]
    ];


End[]; (* `Private` *)

EndPackage[]