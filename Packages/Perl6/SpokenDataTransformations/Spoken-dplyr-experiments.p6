
use lib './lib';
#use lib '.';
use SpokenDataTransformations;

#say DataTransformationWorkflowGrammar::Spoken-dplyr-command.parse("select mass & height", actions => Spoken-dplyr-actions::Spoken-dplyr-actions ).made;

say to-dplyr("select mass & height");

say to-dplyr("arrange by the variable mass & height desc");

say to-dplyr("select mass & height; arrange by the variable mass & height descending");
