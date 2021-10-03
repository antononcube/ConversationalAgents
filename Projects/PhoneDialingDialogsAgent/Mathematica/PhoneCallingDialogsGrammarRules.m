(*
    Phone calling dialogs grammar in EBNF Mathematica code
    Copyright (C) 2017  Anton Antonov

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

    tokens = ToTokens[callingContacts];

    res = GenerateParsersFromEBNF[tokens];

    res // LeafCount
    (* 1985 *)

    stopWords = Complement[#, DeleteStopwords[#]] &@DictionaryLookup["*"];

    pCONTACTNAME[xs$_] :=
     ParseApply[ToExpression["ContactName[#]&"],
       ParsePredicate[StringMatchQ[#1, LetterCharacter ..] && !MemberQ[stopWords, #1] &]][xs$]

    pCONTACTOCCUPATION[xs$_] :=
     ParseApply[ToExpression["Occupation[#]&"],
       ParsePredicate[StringMatchQ[#1, LetterCharacter ..] && !MemberQ[stopWords, #1] &]][xs$]

    pCALLFROMCOMPANY[xs$_] :=
     ParseApply[ToExpression["FromCompany[#]&"],
       ParseSequentialCompositionPickRight[
        ParseAlternativeComposition[ParseSymbol["from"], ParseSymbol["of"]],
        ParsePredicate[StringMatchQ[#1, LetterCharacter ..] && !  MemberQ[stopWords, #1] &]]][xs$]

*)

callingContacts = "
<call-contact> = <call-global> | <call-preamble> &> <contact-spec> | ( 'put' | 'get' ) &> <contact-spec> <& ( 'on' , 'the' , 'phone' ) ;
<call-preamble> = 'call' | 'dial' | 'i' , 'wanna' , 'talk' , 'to' | 'get' ;
<contact-spec> = [ 'the' | 'a' | 'an' ] &> ( <contact-occupation> , [ <call-from-company> ] ) | <contact-name> | { <contact-name> } | ( 'someone'  | [ 'a' ] , 'person' ) &>  <call-from-company> ;
<contact-name> = '_LetterString' <@ ContactName[#]& ;
<contact-occupation> = '_LetterString' <@ Occupation[#]& ;
<call-filter> = <call-global> | [ <call-preamble> ] &> ( <call-list-pos-spec> | <call-filter-company> | <call-filter-occupation> , [ <call-from-company> ] | <call-filter-age> | <contact-name> | { <contact-name> } ) ;
<call-from-company> = ( 'from' | 'of' ) &> '_LetterString' <@ FromCompany[#]& ;
<call-filter-company> =  ( ( 'he' | 'she' ) , 'is' ) &> <call-from-company>  | [ 'the' , 'one' ] &> <call-from-company>  ;
<call-filter-occupation> = ( [ <call-preamble> ] | [ ( 'he' | 'she' ) , 'is' ] , ( 'a' | 'an' | 'the' ) ) &> <contact-occupation> ;
<call-filter-age> = [ 'the' ] &> ( 'younger' | 'older' ) <& [ 'one' ] <@ Age[#]& ;
<call-list-pos-spec> = [ 'the' ] &> ( <call-list-num-pos> | 'last' | 'former' | 'later' ) <& ( [ 'one' ] | [ [ 'one' ] , 'in' , 'the' , 'list' ] ) <@ ListPosition[#]& ;
<call-list-num-pos> = 'first' | 'second' | 'third' | 'fourth' | 'fifth' | 'sixth' | 'seventh' | 'eighth' | 'ninth' | 'tenth' | 'Range[1,100]' ;
<call-meeting-host> = 'call' , 'the' , 'host' , 'of' , 'the' , 'meeting' , <time-spec> ;
<call-meeting-number> = ( 'call' | 'dial' ) , <call-meeting-number> ;
<call-meeting-spec> = 'my' , 'next' , 'meeting' | 'the' , 'meeting' , [ 'i' , 'have' , 'now' ] ;
<call-global> = <call-global-help> | <call-global-cancel> | <call-global-prioritylist> ;
<call-global-help> = 'help' <@ Global[\"help\"]& ;
<call-global-cancel> = 'start' , 'over' | 'cancel' <@ Global[\"cancel\"]& ;
<call-global-prioritylist> = 'priority' , ( 'order' | 'list' ) | 'order' , 'by' , 'priority' <@ Global[\"priority\"]& ;
";