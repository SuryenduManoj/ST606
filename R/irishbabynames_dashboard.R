#' Launch the Irish Babynames Shiny App
#'
#' This function launches the Shiny dashboard included in the irishbabynames package.
#' @export
#'
#' @import shiny
irishbabynames_dashboard <- function() {
  app_dir <- system.file("shiny/irishbabynames_app", package = "irishbabynames")
  if (app_dir == "") {
    stop("Could not find app directory. Try re-installing the package.", call. = FALSE)
  }
  shiny::runApp(app_dir, display.mode = "normal")
}
