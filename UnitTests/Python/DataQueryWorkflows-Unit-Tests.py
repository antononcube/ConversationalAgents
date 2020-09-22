import unittest

import pandas
from pandas.testing import assert_frame_equal

from ExternalParsersHookUp import RakuCommandFunctions
from ExternalParsersHookUp import ParseWorkflowSpecifications

dfTitanic = pandas.read_csv(
    "https://raw.githubusercontent.com/antononcube/MathematicaVsR/master/Data/MathematicaVsR-Data-Titanic.csv")
dfStarwars = pandas.read_csv(
    "https://raw.githubusercontent.com/antononcube/R-packages/master/DataQueryWorkflowsTests/inst/extdata/dfStarwars.csv")
dfStarwarsFilms = pandas.read_csv(
    "https://raw.githubusercontent.com/antononcube/R-packages/master/DataQueryWorkflowsTests/inst/extdata/dfStarwarsFilms.csv")
dfStarwarsStarships = pandas.read_csv(
    "https://raw.githubusercontent.com/antononcube/R-packages/master/DataQueryWorkflowsTests/inst/extdata/dfStarwarsStarships.csv")
dfStarwarsVehicles = pandas.read_csv(
    "https://raw.githubusercontent.com/antononcube/R-packages/master/DataQueryWorkflowsTests/inst/extdata/dfStarwarsVehicles.csv")


class MyTestCase(unittest.TestCase):

    def test_select_1(self):
        res = ParseWorkflowSpecifications.ToDataQueryWorkflowCode(
            command="use dfStarwars; select species, homeworld, mass and height;",
            execute=True,
            globals=globals())
        obj2 = dfStarwars.copy()
        obj2 = obj2[["species", "homeworld", "mass", "height"]]
        assert_frame_equal(obj, obj2)

    def test_select_2(self):
        res = ParseWorkflowSpecifications.ToDataQueryWorkflowCode(
            command='use dfStarwars; select "species", "homeworld", mass, "height";',
            execute=True,
            globals=globals())
        obj2 = dfStarwars.copy()
        obj2 = obj2[["species", "homeworld", "mass", "height"]]
        assert_frame_equal(obj, obj2)

    def test_select_3(self):
        res = ParseWorkflowSpecifications.ToDataQueryWorkflowCode(
            command='use dfStarwars; select species, mass as var1, var2',
            execute=True,
            globals=globals())
        obj2 = dfStarwars.copy()
        obj2.rename(columns={"species": "var1", "mass": "var2"}, inplace=True)
        obj2 = obj2[["var1", "var2"]]
        assert_frame_equal(obj, obj2)

    def test_select_4(self):
        res = ParseWorkflowSpecifications.ToDataQueryWorkflowCode(
            command='use dfStarwars; select species as var1, mass as var2, height as var3',
            execute=True,
            globals=globals())
        obj2 = dfStarwars.copy()
        obj2.rename(columns={"species": "var1", "mass": "var2", "height": "var3"}, inplace=True)
        obj2 = obj2[["var1", "var2", "var3"]]
        assert_frame_equal(obj, obj2)


if __name__ == '__main__':
    unittest.main()
