use v6;

# This grammar role does rely on the role CommonParts --
# it is expected to be included in the "large" LSAMon or SMRMon grammars.
# The primary motivation is to reuse.

#use LatentSemanticAnalysisWorkflows::Grammar::CommonParts;

# LSI functions application commands.
role LatentSemanticAnalysisWorkflows::Grammar::LSIApplyCommand {
    # does LatentSemanticAnalysisWorkflows::Grammar::CommonParts {
    regex lsi-apply-command { <.lsi-apply-phrase> [ <lsi-funcs-list> | <lsi-funcs-simple-list> ] }

    rule lsi-funcs-simple-list { <lsi-global-func> <lsi-local-func> <lsi-normalizer-func> }

    rule lsi-apply-verb { <apply-verb> 'to'? | <transform-verb> | <use-verb> }
    rule lsi-apply-phrase { <lsi-apply-verb> <the-determiner>? [ <matrix> | <matrix-entries> ]? <the-determiner>? <lsi-phrase>? <functions>? }

    rule lsi-funcs-list { <lsi-func>+ % <list-separator> }

    rule lsi-func { <lsi-global-func> | <lsi-local-func> | <lsi-normalizer-func> }

    rule lsi-func-none { 'None' | 'none' }

    rule lsi-global-func { <.global-function-phrase>? [ <lsi-global-func-idf> | <lsi-global-func-entropy> | <lsi-global-func-sum> | <lsi-func-none> ] }
    rule lsi-global-func-idf { 'IDF' | 'idf' | 'inverse' 'document' <frequency> }
    rule lsi-global-func-entropy { 'Entropy' | 'entropy' }
    rule lsi-global-func-sum {  'sum' | 'Sum' }

    rule lsi-local-func { <.local-function-phrase>? [ <lsi-local-func-frequency> | <lsi-local-func-binary> | <lsi-local-func-log> | <lsi-func-none> ] }
    rule lsi-local-func-frequency {  <term>? <frequency> }
    rule lsi-local-func-binary { 'binary' <frequency>? | 'Binary' }
    rule lsi-local-func-log { 'log' | 'logarithmic' | 'Log' }

    rule lsi-normalizer-func { <.normalizer-function-phrase>? [ <lsi-normalizer-func-sum> | <lsi-normalizer-func-max> | <lsi-normalizer-func-cosine> | <lsi-func-none> ] <.normalization>? }
    rule lsi-normalizer-func-sum {'sum' | 'Sum' }
    rule lsi-normalizer-func-max {'max' | 'maximum' | 'Max' }
    rule lsi-normalizer-func-cosine {'cosine' | 'Cosine' }
}