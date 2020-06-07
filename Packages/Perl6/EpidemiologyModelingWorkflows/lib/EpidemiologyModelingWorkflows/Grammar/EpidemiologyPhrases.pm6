use v6;

#use EpidemiologyModelingWorkflows::Grammar::FuzzyMatch;
use EpidemiologyModelingWorkflows::Grammar::CommonParts;

# Epidemiology specific phrases
role EpidemiologyModelingWorkflows::Grammar::EpidemiologyPhrases
        does EpidemiologyModelingWorkflows::Grammar::CommonParts {
    token word-spec { \w+ }

    # Proto tokens

    # Epidemiology modeling specific
    # (All unique words of stocks and rates of SEI2HREcon.)
    token analysis{ 'analysis' }
    token average { 'average' }
    token bed { 'bed' }
    token beds { 'beds' }
    token batch-noun { 'batch' }
    token bulk-noun { 'bulk' }
    token capacity { 'capacity' }
    token change { 'change' }
    token consumption { 'consumption' }
    token contact { 'contact' }
    token cost { 'cost' }
    token day { 'day' }
    token days { 'days' }
    token death { 'death' }
    token deceased { 'deceased' }
    token delay { 'delay' }
    token delivery { 'delivery' }
    token demand { 'demand' }
    token economic { 'economic' }
    token economics { 'economics' }
    token exposed { 'exposed' }
    token factor { 'factor' }
    token fraction { 'fraction' }
    token hospital { 'hospital' }
    token hospitalized { 'hospitalized' }
    token incubation { 'incubation' }
    token infected { 'infected' }
    token infectious { 'infectious' }
    token lost { 'lost' }
    token medical { 'medical' }
    token money { 'money' }
    token normally { 'normally' }
    token number { 'number' }
    token pay { 'pay' }
    token period { 'period' }
    token person { 'person' }
    token population { 'population' }
    token populations { 'populations' }
    token produced { 'produced' }
    token production { 'production' }
    token productivity { 'productivity' }
    token range { 'range' }
    token rate { 'rate' }
    token recovered { 'recovered' }
    token result { 'result' }
    token results { 'results' }
    token sensitivity { 'sensitivity' }
    token services { 'services' }
    token severely { 'severely' }
    token simulation { 'simulation' }
    token solution { 'solution' }
    token solutions { 'solutions' }
    token span { 'span' }
    token spec { 'spec' }
    token store { 'store' }
    token supplies { 'supplies' }
    token susceptible { 'susceptible' }
    token symptomatic { 'symptomatic' }
    token time { 'time' }
    token total { 'total' }
    token transport { 'transport' }
    token un-hospitalized { 'un-hospitalized' }
    token unit { 'unit' }
    token units { 'units' }

    # Rules
    rule simulation-object-phrase { <simulation> <object> }
    rule time-range-phrase { <time> [ <range> | <span> ] }
    rule simulation-results-phrase { <simulation>? <results> | <solution> | <solutions> }
}
