# Phone Dialing Dialogs Conversational Agent

## Introduction

This repository directory has designs and implementations of a phone calling conversational agent that aims at
providing the following functionalities: 
- contacts retrieval (querying, filtering, selection), 
- contacts prioritization, and 
- phone call (work flow) handling.

The design is based on a [Finite State Machine (FSM)](https://en.wikipedia.org/wiki/Finite-state_machine)
and [context free grammar(s)](https://en.wikipedia.org/wiki/Context-free_grammar) for commands that switch between the states of the FSM. 
The grammar is designed as a context free grammar rules of a Domain Specific Language (DSL) in 
[Extended Backus-Naur Form](https://en.wikipedia.org/wiki/Extended_Backus–Naur_form) (EBNF). (For more details on DSLs design and programming see 
\[[1](https://mathematicaforprediction.wordpress.com/2016/03/22/creating-and-programming-dsls/)\].)

The (current) implementation is with Wolfram Language (WL) / Mathematica using the functional parsers package 
\[[2](https://github.com/antononcube/MathematicaForPrediction/blob/master/FunctionalParsers.m),
[3](https://mathematicaforprediction.wordpress.com/2014/02/13/natural-language-processing-with-functional-parsers/)\].

This [movie](https://youtu.be/1sQgD9Kn0TQ) gives an overview from an end user perspective.

## General design

The design of the Phone Conversational Agent (PhCA) is derived in a straightforward manner from 
the typical work flow of calling a contact (using, say, a mobile phone.)

The main goals for the conversational agent are the following:

1. contacts retrieval -- search, filtering, selection -- using both natural language commands and manual interaction,
2. intuitive integration with the usual work flow of phone calling.

An additional goal is to facilitate contacts retrieval by determining the most appropriate contacts in query responses. 
For example, while driving to work by pressing the dial button we might prefer the contacts of an up-coming meeting 
to be placed on top of the prompting contacts list.

In this project we assume that the voice to text conversion is done with an external (reliable) component.

It is assumed that an user of PhCA can react to both visual and spoken query results. 

The main algorithm is the following.

**1)** Parse and interpret a natural language command.

**2)** If the command is a contacts query that returns a single contact then call that contact.

**3)** If the command is a contacts query that returns multiple contacts then :

**3.1)** use natural language commands to refine and filter the query results,

**3.2)** until a single contact is obtained. Call that single contact.

**4)** If other type of command is given act accordingly.

PhCA has commands for system usage help and for canceling the current contact search and starting over.

The following FSM diagram gives the basic structure of PhCA:

[!["Phone-conversational-agent-FSM-and-DB"](http://imgur.com/v7vCkRrl.jpg)](http://imgur.com/v7vCkRr.jpg)


This [movie](https://youtu.be/1sQgD9Kn0TQ) demonstrates how different natural language commands switch the 
FSM states.

## Grammar design
 
 The derived grammar describes sentences that:
 1. fit end user expectations, and
 2. are used to switch between the FSM states.
 
 Because of the simplicity of FSM and the natural language commands only few iterations were done with the 
 [Parser-generation-by-grammars work flow](https://github.com/antononcube/ConversationalAgents/blob/master/ConceptualDiagrams/Parser-generation-by-grammars-workflow.pdf). 
 
 The base grammar is given in the file ["./Mathematica/PhoneCallingDialogsGrammarRules.m"](https://github.com/antononcube/ConversationalAgents/blob/master/Projects/PhoneDialingDialogsAgent/Mathematica/PhoneCallingDialogsGrammarRules.m)
 in EBNF used by \[[2](https://github.com/antononcube/MathematicaForPrediction/blob/master/FunctionalParsers.m)\].
 
 Here are parsing results of a set of test natural language commands:
 
 [!["PhCA-base-grammar-test-queries-125"](http://imgur.com/xTcBbbQl.png)](http://imgur.com/xTcBbbQ.png)

 using the WL command:
 
    ParsingTestTable[ParseJust[pCALLCONTACT\[CirclePlus]pCALLFILTER], ToLowerCase /@ queries]
     
 (Note that according to [PhCA's FSM diagram](http://imgur.com/v7vCkRr.jpg) the parsing of `pCALLCONTACT` 
 is separated from `pCALLFILTER`, hence the need to combine the two parsers in the code line above.)
     
 PhCA's FSM implementation provides interpretation and context of the functional programming expressions
 obtained by the parser.
      
 In the running script ["./Mathematica/PhoneDialingAgentRunScript.m"](https://github.com/antononcube/ConversationalAgents/blob/master/Projects/PhoneDialingDialogsAgent/Mathematica/PhoneDialingAgentRunScript.m) 
 the grammar parsers are modified to do successful parsing using data elements of 
 the provided [fake address book](https://github.com/antononcube/ConversationalAgents/blob/master/Projects/PhoneDialingDialogsAgent/Mathematica/AddressBookByMovieRecords.m).

 The base grammar can be extended with the ["Time specifications grammar"](https://github.com/antononcube/MathematicaForPrediction/blob/master/EBNF/TimeSpecificationsGrammar.ebnf)
 in order to include queries based on temporal commands.
 
## Running
 
 In order to experiment with the agent [just run](https://youtu.be/1sQgD9Kn0TQ) in Mathematica the command:
 
    Import["https://raw.githubusercontent.com/antononcube/ConversationalAgents/master/Projects/PhoneDialingDialogsAgent/Mathematica/PhoneDialingAgentRunScript.m"]
 
 The imported Wolfram Language file, ["./Mathematica/PhoneDialingAgentRunScript.m"](https://github.com/antononcube/ConversationalAgents/blob/master/Projects/PhoneDialingDialogsAgent/Mathematica/PhoneDialingAgentRunScript.m), 
 uses [a fake address book](https://github.com/antononcube/ConversationalAgents/blob/master/Projects/PhoneDialingDialogsAgent/Mathematica/AddressBookByMovieRecords.m) 
 based on movie creators metadata. The code structure of "./Mathematica/PhoneDialingAgentRunScript.m" allows easy
 experimentation and modification of the running steps.
 
 Here are several screen-shots illustrating a particular usage path (scan left-to-right):
 
 !["PhCA-1-call-someone-from-x-men""](http://i.imgur.com/ERavkTzm.png)
 !["PhCA-2-a-producer"](http://imgur.com/B2d2HDRm.png)
 !["PhCA-3-the-third-one](http://imgur.com/mWKNbVom.png)
 
 See this [movie](https://youtu.be/1sQgD9Kn0TQ) demonstrating a PhCA run.
  
## References

[1] Anton Antonov, ["Creating and programming domain specific languages"](https://mathematicaforprediction.wordpress.com/2016/03/22/creating-and-programming-dsls/), 
(2016), [MathematicaForPrediction at WordPress blog](https://mathematicaforprediction.wordpress.com). 

[2] Anton Antonov, [Functional parsers, Mathematica package](https://github.com/antononcube/MathematicaForPrediction/blob/master/FunctionalParsers.m), 
[MathematicaForPrediction at GitHub](https://github.com/antononcube/MathematicaForPrediction), 2014. 

[3] Anton Antonov, ["Natural language processing with functional parsers"](https://mathematicaforprediction.wordpress.com/2014/02/13/natural-language-processing-with-functional-parsers/), (2014), 
[MathematicaForPrediction at WordPress blog](https://mathematicaforprediction.wordpress.com). 
