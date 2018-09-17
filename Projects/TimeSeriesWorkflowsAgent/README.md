# Time series workflows conversational agent

This folder has code and descriptions for the making of a conversational agent
that generates time series workflows using the monad `QRMon` coded in 
\[[AA1](https://github.com/antononcube/MathematicaForPrediction/blob/master/MonadicProgramming/MonadicQuantileRegression.m)\] 
and described in
\[[AA2]()\]
. 

The EBNF grammar file 
["TimeSeriesWorkflowsGrammar.m"](https://github.com/antononcube/ConversationalAgents/blob/master/EBNF/TimeSeriesWorkflowsGrammar.m)
is put in [repository's EBNF folder](https://github.com/antononcube/ConversationalAgents/blob/master/EBNF/).

## Cursory example

    QRMonUnit[distData]⟹
      ToQRMonPipelineFunction["show data summary"]⟹
      ToQRMonPipelineFunction["calculate quantile regression for quantiles 0.2, 0.8 and with 40 knots"]⟹
      ToQRMonPipelineFunction["plot"];

## References

\[AA1\] Anton Antonov, [Monadic Quantile Regression Mathematica package](https://github.com/antononcube/MathematicaForPrediction/blob/master/MonadicProgramming/MonadicQuantileRegression.m),
(2018), MathematicaForPrediction at GitHub.
 
\[AA2\] Anton Antonov, [A monad for Quantile Regression workflows](https://mathematicaforprediction.wordpress.com/2018/08/01/a-monad-for-quantile-regression-workflows/), 
(2018), MathematicaForPrediction at WordPress.                            