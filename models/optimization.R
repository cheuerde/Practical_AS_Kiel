build_optimization_artifacts <- function(output_dir = "artifacts/models") {
  dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)

  set.seed(2026)

  milk_data <- data.frame(
    feed_kg = seq(4, 12, length.out = 36)
  )

  milk_data$milk_kg <- 17.5 + 1.65 * milk_data$feed_kg +
    rnorm(nrow(milk_data), sd = 1.8)

  sse_feed_model <- function(par, data) {
    beta_0 <- par[1]
    beta_1 <- par[2]

    y_hat <- beta_0 + beta_1 * data$feed_kg
    sum((data$milk_kg - y_hat)^2)
  }

  fit_optim <- optim(
    par = c(15, 1),
    fn = sse_feed_model,
    data = milk_data,
    method = "BFGS"
  )

  fit_bounded <- optim(
    par = c(15, 1),
    fn = sse_feed_model,
    data = milk_data,
    method = "L-BFGS-B",
    lower = c(-Inf, 0),
    upper = c(Inf, 4)
  )

  normal_nll <- function(par, data) {
    beta_0 <- par[1]
    beta_1 <- par[2]
    sigma <- exp(par[3])

    y_hat <- beta_0 + beta_1 * data$feed_kg
    -sum(dnorm(data$milk_kg, mean = y_hat, sd = sigma, log = TRUE))
  }

  fit_ml <- optim(
    par = c(15, 1, log(2)),
    fn = normal_nll,
    data = milk_data,
    method = "BFGS"
  )

  artifact <- list(
    name = "optimization",
    created_at = Sys.time(),
    data = milk_data,
    least_squares = fit_optim,
    bounded_least_squares = fit_bounded,
    maximum_likelihood = fit_ml,
    session = sessionInfo()
  )

  output_file <- file.path(output_dir, "optimization.rds")
  saveRDS(artifact, output_file)
  message("Wrote ", output_file)

  invisible(output_file)
}

if (sys.nframe() == 0) {
  build_optimization_artifacts()
}
