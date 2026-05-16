build_bayesian_mean_brms_artifacts <- function(output_dir = "artifacts/models") {
  dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)

  required <- c("brms", "posterior")
  missing <- required[!vapply(required, requireNamespace, quietly = TRUE, FUN.VALUE = logical(1))]

  if (length(missing)) {
    stop("Missing required packages: ", paste(missing, collapse = ", "), call. = FALSE)
  }

  if (!requireNamespace("cmdstanr", quietly = TRUE)) {
    stop("cmdstanr is required for the course brms backend.", call. = FALSE)
  }

  cmdstan_path <- tryCatch(cmdstanr::cmdstan_path(), error = function(e) NA_character_)

  if (is.na(cmdstan_path) || !nzchar(cmdstan_path)) {
    stop("CmdStan is not installed. Run setup/install.R --stan --install-cmdstan.", call. = FALSE)
  }

  data(iris)

  priors <- brms::set_prior("normal(0,0.2)", class = "Intercept")

  fit <- brms::brm(
    Sepal.Width ~ 1,
    data = iris,
    family = brms::gaussian(),
    prior = priors,
    sample_prior = TRUE,
    backend = "cmdstanr",
    chains = 2,
    iter = 1000,
    seed = 2026,
    silent = 2,
    refresh = 0
  )

  draws <- posterior::as_draws_df(fit)

  artifact <- list(
    name = "bayesian_mean_brms",
    created_at = Sys.time(),
    fit = fit,
    prior = priors,
    draws = draws,
    summary = summary(fit),
    session = sessionInfo()
  )

  output_file <- file.path(output_dir, "bayesian_mean_brms.rds")
  saveRDS(artifact, output_file)
  message("Wrote ", output_file)

  invisible(output_file)
}

if (sys.nframe() == 0) {
  build_bayesian_mean_brms_artifacts()
}
