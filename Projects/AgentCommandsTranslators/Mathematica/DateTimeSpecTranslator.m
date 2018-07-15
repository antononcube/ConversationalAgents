(*
    Date-time specifications translator Mathematica package
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

(* :Title: DateTimeSpecTranslator *)
(* :Context: DateTimeSpecTranslator` *)
(* :Author: Anton Antonov *)
(* :Date: 2018-07-15 *)

(* :Package Version: 0.1 *)
(* :Mathematica Version: *)
(* :Copyright: (c) 2018 Anton Antonov *)
(* :Keywords: *)
(* :Discussion: *)

(*BeginPackage["DateTimeSpecTranslator`"]*)
(** Exported symbols added here with SymbolName::usage *)

(*Begin["`Private`"]*)

Clear[TDateTimeSpec]
TDateTimeSpec[parsed_] :=
    Block[{keys, aSpec},
      keys = {"Year", "Month", "Day", "Hour", "Minute", "Second"};
      aSpec = Join[Join @@ parsed, AssociationThread[keys, Date[]]];
      DateObject[Map[aSpec[#] &, Most[keys]]]
    ];

Clear[TDateFull]
TDateFull[parsed_] := parsed;

Select[
  StringSplit[
    "'january' | 'february' | 'march' | 'april' | 'may' | 'june' | \
'july' | 'august' | 'september' | 'october' | 'november' | \
'december'", {"|", "'"}], StringLength[#] > 2 &]

Out[47]= {"january", "february", "march", "april", "may", "june",
  "july", "august", "september", "october", "november", "december"}

In[48]:= aMonthNameToInteger =
    Join[
      AssociationThread[{"january", "february", "march", "april", "may",
        "june", "july", "august", "september", "october", "november",
        "december"}, Range[12]],
      AssociationThread[{"jan", "feb", "mar", "apr", "may", "jun", "jul",
        "aug", "sep", "oct", "nov", "dec"}, Range[12]]
    ];

Clear[TMonthName]
TMonthName[parsed_] := Month[aMonthNameToInteger[parsed]];

Clear[TTimeSpec]
TTimeSpec[parsed_] :=
    AssociationThread[Map[ToString@*Head, parsed], Map[First, parsed]];

Clear[TDateSpec]
TDateSpec[parsed_] :=
    Block[{aDefault, aSpec, keys},
      keys = {"Year", "Month", "Day"};
      aDefault = AssociationThread[keys -> Take[Date[], 3]];

      aSpec =
          Which[
            TrueQ[parsed == "today"],
            AssociationThread[keys, Take[Date[], 3]],

            TrueQ[parsed == "yesterday"],
            AssociationThread[keys, Take[DatePlus[Date[], -1], 3]],

            True,
            AssociationThread[Map[ToString@*Head, parsed], Map[First, parsed]]
          ];
      Join[aDefault, aSpec]
    ];

Clear[ToDateObject]
ToDateObject[pres_]:=
    Block[{
      DateTimeSpec = TDateTimeSpec,
      MonthName = TMonthName,
      DateFull = TDateFull,
      TimeSpec = TTimeSpec,
      DateSpec = TDateSpec},
      pres
    ]

(*End[] * `Private` *)

(*EndPackage[]*)