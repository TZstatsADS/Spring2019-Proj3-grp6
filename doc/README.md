# Project: Can you unscramble a blurry image? 

### Doc folder

The doc directory contains the report or presentation files. It can have subfolders.  

`main.base.Rmd`: this is the main script for the baseline model. The baseline model mainly has two parts. The first baseline model contains only `depth` as parameter and `n.trees = 200`. We find out that the deeper the depth the better the model. The improved baseline model examines the effect of `shrinkage` and `depth`. We also change the `n.tree` into 1000.

`main.Rmd`: this is the main script combining baseline and the Xgboost model. Due to the time efficiency, we select `Xgboost` to run the Superresolution, but you are welcome to change the conditions to run other models.