# File: R/plot_similar_girlsnames.R

#' Plot Phonetically Similar Girls' Names Over Time
#'
#' This function visualizes phonetically similar girls' names based on the Metaphone algorithm.
#' It shows trends over years  for similar names for girls.
#'
#' @param input_girls_name A name string to find phonetically similar girls' names.
#' @param max_distance Maximum string distance to consider for name similarity.
#'
#' @return An interactive ggiraph plot.
#' @export
#'
plot_similar_girlsnames <- function(input_girls_name, max_distance = 1) {
  plot_similar_names(
    input_name = input_girls_name,
    gender_label = "Female",
    gender_stat = "Girls Names in Ireland with 3 or More Occurrences",
    gender_rank_stat = "Girls Names in Ireland with 3 or More Occurrences Rank"
  )
}
