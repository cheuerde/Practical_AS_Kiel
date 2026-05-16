args <- commandArgs(trailingOnly = TRUE)
script_args <- commandArgs(trailingOnly = FALSE)
file_arg <- grep("^--file=", script_args, value = TRUE)

repo_root <- if (length(file_arg)) {
  normalizePath(file.path(dirname(sub("^--file=", "", file_arg[[1]])), ".."), mustWork = TRUE)
} else {
  normalizePath(getwd(), mustWork = TRUE)
}

setwd(repo_root)

run_stan <- any(args %in% c("--stan", "--all"))
output_dir <- "artifacts/models"

source(file.path(repo_root, "models", "optimization.R"))
build_optimization_artifacts(output_dir = output_dir)

if (run_stan) {
  source(file.path(repo_root, "models", "bayesian_mean_brms.R"))
  build_bayesian_mean_brms_artifacts(output_dir = output_dir)
} else {
  message("Skipping Stan/brms artifacts. Use --stan to generate them.")
}

message("Model artifact build finished.")
