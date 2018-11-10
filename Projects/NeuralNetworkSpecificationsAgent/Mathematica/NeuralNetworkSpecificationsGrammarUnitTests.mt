(*
    Neural network specifications grammar Mathematica unit tests
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
    antononcube @ gmai l . c om,
    Windermere, Florida, USA.
*)

(*
    Mathematica is (C) Copyright 1988-2018 Wolfram Research, Inc.

    Protected by copyright law and international treaties.

    Unauthorized reproduction or distribution subject to severe civil
    and criminal penalties.

    Mathematica is a registered trademark of Wolfram Research, Inc.
*)

(* :Title: NeuralNetworkSpecificationsGrammarUnitTests *)
(* :Context: NeuralNetworkSpecificationsGrammarUnitTests` *)
(* :Author: Anton Antonov *)
(* :Date: 2018-10-18 *)

(* :Package Version: 0.1 *)
(* :Mathematica Version: *)
(* :Copyright: (c) 2018 Anton Antonov *)
(* :Keywords: *)
(* :Discussion:

   Before running the tests examine the test with TestID->"LoadPackage".

*)

BeginTestSection["NeuralNetworkSpecificationsGrammarUnitTests.wlt"]

VerificationTest[(* 1 *)
  CompoundExpression[
    Import["~/ConversationalAgents/EBNF/English/Mathematica/NeuralNetworkSpecificationsGrammar.m"],
    StringQ[NetMonCommandsGrammar[]] && StringLength[NetMonCommandsGrammar[]] > 1500
  ]
  ,
  True
  ,
  TestID->"LoadPackage"
]

VerificationTest[(* 2 *)
  TNetMonTokenizer = (ParseToTokens[#, {",", "'", "%", "-", "/", "[", "]", "\[DoubleLongRightArrow]", "->"}, {" ", "\t", "\n"}] &)
  TestFunc = ParseShortest[pNETMONCOMMAND][TNetMonTokenizer[#]] &;
  ,
  Null
  ,
  TestID->"DefineTestFunc"
]

VerificationTest[(* 3 *)
  TestFunc["list models"]
  ,
  {{{}, NetRepositoryQuery[ListNetworks[{ListDirective["list"], "models"}]]}}
  ,
  TestID->"ListModels-1"
]

EndTestSection[]
