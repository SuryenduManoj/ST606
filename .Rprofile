# Only unset TMPDIR if running package checks (prevents Quarto bug on Windows)
if (interactive() && any(grepl("check", commandArgs(), ignore.case = TRUE))) {
  Sys.unsetenv("TMPDIR")
}
