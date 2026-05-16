args <- commandArgs(trailingOnly = TRUE)
script_args <- commandArgs(trailingOnly = FALSE)
file_arg <- grep("^--file=", script_args, value = TRUE)

repo_root <- if (length(file_arg)) {
  normalizePath(file.path(dirname(sub("^--file=", "", file_arg[[1]])), ".."), mustWork = TRUE)
} else {
  normalizePath(getwd(), mustWork = TRUE)
}

source(file.path(repo_root, "R", "packages.R"))

include_stan <- any(args %in% c("--stan", "--all"))
include_legacy <- any(args %in% c("--legacy", "--all"))
install_cmdstan <- any(args %in% c("--install-cmdstan", "--all"))
fix_toolchain <- any(args %in% c("--fix-toolchain", "--all"))
minimal <- any(args %in% "--minimal")

packages <- course_packages(
  include_applied = !minimal,
  include_stan = include_stan || install_cmdstan,
  include_legacy = include_legacy
)

install_missing_packages(packages)

if (include_stan || install_cmdstan) {
  status <- check_cmdstan(fix_toolchain = fix_toolchain)
  message(status$message)

  if (install_cmdstan) {
    if (!requireNamespace("cmdstanr", quietly = TRUE)) {
      stop("cmdstanr must be installed before CmdStan can be installed.")
    }

    cores <- parallel::detectCores(logical = FALSE)

    if (is.na(cores)) {
      cores <- 2
    }

    cores <- max(1, cores)
    cmdstan_version <- Sys.getenv("CMDSTAN_VERSION", unset = NA_character_)

    if (is.na(cmdstan_version) || !nzchar(cmdstan_version)) {
      cmdstanr::install_cmdstan(cores = cores)
    } else {
      cmdstanr::install_cmdstan(version = cmdstan_version, cores = cores)
    }
  }
}

message("Course setup finished.")
