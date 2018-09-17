# Recommendation system workflows conversational agent

This folder has code and descriptions for the making of a conversational agent
that generates recommendation system workflows using the monad `SMRMon` coded in 
\[[AA1](https://github.com/antononcube/MathematicaForPrediction/blob/master/MonadicProgramming/MonadicSparseMatrixRecommender.m)\] 
and described in
\[[AA2]()\]
. 

The EBNF grammar file 
["RecommenderWorkflowsGrammar.m"](https://github.com/antononcube/ConversationalAgents/blob/master/EBNF/RecommenderWorkflowsGrammar.m)
is put in [repository's EBNF folder](https://github.com/antononcube/ConversationalAgents/blob/master/EBNF/).

## Cursory example

    SMRMonUnit[<|"data"->ds, "itemColumnName"->"id"|>]⟹
      ToSMRMonPipelineFunction["create recommender"]⟹
      ToSMRMonPipelineFunction["recommend by history id1:3, id7:4, and id30:5"]⟹
      ToSMRMonPipelineFunction["echo pipeline value"];

## References

\[AA1\] Anton Antonov, [Monadic Sparse Matrix Recommender Mathematica package](https://github.com/antononcube/MathematicaForPrediction/blob/master/MonadicProgramming/MonadicSparseMatrixRecommender.m),
(2018), MathematicaForPrediction at GitHub.
 
\[AA2\] Anton Antonov, [A monad for recommender system workflows](), 
(2018), MathematicaForPrediction at GitHub.                            