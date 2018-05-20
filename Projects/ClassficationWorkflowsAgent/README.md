# Classification workflows conversational agent

This folder has code and descriptions for the making of a conversational agent
that generates classification workflows using the monad `ClCon` coded in 
\[[AAp1](https://github.com/antononcube/MathematicaForPrediction/blob/master/MonadicProgramming/MonadicContextualClassification.m)\] 
and described in 
\[[AA1](https://github.com/antononcube/MathematicaForPrediction/blob/master/MarkdownDocuments/A-monad-for-classification-workflows.md)\].

The EBNF grammar file 
["ClassifierWorkflowsGrammar.ebnf"](https://github.com/antononcube/ConversationalAgents/blob/master/EBNF/ClassifierWorkflowsGrammar.ebnf)
is put in [repository's EBNF folder](https://github.com/antononcube/ConversationalAgents/blob/master/EBNF/).


## Cursory example

This code produces a `ClCon` pipeline for a sequence of natural commands:

    clCommands = {
      "load the titanic data",
      "split the data with 65 percent for training", "summarize data", 
      "train a random forest classifier",
      "show classifier information",
      "display classifier training time", 
      "show accuracy, precision, recall, and area under roc curve", 
      "display confusion matrix plot",
      "compute the variable importance estimates"};
    pl = ToClConPipelineFunction[clCommands]
    
    (*  
    Function[{x, c}, 
      (((((((ClConUnit[x, c]⟹
               ClConSplitData[0.65])⟹
               ClConEchoFunctionValue["summaries:", (Multicolumn[#1, 5] &) /@ RecordsSummary /@ #1 &])⟹
               ClConMakeClassifier["RandomForest"])⟹
               ClConEchoFunctionContext["classifier info:", 
                 If[AssociationQ[#1["classifier"]], 
                   ClassifierInformation /@ #1["classifier"], 
                   ClassifierInformation[#1["classifier"]]] &])⟹
               ClConEchoFunctionContext["classifier property \"TrainingTime\" :", 
                 If[AssociationQ[#1["classifier"]], 
                   (ClassifierInformation[#1, "TrainingTime"] &) /@ #1["classifier"], 
                   ClassifierInformation[#1["classifier"], "TrainingTime"]] &])⟹
               Function[{x$, c$}, 
                  ClConUnit[x$, c$]⟹
                  ClConClassifierMeasurements[{"Accuracy", "Precision", "Recall", "AreaUnderROCCurve"}]⟹ClConEchoValue])⟹
               Function[{x$, c$}, 
                  ClConUnit[x$, c$]⟹
                  ClConClassifierMeasurements[{"ConfusionMatrixPlot"}]⟹ClConEchoValue])⟹
               Function[{x, c}, 
                  ClConUnit[x, c]⟹
                  ClConAccuracyByVariableShuffling[]⟹ClConEchoValue]] 
     *)

For details of getting the required code and data see the document 
["ClassificationWorkflowsAgent-example-runs.pdf"](https://github.com/antononcube/ConversationalAgents/blob/master/Projects/ClassficationWorkflowsAgent/Documents/ClassificationWorkflowsAgent-example-runs.pdf).

## References

\[AAp1\] Anton Antonov, [Monadic contextual classification Mathematica package](https://github.com/antononcube/MathematicaForPrediction/blob/master/MonadicProgramming/MonadicContextualClassification.m),
(2018), [MathematicaForPrediction at GitHub](https://github.com/antononcube/MathematicaForPrediction/).    

\[AA1\] Anton Antonov, ["A monad for classification workflows"](https://github.com/antononcube/MathematicaForPrediction/blob/master/MarkdownDocuments/A-monad-for-classification-workflows.md),
(2018), [MathematicaForPrediction at GitHub](https://github.com/antononcube/MathematicaForPrediction/).    