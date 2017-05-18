# Phone Dialing Dialogs Conversational Agent

## Introduction

Has repository designs and implementations of a phone calling conversational agent that aims at 
providing the following functionalities: 
- contacts retrieval (querying, filtering, selection), 
- contacts prioritization, and 
- phone call (work flow) handling.

The design is based on a Finite State Machine (FSM) and context free grammar(s) for commands 
that switch between the states of the FSM. 
The grammar is designed as a context free grammar rules of a Domain Specific Language (DSL) in 
[Extended Backus-Naur Form](https://en.wikipedia.org/wiki/Extended_Backus–Naur_form) (EBNF). (For more details on DSLs design and programming see 
\[[1](https://mathematicaforprediction.wordpress.com/2016/03/22/creating-and-programming-dsls/)\].)

The (current) implementation is with Mathematica, using the functional parsers package 
\[[2](https://github.com/antononcube/MathematicaForPrediction/blob/master/FunctionalParsers.m),[3](https://mathematicaforprediction.wordpress.com/2014/02/13/natural-language-processing-with-functional-parsers/)\].

## General design

The design of the Phone Conversational Agent (PhCA) is derived in a straightforward manner from the typical work flow and contacts queries.

The main goals for the conversational agent are the following:

1. contacts retrieval -- search, filtering, selection -- using both voice commands and manual interaction,
2. intuitive integration with the usual work flow of phone calling.

Additional goal is to facilitate contacts retrieval by determining the most appropriate contacts in query responses. For example, while driving to work by pressing the dial button we might prefer the contacts of an up-coming meeting to be placed on top of the contacts list.

In this document we assume that the voice to text conversion is done with a existing (reliable) component.

It is assumed that user of PhCA can react on both visual and spoken query results. 

The main algorithm is the following.

**1)** Parse and interpret a natural language command.

**2)** If the command is a contacts query that returns a single contact then call that contact.

**3)** If the command is a contacts query that returns multiple contacts then :

**3.1)** use natural language commands to refine and filter the query results,

**3.2)** until a single contact is obtained. Call that single contact.

**4)** If other type of command is given act accordingly.

PhCA has commands for system usage help and canceling the current contact search and starting over.

The following FSM diagram is the basic structure of PhCA:

[!["Phone-conversational-agent-FSM-and-DB"](http://imgur.com/v7vCkRrm.jpg)](http://imgur.com/v7vCkRr.jpg)

## Grammar design
 
 The base grammar is given in the file ["./Mathematica/PhoneCallingDialogsGrammarRules.m"](https://github.com/antononcube/ConversationalAgents/blob/master/Projects/PhoneDialingDialogsAgent/Mathematica/PhoneCallingDialogsGrammarRules.m)
 in EBNF used by \[2\].
 
 Here are parsing results of a set of test commands:
 
 [!["PhCA-base-grammar-test-queries-125"](http://imgur.com/xTcBbbQm.png)](http://imgur.com/xTcBbbQ.png)

 In the running script ["./Mathematica/PhoneDialingAgentRunScript.m"](https://github.com/antononcube/ConversationalAgents/blob/master/Projects/PhoneDialingDialogsAgent/Mathematica/PhoneDialingAgentRunScript.m) the grammar parsers are modified to do successful parsing using data elements of the provided [fake address book](https://github.com/antononcube/ConversationalAgents/blob/master/Projects/PhoneDialingDialogsAgent/Mathematica/AddressBookByMovieRecords.m).

 The base grammar can be extended with the ["Time specifications grammar"](https://github.com/antononcube/MathematicaForPrediction/blob/master/EBNF/TimeSpecificationsGrammar.ebnf)
 in order to include queries based on temporal commands.
 
## Running
 
 In order to experiment with the agent just run in Mathematica the command:
 
    Import["https://raw.githubusercontent.com/antononcube/ConversationalAgents/master/Projects/PhoneDialingDialogsAgent/Mathematica/PhoneDialingAgentRunScript.m"]
 
 The imported Wolfram Language file, ["./Mathematica/PhoneDialingAgentRunScript.m"](https://github.com/antononcube/ConversationalAgents/blob/master/Projects/PhoneDialingDialogsAgent/Mathematica/PhoneDialingAgentRunScript.m), 
 uses [a fake address book](https://github.com/antononcube/ConversationalAgents/blob/master/Projects/PhoneDialingDialogsAgent/Mathematica/AddressBookByMovieRecords.m) 
 based on movie creators metadata. The code structure of "./Mathematica/PhoneDialingAgentRunScript.m" allows easy
 experimentation and modification of the running steps.
 
 Here are several screen-shots illustrating a particular usage path (scan left-to-right):
 
 !["PhCA-1-call-someone-from-x-men""](http://i.imgur.com/ERavkTzm.png)
 !["PhCA-2-a-producer"](http://imgur.com/B2d2HDRm.png)
 !["PhCA-3-the-third-one](http://imgur.com/mWKNbVom.png)
  
## References

[1] Anton Antonov, ["Creating and programming domain specific languages"](https://mathematicaforprediction.wordpress.com/2016/03/22/creating-and-programming-dsls/), 
(2016), [MathematicaForPrediction at WordPress blog](https://mathematicaforprediction.wordpress.com). 

[3] Anton Antonov, [Functional parsers, Mathematica package](https://github.com/antononcube/MathematicaForPrediction/blob/master/FunctionalParsers.m), 
[MathematicaForPrediction at GitHub](ttps://github.com/antononcube/MathematicaForPrediction), 2014. 

[4] Anton Antonov, ["Natural language processing with functional parsers"](https://mathematicaforprediction.wordpress.com/2014/02/13/natural-language-processing-with-functional-parsers/), (2014), 
[MathematicaForPrediction at WordPress blog](https://mathematicaforprediction.wordpress.com). 
