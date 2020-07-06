use lib './lib';
use lib '.';
use DataQueryWorkflows;

#say DataQueryWorkflows::Grammar.parse("select mass & height");

#say to_dplyr("filter by mass > 10 & height <200");

#say "=" x 10;
#
#say to_DataQuery_dplyr('select mass & height');
#
#say "=" x 10;
#
#say to_DataQuery_dplyr('use the data frame df;
#select mass and height;
#arrange by the variable mass & height desc');
#
#say "=" x 10;
#
#say to_DataQuery_pandas('use the data frame df;
#select mass and height;
#arrange by the variable mass & height desc');

say "=" x 10;

my $commands = '
use dfTitanic;
filter by passengerSex == "male";
group by passengerClass, passengerSurvival;
count;
ungroup;
';

my $commands2 = "use starwars;
inner join with starwars_films by 'name';
sort by name, film desc;
echo data summary";

my $commands3 = 'use iris;
sort by PetalWidth, SepalLength;
echo data summary;
group by Species;
echo data summary
';

my $commands4 = '
use dfTitanic;
filter with passengerSex is "male" and paseengerSurvival equals "died" or passengerSurvival is "survived" ;
filter by passengerClass is like "1.";
cross tabulate passengerClass, passengerSurvival;
';

say ToDataQueryCode( $commands4, 'Julia' );

#say ToDataQueryCode( command => $commands, target => "R-base" );


#say "=" x 10;
#
#say to_dplyr('
#use data frame starwars;
#cross tabulate homeworld with gender over mass;
#sort by Freq descending');