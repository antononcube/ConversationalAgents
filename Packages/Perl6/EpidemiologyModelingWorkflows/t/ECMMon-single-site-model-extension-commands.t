use v6;
use lib 'lib';
use EpidemiologyModelingWorkflows::Grammar;
use Test;

plan 13;

# Shortcut
my $pECMMONCOMMAND = EpidemiologyModelingWorkflows::Grammar::WorkflowCommand;

#-----------------------------------------------------------
# Extension commands
#-----------------------------------------------------------

ok $pECMMONCOMMAND.parse('extend by matrix mat1'),
        'extend by matrix mat1';

ok $pECMMONCOMMAND.parse('extend by adjacency matrix mat1'),
        'extend by adjacency matrix mat1';

ok $pECMMONCOMMAND.parse('extend by adjacent matrix mat1'),
        'extend by adjacent matrix mat1';

ok $pECMMONCOMMAND.parse('extend the single site model by matrix mat1'),
        'extend the single site model by matrix mat1';

ok $pECMMONCOMMAND.parse('extend by adjacent matrix mat1 with migrating stocks SPt, EPt, and RPt'),
        'extend by adjacent matrix mat1 with migrating stocks SPt, EPt, and RPt';

ok $pECMMONCOMMAND.parse('extend by adjacent matrix mat1 using the migration stocks susceptible population, exposed population, and recovered population'),
        'extend by adjacent matrix mat1 using the migration stocks susceptible population, exposed population, and recovered population';

ok $pECMMONCOMMAND.parse('extend with the data frame dfTrav1'),
        'extend with the data frame dfTrav1';

ok $pECMMONCOMMAND.parse('extend the single site model with the data frame dfTrav1'),
        'extend the single site model with the data frame dfTrav1';

ok $pECMMONCOMMAND.parse('extend single site model by data frame dfTrav1'),
        'extend single site model by data frame dfTrav1';

ok $pECMMONCOMMAND.parse('spread out the single site model by the dataset dfTrav1'),
        'spread out the single site model by the dataset dfTrav1';

ok $pECMMONCOMMAND.parse('spread out with traveling patterns of Botswana'),
        'spread out with traveling patterns of Botswana';

ok $pECMMONCOMMAND.parse('spread out the single site model with the traveling patterns of Botswana'),
        'spread out the single site model with the traveling patterns of Botswana';

ok $pECMMONCOMMAND.parse('spread out the single site model with the traveling patterns of the country Spain'),
        'spread out the single site model with the traveling patterns of the country Spain';

done-testing;
