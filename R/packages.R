course_repos <- function() {
  rspm <- Sys.getenv("RSPM", unset = "")
  renv_override <- Sys.getenv("RENV_CONFIG_REPOS_OVERRIDE", unset = "")

  cran <- if (nzchar(rspm)) {
    rspm
  } else if (nzchar(renv_override)) {
    renv_override
  } else {
    getOption("repos")[["CRAN"]]
  }

  if (is.null(cran) || identical(cran, "@CRAN@") || !nzchar(cran)) {
    cran <- "https://cloud.r-project.org"
  }

  c(
    STAN = "https://mc-stan.org/r-packages/",
    CRAN = cran
  )
}

course_packages <- function(include_applied = TRUE, include_stan = FALSE, include_legacy = FALSE) {
  core <- c(
    "dlookr",
    "ggplot2",
    "knitr",
    "rmarkdown"
  )

  applied <- c(
    "BGLR",
    "data.table",
    "DT",
    "lattice",
    "Matrix",
    "mvtnorm",
    "plotly",
    "rrBLUP",
    "tidyverse"
  )

  stan <- c(
    "bayesplot",
    "brms",
    "cmdstanr",
    "posterior"
  )

  legacy <- c(
    "car",
    "ellipse",
    "emmeans",
    "factoextra",
    "GGally",
    "htmltools",
    "klippy",
    "lsmeans",
    "lubridate",
    "mixtools",
    "pacman",
    "pander",
    "pedigreemm",
    "prettydoc",
    "remotes",
    "rjags",
    "rmdformats",
    "rstan"
  )

  unique(c(core, if (include_applied) applied, if (include_stan) stan, if (include_legacy) legacy))
}

missing_packages <- function(packages) {
  packages[!vapply(packages, requireNamespace, quietly = TRUE, FUN.VALUE = logical(1))]
}

install_missing_packages <- function(packages) {
  missing <- missing_packages(packages)

  if (!length(missing)) {
    message("All requested R packages are already installed.")
    return(invisible(character()))
  }

  message("Installing missing packages: ", paste(missing, collapse = ", "))
  install.packages(missing, repos = course_repos())

  still_missing <- missing_packages(packages)

  if (length(still_missing)) {
    stop(
      "Failed to install required packages: ",
      paste(still_missing, collapse = ", "),
      call. = FALSE
    )
  }

  invisible(missing)
}

check_cmdstan <- function(fix_toolchain = FALSE) {
  if (!requireNamespace("cmdstanr", quietly = TRUE)) {
    return(list(ok = FALSE, message = "cmdstanr is not installed."))
  }

  result <- tryCatch(
    {
      cmdstanr::check_cmdstan_toolchain(fix = fix_toolchain)
      path <- tryCatch(cmdstanr::cmdstan_path(), error = function(e) NA_character_)
      list(ok = TRUE, message = paste("cmdstan toolchain found.", path))
    },
    error = function(e) {
      list(ok = FALSE, message = conditionMessage(e))
    }
  )

  result
}
