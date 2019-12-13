use v6;

unit module RecommenderWorkflows::Grammar::PipelineCommand;

# This role class has pipeline commands.
role RecommenderWorkflows::Grammar::PipelineCommand {

  rule pipeline-command { <get-pipeline-value> }
  rule get-pipeline-value { <display-directive> <pipeline-value> }
  rule pipeline-value { <.pipeline-filler-phrase>? 'value'}
  rule pipeline-filler-phrase { <the-determiner>? [ 'current' ]? 'pipeline' }

}