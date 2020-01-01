use v6;


# This role class has pipeline commands.
role NeuralNetworkWorkflows::Grammar::PipelineCommand {

  rule pipeline-command { <get-pipeline-value> | <generate-pipeline> }
  rule get-pipeline-value { <display-directive> <pipeline-value> }
  rule pipeline-value { <.pipeline-filler-phrase>? 'value'}
  rule pipeline-filler-phrase { <the-determiner>? [ 'current' ]? 'pipeline' }

  rule generate-pipeline {<generate-pipeline-phrase> [ <using-preposition> <topics-spec> ]?}
  rule generate-pipeline-phrase {<generate-directive> [ [ 'an' | 'a' | 'the' ] ]? [ 'standard' ]? <lsa-phrase> 'pipeline'}
  rule lsa-general-phrase {<lsa-phrase-word> [ [ <lsa-phrase-word> ]+ ]?}
  rule lsa-phrase-word {[ 'text' | 'latent' | 'semantic' | 'analysis' ]}

}
