# Classification workflows conversational agent

This folder has code and descriptions for the making of a conversational agent
that generates classification workflows using the monad `ClCon` coded in 
\[[AAp1](https://github.com/antononcube/MathematicaForPrediction/blob/master/MonadicProgramming/MonadicContextualClassification.m)\] 
and described in 
\[[AA1](https://github.com/antononcube/MathematicaForPrediction/blob/master/MarkdownDocuments/A-monad-for-classification-workflows.md)\].

The EBNF grammar file 
["ClassifierWorkflowsGrammar.m"](https://github.com/antononcube/ConversationalAgents/blob/master/EBNF/ClassifierWorkflowsGrammar.m)
is put in [repository's EBNF folder](https://github.com/antononcube/ConversationalAgents/blob/master/EBNF/).


## Cursory example

This code produces a `ClCon` pipeline for a sequence of natural commands:

    clCommands = {
      "load the data for Titanic", 
      "split data with 70 percent for training", 
      "show data summary", 
      "create a logistic regression classifier", 
      "show classifier classes", 
      "show accuracy and precision and recall", 
      "create a classifier ensemble of 2 nearest neighbors classifiers", 
      "show classifier training time", 
      "show precision and recall", 
      "show roc plot of FPR and TPR", 
      "show list line roc plot for FPR, TPR, ACC, SPC and PPV", 
      "compute the column shuffling accuracies"};
    pl = ToClConPipelineFunction[clCommands]
    
    (*  
    Function[{x, c}, 
     ClConUnit[x, c]⟹
     ClConSplitData[0.7]⟹ClConEchoFunctionValue["summaries:", (Multicolumn[#1, 5] &) /@ RecordsSummary /@ #1 &]⟹
     ClConMakeClassifier["LogisticRegression"]⟹
     ClConEchoFunctionContext["classifier property \"Classes\" :", 
       If[AssociationQ[#1["classifier"]], 
         (ClassifierInformation[#1, "Classes"] &) /@ #1["classifier"], 
         ClassifierInformation[#1["classifier"], "Classes"]] &]⟹
     Function[{x$, c$}, 
       ClConUnit[x$, c$]⟹
       ClConClassifierMeasurements[{"Accuracy", "Precision", "Recall"}]⟹
       ClConEchoValue]⟹
     ClConMakeClassifier[{<|"method" -> "NearestNeighbors", 
         "sampleFraction" -> 0.9, 
         "numberOfClassifiers" -> 2, 
         "samplingFunction" -> 
          RandomSample|>}]⟹
     ClConEchoFunctionContext["classifier property \"TrainingTime\" :", 
       If[AssociationQ[#1["classifier"]], 
         (ClassifierInformation[#1, "TrainingTime"] &) /@ #1["classifier"], 
         ClassifierInformation[#1["classifier"], "TrainingTime"]] &]⟹
     Function[{x$, c$}, 
       ClConUnit[x$, c$]⟹
       ClConClassifierMeasurements[{"Precision", "Recall"}]⟹
       ClConEchoValue]⟹
     ClConROCPlot["FPR", "TPR"]⟹ClConROCListLinePlot[{"FPR", "TPR", "ACC", "SPC", "PPV"}]⟹
     Function[{x, c}, 
       ClConUnit[x, c]⟹
       ClConAccuracyByVariableShuffling[]⟹
       ClConEchoValue]
    ]
    *)

For details of getting the required code and data see the document 
["ClassificationWorkflowsAgent-example-runs.pdf"](https://github.com/antononcube/ConversationalAgents/blob/master/Projects/ClassficationWorkflowsAgent/Documents/ClassificationWorkflowsAgent-example-runs.pdf).

## References

\[AAp1\] Anton Antonov, [Monadic contextual classification Mathematica package](https://github.com/antononcube/MathematicaForPrediction/blob/master/MonadicProgramming/MonadicContextualClassification.m),
(2018), [MathematicaForPrediction at GitHub](https://github.com/antononcube/MathematicaForPrediction/).    

\[AA1\] Anton Antonov, ["A monad for classification workflows"](https://github.com/antononcube/MathematicaForPrediction/blob/master/MarkdownDocuments/A-monad-for-classification-workflows.md),
(2018), [MathematicaForPrediction at GitHub](https://github.com/antononcube/MathematicaForPrediction/).    