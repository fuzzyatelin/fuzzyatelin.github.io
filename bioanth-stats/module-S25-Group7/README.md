# AN588_Vignette
Shared repository for AN588 Stats Vignette Project
## Notes

https://www.youtube.com/watch?v=azXCzI57Yfc&t=267s

LDA is linear discriminate analysis. It is a type of analysis that is used to predict a data point based on other features. LDA works by calculating the means and covariance matrices for each data class. Linear discrimiante analysis utilizes pattern recognition in order to predict a specific data point. LDA effectively reduces the amount of data dimensions, making modeling more efficient. To successfuly compute the LDA in R, the following packages need to be be loaded:
- library(MASS)
- library(ggplot2)
- library(caret) 

To reduce dimensionality, LDA follows these criteria:
- maximize the distance between the means of two classes
- minimize the variance within individual classes

### Properties and Assumptions of LDA
- LDAs operate by projecting a feature space (a data set of n dimensions) onto a smaller space "k", where k <= n-1 without losing class information.
- an LDA mdoel comprises the statistical properties that are calculated for the data in each class - where there are multiple variables, these properties are calculated over the multivariate Gaussian (normal) distribution
  - the Gaussian distribution is a probability distribution that is symmetric about the mean, resulting in a "bell curve" shape
  
- multivariates are:
  - means
  - covariance matrix (measures how each variable or feature relates to others within the same class)

the model assumes the following:
- the input dataset has a normal distribution
- the dataset is linearly separable, meaning LDA can draw a decision boundary that separates the data points
- each class has the same covariance matrix

  These assumptions carry the limitation that LDA may not perform well in high-dimensional feature spaces

linear transformations are analyzed using eigenvectors and eigenvalues
- eigenvectors provide the "direction" within the scatterplot
  - during dimensionality reduction, the eigenvectors are calculated from the data set and collected in two scatter-matrices:
    - between-class scatter matrix representing info about the spread within each class
    - within-class scatter matrix representing how classes are spread between themselves
- eigenvalues denote the importance of the directional data
  - a high eigenvalue means the associated eigenvector is more critical

## Implementing LDA
To use LDA effectively, it's essential to prepare the dataset beforehand
### 1. preprocess the data to ensure normality and centrality
  - this is achieved by passing the n-component parameter, which identifies the number of linear discriminants to retrieve
### 2. Choose an appropriate number of dimensions for the lower-dimensional space
  - this is also achieved by passing the n-component paramter
### 3. Regularize the model
  - regularization aims to prevent "overfitting", where the stat model fits exactly against its training data and undermines accuracy
    
## Using LDA
### 1. Calculate between-class variance
  - the distance between class means
### 2. Calculate within-class variance
  - the distance between class means and samples
### 3. Project data into lower-dimensional space
  - this maximizes the between-class variance and minimizes within-class variance. We can represent the lienar discriminant function for two classes mathematically with:
  - delta(x) = x * (sigma^2 * (mu_0 - mu_1) - 2 * sigma^2 * (mu_0^2 - mu_1^2) + ln(P(w_0)/P(w_1)))
  - where:
    - delta(x) represents the linear discriminant function
    - x represents the input data point
    - mu_0 and mu_1 are the means of the two classes
    - sigma^2 is the common within-class variance
    - P(w_0) and P(w_1) are the prior probabilities of the two classes

 
## Challenge 1
use linear discriminant analysis (LDA) to analyze the gibbon femur data and predict the sex of gibbons by species and femur length

## Challenge 2
use LFA to predict the age class of gibbons based on their species and femur length

## Challenge 3
use quadratic discriminant analysis to predict the family of a primate based on several data points from the Kamilar and Cooper data 
predictors:
- mean brain size
- mean mass for males and females
- mass dimorphism ratio
- canine dimophism ratio
