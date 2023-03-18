(*
    Raku Decoder Mathematica package

    BSD 3-Clause License

    Copyright (c) 2021, Anton Antonov
    All rights reserved.

    Redistribution and use in source and binary forms, with or without
    modification, are permitted provided that the following conditions are met:

    * Redistributions of source code must retain the above copyright notice, this
      list of conditions and the following disclaimer.

    * Redistributions in binary form must reproduce the above copyright notice,
      this list of conditions and the following disclaimer in the documentation
      and/or other materials provided with the distribution.

    * Neither the name of the copyright holder nor the names of its
      contributors may be used to endorse or promote products derived from
      this software without specific prior written permission.

    THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
    AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
    IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
    DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
    FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
    DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
    SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
    CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
    OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
    OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

    Written by Anton Antonov,
    antononcube@posteo.net,
    Windermere, Florida, USA.
*)

(*
    Mathematica is (C) Copyright 1988-2021 Wolfram Research, Inc.

    Protected by copyright law and international treaties.

    Unauthorized reproduction or distribution subject to severe civil
    and criminal penalties.

    Mathematica is a registered trademark of Wolfram Research, Inc.
*)

(* Mathematica Package *)
(* Created by the Wolfram Language Plugin for IntelliJ, see http://wlplugin.halirutan.de/ *)

(* :Title: RakuDecoder *)
(* :Context: RakuDecoder` *)
(* :Author: Anton Antonov *)
(* :Date: 2021-12-09 *)

(* :Package Version: 0.1 *)
(* :Mathematica Version: 12.3 *)
(* :Copyright: (c) 2021 Anton Antonov *)
(* :Keywords: *)
(* :Discussion: *)


(***********************************************************)
(* Load packages                                           *)
(***********************************************************)

BeginPackage["RakuDecoder`"];

FromRakuCode::usage = "Convert a Raku expression serialized to WL into a WL expression.";

Begin["`Private`"];

Clear[FromRakuCode];

Options[FromRakuCode] = {
  "ListOfAssociationsToDataset" -> True,
  "AssociationOfAssociationsToDataset" -> True,
  "SameDatasetColumnNames" -> True,
  DisplayFunction -> Dataset};

FromRakuCode[x_, opts : OptionsPattern[]] := x;

FromRakuCode[x_String, opts : OptionsPattern[]] :=
    Block[{res, ladQ, aadQ, sdcnQ, dFunc, lsAllColNames, aDefault, res2},

      ladQ = TrueQ[OptionValue[FromRakuCode, "ListOfAssociationsToDataset"]];
      aadQ = TrueQ[OptionValue[FromRakuCode, "AssociationOfAssociationsToDataset"]];
      sdcnQ = TrueQ[OptionValue[FromRakuCode, "SameDatasetColumnNames"]];
      dFunc = OptionValue[FromRakuCode, DisplayFunction];

      res = ToExpression[x];
      res = First[res];
      Which[

        ladQ && MatchQ[res, List[_Association ..]] && Apply[Equal, Length /@ res],
        res = dFunc[KeySort /@ res],

        aadQ && MatchQ[res, Association[(_ -> _Association) ..]],
        Which[
          Apply[Equal, Length /@ Values[res]],
          res = dFunc[KeySort /@ res],

          sdcnQ,
          lsAllColNames = Union[Flatten[Keys /@ Values[res]]];
          aDefault = AssociationThread[lsAllColNames, Missing[]];
          res2 = Map[Join[aDefault, #] &, res];
          res = dFunc[res2],

          True,
          res
        ],

        True,
        res
      ]
    ] /; StringMatchQ[x, "WLEncoded[" ~~ __];


End[]; (* `Private` *)

EndPackage[]