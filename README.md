# Project: Can you unscramble a blurry image? 
![image](figs/example_0.png)

### [Full Project Description](doc/project3_desc.md)

Term: Spring 2019

+ Team **Group 6**
+ Team members
	+
	+ team member 2
	+ team member 3
	+ team member 4
	+ team member 5

+ Project summary: 

In this project, we created a classification engine for enhance the resolution of images. We used GBM model to conduct the Feature Extraction and to complete the Baseline Model. After tuning model parameter, the baseline model can reach accuracy at 99% level. In order to facilitate the computational efficiency, we develop an enhanced model by using XGboost method. This method greatly reduces the training and testing time and it reaches at 95% accuracy level. To further improve the image, we use `superResolution` technique to enlarge the image. As a result, images conducted by our model become smoothier comparing to those are enlarged directly. 

- Baseline_0 (with `depth` = 3, 5, 7, 9, 11 and `n.trees=200`)

- Baseline_improved(with `depth` = 9,11, `shrinkage` = 0.1, 0.01, and 0.001,`n.trees=1000`)

- XGboost (with `depth`=6,7,8 and `eta`=0.5,0.6,0.7,0.8 and 0.9)

Our team also explore other methods in order to improve the training process. SVM and Random Forest are tested on small samples, and we are still looking for solutions on applying these two methods on large training data set.




	
**Contribution statement**: ([default](doc/a_note_on_contributions.md)) All team members contributed equally in all stages of this project. All team members approve our work presented in this GitHub repository including this contributions statement. 

- Jingwen Wang(jw3667): Worked on Baseline and Baseline_improved model.Wrote the `superResolution` function. Collabrated with Ziyi Liao, completed the `main.Rmd`. Helped with writing `ReadMe` files.

Following [suggestions](http://nicercode.github.io/blog/2013-04-05-projects/) by [RICH FITZJOHN](http://nicercode.github.io/about/#Team) (@richfitz). This folder is orgarnized as follows.

```
proj/
├── lib/
├── data/
├── doc/
├── figs/
└── output/
```

Please see each subfolder for a README file.
