import pandas
from ExternalParsersHookUp import RakuCommandFunctions
from ExternalParsersHookUp import ParseWorkflowSpecifications

dfStarwars = pandas.read_csv(
    "https://raw.githubusercontent.com/antononcube/R-packages/master/DataQueryWorkflowsTests/inst/extdata/dfStarwars.csv")
dfStarwarsFilms = pandas.read_csv(
    "https://raw.githubusercontent.com/antononcube/R-packages/master/DataQueryWorkflowsTests/inst/extdata/dfStarwarsFilms.csv")
dfStarwarsStarships = pandas.read_csv(
    "https://raw.githubusercontent.com/antononcube/R-packages/master/DataQueryWorkflowsTests/inst/extdata/dfStarwarsStarships.csv")

# res = RakuCommandFunctions.RakuCommand( 'say ToDataQueryWorkflowCode("use dfStarwars; select mass and height; cross tabulate mass and height", "Python-pandas")', 'DSL::English::DataQueryWorkflows')
# print(res.stdout)
# exec(res.stdout)
# print(obj)
#

command1 = "use dfStarwars; filter 'species' is 'Human' or 'mass' is greater than 120; select homeworld and species; cross tabulate homeworld and species"
command2 = 'use dfStarwars; filter "species" is "Human" or "mass" is greater than 120; select homeworld and species; cross tabulate homeworld and species'

res = ParseWorkflowSpecifications.ToDataQueryWorkflowCode(
    command=command2,
    parse=True,
    globals=globals())
print(res)
print(obj)
