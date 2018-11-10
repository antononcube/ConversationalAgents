(*
    NetMon translator Mathematica package
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


(* :Title: NetMonTranslator *)
(* :Context: NetMonTranslator` *)
(* :Author: Anton Antonov *)
(* :Date: 2018-06-14 *)

(* :Package Version: 0.1 *)
(* :Mathematica Version: 11.3 *)
(* :Copyright: (c) 2018 Anton Antonov *)
(* :Keywords: *)
(* :Discussion:


   # In brief

   This package has functions for translation of natural language commands of the grammar [1]
   to monadic pipelines of the "monad" [2]. (That "monad" is referred to as "NetMon".)

   The translation process is fairly direct (simple) -- a natural language command is translated to pipeline operator(s).

   # How to use

   # References

   [1] Anton Antonov, Classifier workflows grammar in EBNF, 2018, ConversationalAgents at GitHub,
       https://github.com/antononcube/ConversationalAgents/blob/master/EBNF/NeuralNetworksSpecificationsGrammar.m

   [2] Wolfram Research, "Neural Networks, guide page", wolfram.com,
       https://reference.wolfram.com/language/guide/NeuralNetworks.html

   This file was created by Mathematica Plugin for IntelliJ IDEA.

   Anton Antonov
   Oxford, UK
   2018-06-14
*)


If[Length[DownValues[NeuralNetworkSpecificationsGrammar`pNETMONCOMMAND]] == 0,
  Echo["NeuralNetworkSpecificationsGrammar.m", "Importing from GitHub:"];
  Import["https://raw.githubusercontent.com/antononcube/ConversationalAgents/master/EBNF/English/Mathematica/NeuralNetworkSpecificationsGrammar.m"]
];

(***********************************************************)
(* Net chain                                               *)
(***********************************************************)

Clear[TLayerName]
TLayerName[parsed_List] :=
    ToExpression[StringJoin@StringReplace[parsed, WordBoundary ~~ x_ :> ToUpperCase[x]]];

Clear[TLayer]
TLayer[parsed_] := ToExpression[parsed];

Clear[TLayerCommonFunc]
TLayerCommonFunc[parsed_] := ToExpression[parsed];

Clear[TLayerFuncName]
TLayerFuncName[parsed_] := parsed;

Clear[TLayerNameSpec]
TLayerNameSpec[parsed_] :=
    Which[

      Length[parsed] == 1,
      parsed[[1]][],

      TrueQ[parsed[[2]] == {"[", "]"}] || TrueQ[parsed[[2]] == {}],
      parsed[[1]][],

      True,
      parsed[[1]]@parsed[[2]]

    ];

Clear[TLayerSpec]
TLayerSpec = TLayerNameSpec;

Clear[TLayerList]
TLayerList[parsed_] := parsed;

Clear[TNetLayerChain]
TNetLayerChain[parsed_List] := NetMonSetNet[ NetChain[parsed] ];


(***********************************************************)
(* Main translation functions                              *)
(***********************************************************)

Clear[TNetMonTokenizer];
TNetMonTokenizer = (ParseToTokens[#, {",", "'", "%", "-", "/", "[", "]", "⟹", "->"}, {" ", "\t", "\n"}] &)

ClearAll[TranslateToNetMon]

Options[TranslateToNetMon] = { "TokenizerFunction" -> (ParseToTokens[#, {",", "'", "%", "-", "/", "[", "]", "⟹", "->"}, {" ", "\t", "\n"}] &) };

TranslateToNetMon[commands_String, parser_Symbol:pNETMONCOMMAND, opts:OptionsPattern[]] :=
    TranslateToNetMon[ StringSplit[commands, {".", ";"}], parser, opts ];

TranslateToNetMon[commands:{_String..}, parser_Symbol:pNETMONCOMMAND, opts:OptionsPattern[]] :=
    Block[{parsedSeq, tokenizerFunc },

      tokenizerFunc = OptionValue[TranslateToNetMon, "TokenizerFunction"];

      parsedSeq = ParseShortest[parser][tokenizerFunc[#]] & /@ commands;

      TranslateToNetMon[ parsedSeq ]
    ];

TranslateToNetMon[pres_] :=
    Block[{
      LayerName = TLayerName,
      Layer = TLayer,
      LayerCommonFunc = TLayerCommonFunc,
      LayerFuncName = TLayerFuncName,
      LayerNameSpec = TLayerNameSpec,
      LayerSpec = TLayerSpec,
      LayerList = TLayerList,
      NetLayerChain = TNetLayerChain,
      NumericValue = Identity},
      pres
    ];


(* This code is very similar / same as the one for ToNetMonPipelineFunction. *)

ClearAll[ToNetMonPipelineFunction]

Options[ToNetMonPipelineFunction] =
    { "Trace" -> False,
      "TokenizerFunction" -> (ParseToTokens[#, {",", "'", "%", "-", "/", "[", "]", "⟹", "->"}, {" ", "\t", "\n"}] &),
      "Flatten" -> True };

ToNetMonPipelineFunction[commands_String, parser_Symbol:pNETMONCOMMAND, opts:OptionsPattern[] ] :=
    ToNetMonPipelineFunction[ StringSplit[commands, {";"}], parser, opts ];

ToNetMonPipelineFunction[commands:{_String..}, parser_Symbol:pNETMONCOMMAND, opts:OptionsPattern[] ] :=
    Block[{parsedSeq, tokenizerFunc, res},

      tokenizerFunc = OptionValue[ToNetMonPipelineFunction, "TokenizerFunction"];

      parsedSeq = ParseShortest[parser][tokenizerFunc[#]] & /@ commands;

      parsedSeq = Select[parsedSeq, Length[#] > 0& ];

      If[ Length[parsedSeq] == 0,
        Echo["Cannot parse command(s).", "ToNetMonPipelineFunction:"];
        Return[$NetMonFailure]
      ];

      res =
          If[ TrueQ[OptionValue[ToNetMonPipelineFunction, "Trace"]],

            ToNetMonPipelineFunction[ AssociationThread[ commands, parsedSeq[[All,1,2]] ] ],
          (*ELSE*)
            ToNetMonPipelineFunction[ parsedSeq[[All,1,2]] ]
          ];

      If[ TrueQ[OptionValue[ToNetMonPipelineFunction, "Flatten"] ],
        res //. DoubleLongRightArrow[DoubleLongRightArrow[x__], y__] :> DoubleLongRightArrow[x, y],
      (*ELSE*)
        res
      ]
    ];

ToNetMonPipelineFunction[pres_List] :=
    Block[{t, parsedSeq=pres},

      If[ Head[First[pres]] === LoadData, parsedSeq = Rest[pres]];

      t = TranslateToNetMon[parsedSeq];

      (* Note that we can use:
         Fold[NetMonBind[#1,#2]&,First[t],Rest[t]] *)
      Function[{x, c},
        Evaluate[DoubleLongRightArrow @@ Prepend[t, NetMonUnit[x, c]]]]
    ];

ToNetMonPipelineFunction[pres_Association] :=
    Block[{t, parsedSeq=Values[pres], comments = Keys[pres]},

      If[ Head[First[pres]] === LoadData, parsedSeq = Rest[parsedSeq]; comments = Rest[comments] ];

      t = TranslateToNetMon[parsedSeq];

      (* Note that we can use:
         Fold[NetMonBind[#1,#2]&,First[t],Rest[t]] *)
      Function[{x, c},
        Evaluate[
          DoubleLongRightArrow @@
              Prepend[Riffle[t,comments], TraceMonadUnit[NetMonUnit[x, c]]]]
      ]
    ];
