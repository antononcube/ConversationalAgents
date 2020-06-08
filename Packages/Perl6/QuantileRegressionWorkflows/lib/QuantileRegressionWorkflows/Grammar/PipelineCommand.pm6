use v6;

# This role class has pipeline commands.
role QuantileRegressionWorkflows::Grammar::PipelineCommand {

  rule pipeline-command { <take-pipeline-value> | <echo-pipeline-value> | <echo-command> }
  rule take-pipeline-value { <get-verb> <pipeline-value> }
  rule echo-pipeline-value { <display-directive> <pipeline-value> }
  rule pipeline-value { <.pipeline-filler-phrase>? 'value'}
  rule pipeline-filler-phrase { <.the-determiner>? [ 'current' ]? 'pipeline' }

  rule echo-command { <display-directive> <echo-message-spec> }
  rule echo-message-spec { <echo-text> | <echo-words-list> | <echo-variable> }
  rule echo-words-list { [ 'text' | 'message' | 'the' 'words' ] <variable-name>+ % ( <list-separator> | \h+ )  }
  rule echo-variable { 'variable' <variable-name> }
  token echo-text { [\" ([ \w | '_' | '-' | '.' | \d ]+ | [\h]+)+ \"]  }
}