use lib './lib';
#use lib '.';
use EpidemiologyModelingWorkflows;
use EpidemiologyModelingWorkflows::Grammar;
use EpidemiologyModelingWorkflows::Actions::ECMMon-R;


#use MLWorflows::Recommender::Actions::ECMMon-R;
#use MLWorflows::QuantileRegression::Actions::ECMMon-R;

my $pECMMONCOMMAND = EpidemiologyModelingWorkflows::Grammar::WorkflowCommand;

#say $pECMMONCOMMAND.parse('batch simulate using max time 240 over dfParameters' );

#say $pECMMONCOMMAND.parse('batch simulate with aip = seq(20, 40, 10), aincp = seq(6, 18, 6), lpcr = 0 using max time 365');

#say $pECMMONCOMMAND.parse('batch simulate with aincp in c(6, 18, 6) using max time 240');

#say $pECMMONCOMMAND.parse('batch simulate with aincp in c(6, 18, 6) for 300 days');

#say $pECMMONCOMMAND.parse('batch simulate with TPt in min 10^4 max 10^5 step 500, lpcr = 0 for max time 365');

say $pECMMONCOMMAND.parse('batch simulate with TPt in from 100000 to 1000000 step 100000, lpcr = 0 for max time 365');

#say $pECMMONCOMMAND.parse('batch simulate with aip in c(10, 40, 60) for max time 365');

#say $pECMMONCOMMAND.subparse('batch simulate with aincp = 12 and lpcr = 0 using max time 365');

#say $pECMMONCOMMAND.parse('assign 0.56 to contact rate issp');

#say $pECMMONCOMMAND.parse('assign 0.56 to the contact rate for infected severely symptomatic population');

#say $pECMMONCOMMAND.parse('assign 10 to the infected severely symptomatic population');


# say $pECMMONCOMMAND.parse('create with SEI2HR');

# say $pECMMONCOMMAND.parse('simulate over time range 365');

# say $pECMMONCOMMAND.parse('simulate over 365 days');

# say $pECMMONCOMMAND.subparse('simulate over the time range minimum 0 max 200 step 12');

# say $pECMMONCOMMAND.parse('simulate over the time range min 0, time range max 200, and step 12');

# say $pECMMONCOMMAND.parse('show pipeline value');

