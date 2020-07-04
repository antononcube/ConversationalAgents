use lib './lib';
use lib '.';
use DataQueryWorkflows;

#say DataQueryWorkflows::Grammar.parse("select mass & height");

#say to_dplyr("filter by mass > 10 & height <200");

say "=" x 10;

say to_dplyr('select mass & height');

say "=" x 10;

say to_dplyr('use the data frame df;
select mass and height;
arrange by the variable mass & height desc');

say "=" x 10;

say to_pandas('use the data frame df;
select mass and height;
arrange by the variable mass & height desc');

say "=" x 10;

my $commands = '
use data frame starwars;
select mass & height;
mutate bmi = mass/height^2;
filter by bmi > 30;
summarize data;
glimpse data;
inner join startrek by "bmi" = "BMI";
arrange by the variable mass & height descending';

say ToDataQueryCode( $commands, 'dplyr' );

#say "=" x 10;
#
#say to_dplyr('
#use data frame starwars;
#cross tabulate homeworld with gender over mass;
#sort by Freq descending');