# External parsers hook-up Python package

More or less follows the design of the [R package ExternalParsersHookUp](../../R/ExternalParsersHookUp).

This Python code:

```python
from ExternalParsersHookUp import RakuCommandFunctions
res = RakuCommandFunctions.RakuCommand( 'say ToDataQueryWorkflowCode("use dfStarwars; select mass and height; cross tabulate mass and height", "Python-pandas")', 'DSL::English::DataQueryWorkflows')
print(res.stdout)
```
should produce the ***string***:
 
```python
obj = dfStarwars
obj = obj[["mass", "height"]]
obj = pandas.crosstab( index = obj.mass, columns = obj.height )
```
Use `exec` to get the result:

```python
exec(res.stdout)
obj
```

