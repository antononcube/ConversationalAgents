# Example datasets recommender

This directory of the project 
[Data Acquirer](https://github.com/antononcube/ConversationalAgents/tree/master/Projects/DataAcquirer)
has an R/RStudio project that:

1. Imports data for previously created example dataset recommder
2. Provides an interactive interface to that recommender

The interactive interface is deployed on
[shinyapps.io](https://shinyapps.io)
-- see 
[Example datasets recommender Interface](https://antononcube.shinyapps.io/ExampleDatasetsRecommenderInterface/).

### Further details

- The Mathematica / WL datasets metadata was derived from the built-in function
  [`ExampleData`](https://reference.wolfram.com/language/ref/ExampleData.html).

- The R datasets metadata was taken from [Rdatasets](https://vincentarelbundock.github.io/Rdatasets/) .

- The recommenders were made with the packages
  [`SMRMon-R`](https://github.com/antononcube/R-packages/tree/master/SMRMon-R)
  and
  [`LSAMon-R`](https://github.com/antononcube/R-packages/tree/master/LSAMon-R),
  [AAp1, AAp2, AAp3].

- The recommender interface is a slightly modified version of the generic flexdashboard in
  [`RecommenderDashboards`](https://github.com/antononcube/R-packages/tree/master/RecommenderDashboards),
  [AAp4].

- The creation of the recommenders is in the file 
  ["Ingest recommender data.Rmd"](https://github.com/antononcube/ConversationalAgents/blob/master/Projects/DataAcquirer/R/ExampleDatasetsRecommender/notebooks/SMR-from-export-files.Rmd),
  ([HTML](https://htmlpreview.github.io/?https://github.com/antononcube/ConversationalAgents/blob/master/Projects/DataAcquirer/R/ExampleDatasetsRecommender/notebooks/SMR-from-export-files.nb.html))

------

## References

[AAp1] Anton Antonov,
[Sparse Matrix Recommender framework functions, R-package](https://github.com/antononcube/R-packages/tree/master/SparseMatrixRecommender),
(2019),
[R-packages at GitHub/antononcube](https://github.com/antononcube/R-packages).

[AAp2] Anton Antonov,
[Sparse Matrix Recommender Monad, R-package](https://github.com/antononcube/R-packages/tree/master/SMRMon-R),
(2019),
[R-packages at GitHub/antononcube](https://github.com/antononcube/R-packages).

[AAp3] Anton Antonov,
[Latent Semantic Analysis Monad, R-package](https://github.com/antononcube/R-packages/tree/master/LSAMon-R),
(2019),
[R-packages at GitHub/antononcube](https://github.com/antononcube/R-packages).

[AAp4] Anton Antonov,
[Recommender Dashboarrds, R-package](https://github.com/antononcube/R-packages/tree/master/RecommenderDashboards),
(2021),
[R-packages at GitHub/antononcube](https://github.com/antononcube/R-packages).

