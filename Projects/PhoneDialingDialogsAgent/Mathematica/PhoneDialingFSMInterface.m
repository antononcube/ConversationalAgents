(*
    Phone dialing dialogs fininte state machine interface Mathematica code
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

(* :Title: PhoneDialingFSMInterface *)
(* :Context: Global` *)
(* :Author: Anton Antonov *)
(* :Date: 2017-04-15 *)

(* :Package Version: 0.1 *)
(* :Mathematica Version: *)
(* :Copyright: (c) 2017 Anton Antonov *)
(* :Keywords: *)
(* :Discussion:

    This dynamic interface utilized the functions from the file:

     https://github.com/antononcube/ConversationalAgents/blob/master/Projects/PhoneDialingDialogsAgent/Mathematica/PhoneDialingFSM.m

*)

{viWidth} = {600};
{textOffset, rx, ry} = {0.01, 0.01, 0.004};
Magnify[
  DynamicModule[{input = "", fsmState = "WaitingForARequest",
    fsmMessage = {}, fsmContext = {}, speechMessage = "",
    visualMessage = "", t},
    ColumnForm[{
      Panel[
        Row[
          {Style["speech input : ", Blue],
            InputField[Dynamic[input], String, FieldSize -> Medium], "  ",
            Button["Hung-up", (fsmState = "WaitingForARequest"; fsmMessage = {};
            speechMessage = ""; visualMessage = ""; input = "";
            fsmContext = DeleteCases[fsmContext, "filters" -> _]),
              Enabled -> Dynamic[If[fsmState == "DialPhoneNumber", True, False]],
              ImageSize -> Large], " ",
            Button["Dial",
              (input = "priority order";
              fsmContext = DeleteCases[fsmContext, "filters" -> _]),
              ImageSize -> Large]
          }]
        , ImageSize -> {viWidth, 60}],
      Dynamic[
        If[fsmState != "DialPhoneNumber" && StringLength[input] > 0,
          {fsmState, fsmMessage, fsmContext, speechMessage, visualMessage} = PCESM[fsmState, fsmContext, input];
          If[fsmState == "ListOfContactsForAQuery" || fsmState == "PrioritizedList",
            {fsmState, fsmMessage, fsmContext, t, visualMessage} = PCESM[fsmState, fsmContext, input];
          ];
        ];
        Print[speechMessage];
        Print[
          ColumnForm[{fsmState, fsmMessage, fsmContext, speechMessage, visualMessage}]];
        ColumnForm[
          {Panel[
            Column[
              {Style["spoken", Blue], speechMessage }],
            ImageSize -> {viWidth, 50}],
            Panel[
              Column[{Style["shown", Blue],
                If[ListQ[visualMessage],
                  TableForm[visualMessage],
                  TableForm[{visualMessage}]
                ]
              }],
              ImageSize -> {viWidth, 300}]}],
        TrackedSymbols :> {input}]
    }]
  ], 1.4]