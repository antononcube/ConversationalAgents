use lib './lib';
use lib '.';
use DataQueryWorkflows;

#say DataQueryWorkflows::Grammar.parse("select mass & height");

#say to_dplyr("filter by mass > 10 & height <200");

say "=" x 10;

say to_dplyr('select mass & height');

say "=" x 10;

say to_dplyr('arrange by the variable mass & height desc');

say "=" x 10;

say to_dplyr('
use data frame starwars;
select mass & height;
mutate bmi = mass/height^2;
summarize data;
glimpse data;
arrange by the variable mass & height descending');
