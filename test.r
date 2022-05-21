if(!require(brms)) install.packages('brms')
library(brms)
library(ggplot2)

data(iris)

# this gives us the default brms priors
get_prior(Sepal.Width ~ 1, data = iris)

# set a custom prior for the intercept
# NOTE: the standard deviation in the normal prior lets us specify our strength of belief
# in the mean specified
priors = set_prior("normal(0,0.2)", class = "Intercept")

fit <- brm(Sepal.Width ~ 1,
	   data = iris, 
	   family = gaussian(),
	   prior = priors,
	   sample_prior = TRUE
)

# compare prior to posterior
# extract draws from first chain
draws = as_draws_array(fit)[,1,, drop = TRUE]

samples = rbind(
		data.frame(
			   type = "prior",
			   samples = as.numeric(draws[, "prior_Intercept"])
			   ),
		data.frame(
			   type = "posterior",
			   samples = as.numeric(draws[, "b_Intercept"])
		)
)

p = ggplot(samples, aes(x = samples)) + 
	geom_density(aes(color = type))



if(!require(brms)) install.packages('brms')
library(brms)
library(ggplot2)

data(iris)

# subset first 50 observations
iris_first = iris[1:50,]

# this gives us the default brms priors
get_prior(Sepal.Width ~ 1, data = iris_first)

# set a "flat" prior, no prior evidence
priors = set_prior("normal(0,4)", class = "Intercept")

fit_first <- brm(Sepal.Width ~ 1,
		 data = iris_first, 
		 family = gaussian(),
		 prior = priors,
		 sample_prior = TRUE
)

# compare prior to posterior
# extract draws from first chain
draws_first = as_draws_array(fit_first)[,1,, drop = TRUE]

samples_first = rbind(
		      data.frame(
				 type = "prior",
				 samples = as.numeric(draws_first[, "prior_Intercept"])
				 ),
		      data.frame(
				 type = "posterior",
				 samples = as.numeric(draws_first[, "b_Intercept"])
		      )
)

p_first = ggplot(samples_first, aes(x = samples)) + 
	geom_density(aes(fill = type)) + 
	scale_fill_manual(values = c('#526A83','#68855C'))

p_first

# second experiment, insert prior evidence about the mean
# get mean and standard deviation from posterior of mean from first experiment
mu_prior = mean(samples_first$samples[samples_first$type == "posterior"])
sd_prior = sd(samples_first$samples[samples_first$type == "posterior"])
priors = set_prior(paste("normal(", mu_prior, ",", sd_prior, ")", sep = ""), class = "Intercept")

# second subset of data: remaining
iris_second = iris[51:nrow(iris),]

fit_second <- brm(Sepal.Width ~ 1,
		  data = iris_second, 
		  family = gaussian(),
		  prior = priors,
		  sample_prior = TRUE
)

# compare prior to posterior
# extract draws from first chain
draws_second = as_draws_array(fit_second)[,1,, drop = TRUE]

samples_second = rbind(
		       data.frame(
				  type = "prior",
				  samples = as.numeric(draws_second[, "prior_Intercept"])
				  ),
		       data.frame(
				  type = "posterior",
				  samples = as.numeric(draws_second[, "b_Intercept"])
		       )
)

p_second = ggplot(samples_second, aes(x = samples)) + 
	geom_density(aes(color = type))

p_second
```


# 

$$
\mathbf{Y} = \mathbf{XB} + \mathbf{ZU} + \mathbf{E},
$$

$$
\begin{align}
\mathbf{Y} &\sim \mathbf{MVN}(\mathbf{XB} + \mathbf{ZU}, \boldsymbol{\Sigma}_E)\\
\mathbf{B} &\sim \mathbf{U}(-Inf,Inf)\\
\mathbf{U} &\sim \mathbf{MVN}(\mathbf{0}, \boldsymbol{\Sigma}_U) \\
\boldsymbol{\Sigma}_U &= \mathbf{diag(S)}_U\boldsymbol{\Omega}_U\mathbf{diag(S)}_U \\
\mathbf{S}_U &\sim \mathbf{Cauchy}(0,5)\\
\boldsymbol{\Omega}_U &\sim \mathbf{LKJ}(1)
\end{align}
$$


