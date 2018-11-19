
use lib './lib';
#use lib '.';
use SpokenDataTransformations;

#say DataTransformationWorkflowGrammar::Spoken-dplyr-command.parse("select mass & height", actions => Spoken-dplyr-actions::Spoken-dplyr-actions ).made;

say to_dplyr("select mass & height");

say to_dplyr("arrange by the variable mass & height desc");

say to_dplyr("select mass & height; mutate mass1 = mass; arrange by the variable mass & height descending");
