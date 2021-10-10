(* Mathematica Package *)
(* Created by the Wolfram Language Plugin for IntelliJ, see http://wlplugin.halirutan.de/ *)

(* :Title: OOPPhoneDialingDialogsAgent *)
(* :Context: OOPPhoneDialingDialogsAgent` *)
(* :Author: Anton Antonov *)
(* :Date: 2021-10-10 *)

(* :Package Version: 0.1 *)
(* :Mathematica Version: 12.1 *)
(* :Copyright: (c) 2021 Anton Antonov *)
(* :Keywords: *)
(* :Discussion: *)

(*BeginPackage["OOPPhoneDialingDialogsAgent`"];*)
(* Exported symbols added here with SymbolName::usage *)

If[ Length[SubValues[FunctionalParsers`ParseAlternativeComposition]] == 0,
  Echo["ExternalParsersHookup.m", "Importing from GitHub:"];
  Import["https://raw.githubusercontent.com/antononcube/MathematicaForPrediction/master/FunctionalParsers.m"];
];

If[ Length[DownValues[$OOPFSMHEAD]] == 0,
  Echo["OOPFiniteStateMachine.m", "Importing from GitHub:"];
  Import["https://raw.githubusercontent.com/antononcube/ConversationalAgents/master/Packages/WL/OOPFiniteStateMachine.m"];
];

If[ True,
  Echo["PhoneCallingDialogsGrammarRules.m", "Importing from GitHub:"];
  Import["https://raw.githubusercontent.com/antononcube/ConversationalAgents/master/Projects/PhoneDialingDialogsAgent/Mathematica/PhoneCallingDialogsGrammarRules.m"];
];


(*==========================================================*)
(* Parameters                                               *)
(*==========================================================*)

parsingByAddressBookQ = False;

(*==========================================================*)
(* Make the grammars                                        *)
(*==========================================================*)

tokens = ToTokens[callingContacts];
res = GenerateParsersFromEBNF[tokens];
Echo[Row[{"LeafCount @ GenerateParsersFromEBNF @ ToTokens @ callingContacts = ", LeafCount[res]}], "OOPPhoneDialingDialogsAgent:"];

stopWords = Complement[DictionaryLookup["*"], DeleteStopwords[DictionaryLookup["*"]]];

If[parsingByAddressBookQ,
  Echo["Parsing by address book.", "OOPPhoneDialingDialogsAgent:"];

  pCONTACTNAME[xs$_] :=
      ParseApply[ToExpression["ContactName[#]&"], ParsePredicate[IsContactNameQ]][xs$];
  pCONTACTOCCUPATION[xs$_] :=
      ParseApply[ToExpression["Occupation[#]&"], ParsePredicate[IsOccupationQ]][xs$];
  pCALLFROMCOMPANY[xs$_] :=
      ParseApply[ToExpression["FromCompany[#]&"],
        ParseSequentialCompositionPickRight[
          ParseAlternativeComposition[ParseSymbol["from"], ParseSymbol["of"]],
          ParsePredicate[IsCompanyNameQ]]][xs$];,
  (*ELSE*)
  Echo["Not parsing by address book.", "OOPPhoneDialingDialogsAgent:"];

  pCONTACTNAME[xs$_] :=
      ParseApply[ToExpression["ContactName[#]&"],
        ParsePredicate[StringMatchQ[#1, LetterCharacter ..] && ! MemberQ[stopWords, #1] &]][xs$];
  pCONTACTOCCUPATION[xs$_] :=
      ParseApply[ToExpression["Occupation[#]&"],
        ParsePredicate[StringMatchQ[#1, LetterCharacter ..] && ! MemberQ[stopWords, #1] &]][xs$];
  pCALLFROMCOMPANY[xs$_] :=
      ParseApply[ToExpression["FromCompany[#]&"],
        ParseSequentialCompositionPickRight[
          ParseAlternativeComposition[ParseSymbol["from"], ParseSymbol["of"]],
          ParsePredicate[StringMatchQ[#1, LetterCharacter ..] && ! MemberQ[stopWords, #1] &]]][xs$];
];

(*==========================================================*)
(* Get phone book dataset                                   *)
(*==========================================================*)

Echo["Ingesting address book CSV file.", "OOPPhoneDialingDialogsAgent:"];
dsPhoneBook = ResourceFunction["ImportCSVToDataset"]["https://raw.githubusercontent.com/antononcube/ConversationalAgents/master/Projects/OOPPhoneDialingDialogsAgent/Data/dsPhoneBook.csv"];


(*==========================================================*)
(* FSM prepare object                                       *)
(*==========================================================*)

(*-----------------------------------------------------------*)
(*Make object*)

ClearAll[PhoneBookFSM];

PhoneBookFSM[d_][s_] := Block[{$OOPFSMHEAD = PhoneBookFSM}, FiniteStateMachine[d][s]];

PhoneBookFSM[objID_]["ChooseTransition"[args___]] := Echo[Row[{Style["Wrong arguments:", Red], args}], "ChooseTransition:"];

phbObj = PhoneBookFSM["PhoneBook"];

(*-----------------------------------------------------------*)
(* States *)

phbObj["AddState"["WaitForRequest", (Echo["Please enter contact request.", "WaitForRequest:"]; #["Dataset"] = dsPhoneBook) &]];

phbObj["AddState"["ListOfContacts", Echo["Listing contacts...", "ListOfContacts[Action]:"] &]];

phbObj["AddState"["PrioritizedList", Echo["Prioritized dataset...", "PrioritizedList:"] &]];

phbObj["AddState"["WaitForFilter", Echo["Enter a filter...", "WaitForFilter[Action]:"] &]];

phbObj["AddState"["DialPhoneNumber", Echo[Row[{"Dial phone number:", Spacer[3], #["Dataset"][[1]]}], "DialPhoneNumber:"] &]];

phbObj["AddState"["Help", Echo[Row[{"Here is help:", "..."}], "Help:"] &]];

phbObj["AddState"["Exit", Echo[Style["Shutting down...", Bold], "Exit:"] &]];

(*-----------------------------------------------------------*)
(*Transitions*)

phbObj["AddTransition"["WaitForRequest", "contactSpec", "ListOfContacts"]];
phbObj["AddTransition"["WaitForRequest", "startOver", "WaitForRequest"]];
phbObj["AddTransition"["WaitForRequest", "priority", "PrioritizedList"]];
phbObj["AddTransition"["PrioritizedList", "priorityListGiven", "WaitForRequest"]];
phbObj["AddTransition"["ListOfContacts", "manyContacts", "WaitForFilter"]];
phbObj["AddTransition"["ListOfContacts", "noContacts", "WaitForRequest"]];
phbObj["AddTransition"["ListOfContacts", "uniqueContactObtained", "DialPhoneNumber"]];
phbObj["AddTransition"["DialPhoneNumber", "hungUp", "WaitForRequest"]];
phbObj["AddTransition"["WaitForFilter", "startOver", "WaitForRequest"]];
phbObj["AddTransition"["WaitForFilter", "filterInput", "ListOfContacts"]];
phbObj["AddTransition"["WaitForFilter", "priority", "PrioritizedList"]];
phbObj["AddTransition"["WaitForFilter", "unrecognized", "WaitForFilter"]];

phbObj["AddTransition"["Help", "helpGiven", "WaitForRequest"]];
phbObj["AddTransition"["WaitForRequest", "help", "Help"]];
phbObj["AddTransition"["WaitForFilter", "help", "Help"]];

phbObj["AddTransition"["WaitForRequest", "quit", "Exit"]];
phbObj["AddTransition"["WaitForFilter", "quit", "Exit"]];

(*-----------------------------------------------------------*)
(*Make state transition graph*)

Echo[ phbObj["Graph"[ImageSize -> 900, EdgeLabelStyle -> Directive[Red, Italic, Bold, 16]]], "OOPPhoneDialingDialogsAgent:"]

(*==========================================================*)
(* Finite state machine code                                *)
(*==========================================================*)

(*-----------------------------------------------------------*)
(*WaitForRequest*)

PhoneBookFSM[objID_]["ChooseTransition"[stateID : "WaitForRequest", maxLoops_Integer : 5]] :=
    Block[{obj = PhoneBookFSM[objID], transitions, input, pres},

      transitions = PhoneBookFSM[objID]["States"][stateID]["ExplicitNext"];
      ECHOLOGGING[Style[transitions, Purple], stateID <> ":"];

      input = InputString[];

      (*Check was "global" command was entered.E.g."start over".*)

      pres = ParseShortest[pCALLGLOBAL][ToTokens[ToLowerCase[input]]];

      ECHOLOGGING[Row[{"Parsed global command:", pres}], stateID];

      Which[
        (*Quit request*)
        MemberQ[{"quit"}, ToLowerCase[input]] || Length[pres] > 0 && MemberQ[Flatten[pres], Global["quit"]],
        Echo["Quiting.", "WaitForRequest:"];
        Return[First@Select[transitions, #ID == "quit" || #To == "Exit" &]],

        (*Cancel/start over request*)
        Length[pres] > 0 && MemberQ[Flatten[pres], Global["cancel"]],
        Echo["Starting over.", "WaitForRequest:"];
        Return[First@Select[transitions, #ID == "startOver" || #To == "WaitForRequest" &]],

        (*Priority list request*)
        Length[pres] > 0 && MemberQ[Flatten[pres], Global["priority"]],
        Return[First@Select[transitions, #ID == "priority" || #To == "PrioritizedList" &]],

        (*Other global commands*)
        Length[pres] > 0 && ! Developer`EmptyQ[Cases[pres, Global[___], Infinity]],
        Echo["No implemented reaction for the given service input.", "WaitForRequest:"];
        Return[First@Select[transitions, #ID == "startOver" || #To == "WaitForRequest" &]]
      ];

      (*Main command*)
      pres = ParseShortest[pCALLCONTACT][ToTokens[ToLowerCase[input]]];

      ECHOLOGGING[Row[{"Parsed main command:", pres}], stateID];

      (*If it cannot be parsed,show message*)

      If[pres === {} || pres[[1, 1]] =!= {},
        Return[First@Select[transitions, #ID == "startOver" || #To == "WaitForRequest" &]]
      ];

      (*Switch to the next state*)
      obj["ContactSpec"] = Flatten[pres];
      Return[First@Select[transitions, #ID == "contactSpec" || #To == "ListOfContacts" &]]
    ];

(*-----------------------------------------------------------*)
(*ListOfContacts*)

aParsedToPred = {
  ContactName[p_] :> (Quiet[StringMatchQ[#Name, ___ ~~ p ~~ ___, IgnoreCase -> True]]),
  Occupation[p_] :> (Quiet[StringMatchQ[#Occupation, ___ ~~ p ~~ ___, IgnoreCase -> True]]),
  FromCompany[p_] :> (Quiet[StringMatchQ[#Org, ___ ~~ p ~~ ___, IgnoreCase -> True]]),
  Age[p_] :> (#Age == p)
};


PhoneBookFSM[objID_]["ChooseTransition"[stateID : "ListOfContacts", maxLoops_Integer : 5]] :=
    Block[{obj = PhoneBookFSM[objID], k = 0, transitions, input, pres, dsNew},

      transitions = PhoneBookFSM[objID]["States"][stateID]["ExplicitNext"];
      ECHOLOGGING[Style[transitions, Purple], stateID <> ":"];

      ECHOLOGGING[Row[{"Using the contact spec:", Spacer[3], obj["ContactSpec"]}], "ListOfContacts:"];

      (* Get new dataset *)
      dsNew =
          If[IntegerQ[obj["ContactSpec"]] || VectorQ[obj["ContactSpec"], IntegerQ],
            obj["Dataset"][obj["ContactSpec"]],
            (*ELSE*)

            With[{pred = Apply[And, obj["ContactSpec"] /. aParsedToPred]},
              obj["Dataset"][Select[pred &]]
            ]
          ];

      Echo[Row[{"Obtained the records:", dsNew}], stateID <> ":"];

      Which[
        (*No contacts*)
        Length[dsNew] == 0,
        Echo[
          Row[{Style["No results with the contact specification.", Red, Italic], Spacer[3], obj["ContactSpec"]}],
          "ListOfContacts:"
        ];
        Return[First@Select[transitions, #ID == "startOver" || #To == "WaitForRequest" &]],

        (*Just one contact*)
        Length[dsNew] == 1,
        obj["Dataset"] = dsNew;
        Return[First@Select[transitions, #ID == "uniqueContactObtained" || #To == "DialPhoneNumber" &]],

        (*Many contacts*)
        Length[dsNew] > 1,
        obj["Dataset"] = dsNew;
        Return[First@Select[transitions, #ID == "manyContacts" || #To == "WaitForFilter" &]]
      ]
    ];

(*-----------------------------------------------------------*)
(*WaitForFilter*)

PhoneBookFSM[objID_]["ChooseTransition"[stateID : "WaitForFilter", maxLoops_Integer : 5]] :=
    Block[{obj = PhoneBookFSM[objID], k = 0, transitions, input, pres, pos},

      transitions = PhoneBookFSM[objID]["States"][stateID]["ExplicitNext"];
      ECHOLOGGING[Style[transitions, Purple], stateID <> ":"];

      input = InputString[];

      (*Check was "global" command was entered.E.g."start over".*)
      pres = ParseShortest[pCALLGLOBAL][ToTokens[ToLowerCase[input]]];

      (*Global request handling delegation*)
      If[Length[pres] > 0,
        Echo["Delegate handling of global requests.", "WaitForFilter:"];
        Return[First@Select[transitions, #ID == "startOver" || #To == "WaitForRequest" &]]
      ];

      (*Main command processing*)
      pres = ParseJust[pCALLFILTER][ToTokens[ToLowerCase[input]]];

      (*Special cases handling*)
      Which[
        (*Cannot parse as filtering command*)

        pres === {} || pres[[1, 1]] =!= {},
        Echo[Style["Unrecognized input.", Red, Italic], "WaitForFilter:"];
        Return[First@Select[transitions, #ID == "unrecognized" || #To == "WaitForFilter" &]],

        (*List position command was entered.E.g."take the third one".*)
        Length[Cases[Flatten[pres], ListPosition[_]]] > 0,
        pos =
            Cases[Flatten[pres], ListPosition[n_] :> n][[1]] /.
                Join[
                  Thread[{"first", "second", "third", "fourth", "fifth", "sixth", "seventh", "eighth", "ninth", "tenth"} -> Range[1, 10]],
                  {"last" -> -1, "former" -> -2, "latter" -> -1}
                ];

        Which[
          NumberQ[pos] && 1 <= Abs[pos] <= Length[obj["Dataset"]],
          obj["ContactSpec"] = {pos};
          Return[First@Select[transitions, #ID == "filterInput" || #To == "ListOfContacts" &]],

          NumberQ[pos],
          Echo[Style["The specified position is out of range!", Red, Italic], "WaitForFilter:"];
          Return[First@Select[transitions, #ID == "unrecognized" || #To == "WaitForFilter" &]],

          True,
          Echo[Style["Unrecognized input.", Red, Italic], "WaitForFilter:"];
          Return[First@Select[transitions, #ID == "unrecognized" || #To == "WaitForFilter" &]]
        ]
      ];

      (*Process "regularly" expected filtering input.*)
      pres = SortBy[pres, Length[#[[2]]] &][[1]];

      (*Switch to the next state*)
      obj["ContactSpec"] = Flatten[pres];
      Return[First@Select[transitions, #ID == "contactSpec" || #To == "ListOfContacts" &]]
    ];

(*-----------------------------------------------------------*)
(*PrioritizedList*)

PhoneBookFSM[objID_]["ChooseTransition"[stateID : "PrioritizedList", maxLoops_Integer : 5]] :=
    Block[{obj = PhoneBookFSM[objID], transitions},

      transitions = PhoneBookFSM[objID]["States"][stateID]["ExplicitNext"];
      Echo[Style[transitions, Purple], stateID <> ":"];

      Echo[RandomSample[obj["Dataset"]], "PrioritizedList:"];
      First@Select[transitions, #ID == "priorityListGiven" || #To == "WaitForRequest" &]
    ];

(*-----------------------------------------------------------*)
(*DialPhoneNumber*)

PhoneBookFSM[objID_]["ChooseTransition"[stateID : "DialPhoneNumber", maxLoops_Integer : 5]] :=
    Block[{obj = PhoneBookFSM[objID], k = 0, transitions, input},

      transitions = PhoneBookFSM[objID]["States"][stateID]["ExplicitNext"];
      ECHOLOGGING[Style[transitions, Purple], stateID <> ":"];

      Echo[Row[{"Talking to:", obj["Dataset"]}], "DialPhoneNumber:"];

      While[k < maxLoops, k++;

      input = InputString[];

      If[
        MemberQ[{"quit", "hung up"}, ToLowerCase[input]],
        Return[First@Select[transitions, #ID == "startOver" || #To == "WaitForRequest" &]],
        (*ELSE*)

        Echo[Row[{"Continue talking:", Spacer[3], ResourceFunction["RandomFortune"][]}], "DialPhoneNumber:"]
      ];
      ]
    ];

(*Begin["`Private`"];*)

(*End[]; *)(* `Private` *)

(*EndPackage[]*)