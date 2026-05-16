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
minimal <- any(args %in% "--minimal")

packages <- course_packages(
  include_applied = !minimal,
  include_stan = include_stan,
  include_legacy = include_legacy
)
missing <- missing_packages(packages)

cat("R version:", R.version.string, "\n")
cat("Repository:", repo_root, "\n\n")

if (length(missing)) {
  cat("Missing packages:\n")
  cat(paste0("  - ", missing, collapse = "\n"), "\n\n")
} else {
  cat("All requested R packages are installed.\n\n")
}

if (include_stan) {
  status <- check_cmdstan(fix_toolchain = FALSE)
  cat("Stan toolchain:", if (isTRUE(status$ok)) "OK" else "NOT READY", "\n")
  cat(status$message, "\n\n")
}

if (length(missing)) {
  quit(status = 1)
}
