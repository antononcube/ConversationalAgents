use lib './lib';
use lib '.';
use EpidemiologyModelingWorkflows;
use EpidemiologyModelingWorkflows::Grammar;

say to_ECMMon_R('
create object with model SEI2HR;
batch simulate over lpcr = 0 and aincp = c(12, 16, 21) for 365 days;
plot population results;
plot solution histograms' );


#say to_ECMMon_R('
#create object with model SEI2HR;
#simulate for 365 days;
#plot population results;
#plot solution histograms' );

#
#say to_ECMMon_R('
#     create with SEI2HR;
#     assign 100000 to total population;
#     set infected normally symptomatic population to be 1 and infected severely symptomatic population to be 1;
#     assign 0.56 to infected normally symptomatic population contact rate;
#     assign 0.58 to infected severely symptomatic population contact rate;
#     assign 0.1 to hospitalized population contact rate;
#     simulate for 240 days;
#     plot results;
#     show deceased infected population evolution' );
#
#say to_ECMMon_R('
#     create with SEI2HR;
#     assign 100000 to total population;
#     set infected normally symptomatic population to be 1 and severely symptomatic population to be 1;
#     assign 0.56 to normally symptomatic contact rate;
#     assign 0.58 to severely symptomatic contact rate;
#     set hospitalized contact rate to be 0.1;
#     simulate for one year;
#     plot results;
#     show deceased infected population evolution' );