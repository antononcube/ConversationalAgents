use v6;

# This role class has pipeline commands.
role QuantileRegressionWorkflows::Grammar::PipelineCommand {

  rule pipeline-command { <take-pipeline-value> | <echo-pipeline-value> }
  rule take-pipeline-value { <get-verb> <pipeline-value> }
  rule echo-pipeline-value { <display-directive> <pipeline-value> }
  rule pipeline-value { <.pipeline-filler-phrase>? 'value'}
  rule pipeline-filler-phrase { <.the-determiner>? [ 'current' ]? 'pipeline' }

}