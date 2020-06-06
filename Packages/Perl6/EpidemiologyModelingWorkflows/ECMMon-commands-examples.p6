use lib './lib';
#use lib '.';
use EpidemiologyModelingWorkflows;
use EpidemiologyModelingWorkflows::Grammar;
use EpidemiologyModelingWorkflows::Actions::ECMMon-R;


#use MLWorflows::Recommender::Actions::ECMMon-R;
#use MLWorflows::QuantileRegression::Actions::ECMMon-R;

my $pECMMONCOMMAND = EpidemiologyModelingWorkflows::Grammar::WorkflowCommand;

#say $pECMMONCOMMAND.parse('assign 0.56 to contact rate issp');

say $pECMMONCOMMAND.parse('assign 0.56 to the contact rate for infected severely symptomatic population');

#say $pECMMONCOMMAND.parse('assign 10 to the infected severely symptomatic population');


# say $pECMMONCOMMAND.parse('create with SEI2HR');

# say $pECMMONCOMMAND.parse('simulate over time range 365');

# say $pECMMONCOMMAND.parse('simulate over 365 days');

# say $pECMMONCOMMAND.subparse('simulate over the time range minimum 0 max 200 step 12');

# say $pECMMONCOMMAND.parse('simulate over the time range min 0, time range max 200, and step 12');

# say $pECMMONCOMMAND.parse('show pipeline value');

