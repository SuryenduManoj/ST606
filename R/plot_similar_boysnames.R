# File: R/plot_similar_boysnames.R

#' Plot Phonetically Similar Boys' Names Over Time
#'
#' This function visualizes phonetically similar boys' names based on the Metaphone algorithm.
#' It shows trends over years for similar names for boys.
#'

#' @param input_boys_name A name string to find phonetically similar boys' names.
#' @param max_distance Maximum string distance to consider for name similarity.
#'
#' @return An interactive ggiraph plot.
#' @export
plot_similar_boysnames <- function(input_boys_name, max_distance = 1) {
  plot_similar_names(
    input_name = input_boys_name,
    gender_label = "Male",
    gender_stat = "Boys Names in Ireland with 3 or More Occurrences",
    gender_rank_stat = "Boys Names in Ireland with 3 or More Occurrences Rank"
  )
}
