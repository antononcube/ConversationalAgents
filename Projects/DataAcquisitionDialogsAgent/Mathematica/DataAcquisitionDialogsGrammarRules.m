(*
    Data acquisition dialogs grammar in EBNF Mathematica code
    Copyright (C) 2021  Anton Antonov

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

(* Version 1.0 *)

(* This grammar is intended to be parsed by the functions in the Mathematica package FunctionalParses.m at GitHub,
   see https://github.com/antononcube/MathematicaForPrediction/blob/master/FunctionalParsers.m .

   In order to parse this grammar specification the file can be imported in Mathematica copy all of the grammar rule lines and paste them within
   a pair of string quotes.
*)

(*

Below is the Mathematica code for parsing the EBNF.

    tokens = ToTokens[ebnfDAWCommand];

    res = GenerateParsersFromEBNF[tokens];

    res // LeafCount
    (* 1985 *)

    stopWords = Complement[#, DeleteStopwords[#]] &@DictionaryLookup["*"];

    pDAWTITLE[xs$_] :=
     ParseApply[ToExpression["DAWTitle[#]&"],
       ParsePredicate[StringMatchQ[#1, LetterCharacter ..] && !MemberQ[stopWords, #1] &]][xs$]

    pDAWPACKAGE[xs$_] :=
     ParseApply[ToExpression["DAWPackage[#]&"],
       ParsePredicate[StringMatchQ[#1, LetterCharacter ..] && !MemberQ[stopWords, #1] &]][xs$]

    pFROMPACKAGE[xs$_] :=
     ParseApply[ToExpression["DAWFromPackage[#]&"],
       ParseSequentialCompositionPickRight[
        ParseAlternativeComposition[ParseSymbol["from"], ParseSymbol["of"]],
        ParsePredicate[StringMatchQ[#1, LetterCharacter ..] && !  MemberQ[stopWords, #1] &]]][xs$]

*)

ebnfDAWCommand = "
<daw-any-command> = <daw-command> | <daw-filter> ;
<daw-command> = <daw-global> | <daw-preamble> &> <dataset-spec> | ( 'find' | 'put' | 'get' | 'obtain' ) &> <dataset-spec> <& ( ( 'on' | 'in' | 'to' ) , 'the' , <daw-environment> ) ;
<daw-preamble> = 'procure' | 'obtain' | 'i' , ( 'wanna' | 'want' , 'to' ) , ( 'investigate' | 'work' ) , 'with' | 'get' | 'find' ;
<dataset-spec> = [ 'the' | 'a' | 'an' ] &> ( <daw-package> , [ <daw-from-package> ] ) | <daw-title> | { <daw-title> } | ( 'some'  | [ 'a' ] , <dataset-phrase>  ) &>  <daw-from-package> ;
<daw-title> = '_LetterString' <@ DAWTitle[#]& ;
<daw-package> = '_LetterString' <@ DAWPackage[#]& ;
<daw-from-package> = ( 'from' | 'of' ) &> '_LetterString' <@ DAWFromPackage[#]& ;
<daw-filter> = <daw-global> | [ <daw-preamble> ] &> ( <daw-list-pos-spec> | <daw-filter-package> | <daw-filter-occupation> , [ <daw-from-package> ] | <daw-filter-row-size> | <daw-filter-nrow> | <daw-filter-col-size> | <daw-filter-ncol> | <daw-title> | { <daw-title> } ) ;
<daw-filter-package> =  ( ( 'it' | 'that' ) , 'is' ) &> <daw-from-package>  | [ 'the' , 'one' ] &> <daw-from-package>  ;
<daw-filter-occupation> = ( [ <daw-preamble> ] | [ ( 'it' | 'that' ) , 'is' ] , [ 'from' | 'in' ] , ( 'a' | 'an' | 'the' ) ) &> <daw-package> ;
<daw-filter-row-size> = [ 'the' ] &> ( 'larger' | 'largest' | 'shorter' | 'shortest' ) <& [ 'one' ] <@ DAWNRowSize[#]& ;
<daw-filter-nrow> = ( [ 'the' ] , [ 'one' ] , [ 'that' ] , [ 'has' | 'is' , 'with' ] , [ 'with' ] ) &> '_?IntegerQ' <& ( [ 'number' , 'of' ] , 'rows' , [ 'one' ] ) <@ DAWNRow[#]& ;
<daw-filter-col-size> = [ 'the' ] &> ( 'wider' | 'widest' | 'narrower' | 'narrowest' ) <& [ 'one' ] <@ DAWNColSize[#]& ;
<daw-filter-ncol> = ( [ 'the' ] , [ 'one' ] , [ 'that' ] , [ 'has' | 'is' , 'with' ] , [ 'with' ] ) &> '_?IntegerQ' <& ( [ 'number' , 'of' ] , 'columns' , [ 'one' ] ) <@ DAWNCol[#]& ;
<daw-list-pos-spec> = [ 'the' ] &> ( <daw-list-num-pos> | 'last' | 'former' | 'later' ) <& ( [ 'one' ] | [ [ 'one' ] , 'in' , 'the' , 'list' ] ) <@ ListPosition[#]& ;
<daw-list-num-pos> = 'first' | 'second' | 'third' | 'fourth' | 'fifth' | 'sixth' | 'seventh' | 'eighth' | 'ninth' | 'tenth' | 'Range[1,100]' ;
<daw-usage-spec>  = 'my' , 'next' , <data-analysis-phrase> | 'the' , <data-analysis-phrase> , [ 'i' , 'have' , 'now' ] ;
<daw-global> = <daw-global-help> | <daw-global-cancel> | <daw-global-priority-list> ;
<daw-global-help> = 'help' <@ DAWGlobal[\"help\"]& ;
<daw-global-cancel> = 'start' , 'over' | 'cancel' <@ DAWGlobal[\"cancel\"]& ;
<daw-global-priority-list> = 'priority' , ( 'order' | 'list' ) | 'order' , 'by' , 'priority' <@ DAWGlobal[\"priority\"]& ;
<dataset-phrase> = 'dataset' | [ 'data' ] , 'table' | [ 'tabular' ] , 'data' ;
<data-analysis-phrase> = <dataset-phrase> , [ 'investigation' | 'analysis' | 'research' ] ;
<daw-environment> = 'environment' | 'notebook' ;
";