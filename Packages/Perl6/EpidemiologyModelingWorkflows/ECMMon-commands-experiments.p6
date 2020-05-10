use lib './lib';
use lib '.';
use EpidemiologyModelingWorkflows;
use EpidemiologyModelingWorkflows::Grammar;

say to_ECMMon_R('
     create with SEI2HR;
     assign 100000 to total population;
     set normally infected population to be 1 and severely infected population to be 1;
     assign 0.56 to normally infected population contact rate;
     assign 0.58 to severely infected population contact rate;
     assign 0.1 to hospitalized population contact rate;
     simulate for 240 days;
     plot results;
     show deceased infected population evolution' );

say to_ECMMon_R('
     create with SEI2HR;
     assign 100000 to total population;
     set normally infected population to be 1 and severely infected population to be 1;
     assign 0.56 to normally infected contact rate;
     assign 0.58 to severely infected contact rate;
     set hospitalized contact rate to be 0.1;
     simulate for 240 days;
     plot results;
     show deceased infected population evolution' );