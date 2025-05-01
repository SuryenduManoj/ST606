

#' Interactive Plot of Top 10 boys' Names (1964–2000)
#'
#' This function creates an interactive plot showing the top 10 boys' names
#' in Ireland from 1964 to 2000 based on number of occurrences.
#'
#' @param data The full `irishbabynames` dataset.
#' @return A `girafe` interactive plot object.
#' @export
#'
#' @import dplyr
#' @import tidyr
#' @import ggplot2
#' @import ggiraph
#'
plot_top10_boys_occurrence <- function(data) {
  before2000 <- data[1:39]  # Drop extra columns beyond 2000
  boy_occurrences <- before2000 %>%
    dplyr::filter(Statistic == "boys Names in Ireland with 3 or More Occurrences")
  boy_pivot <- tidyr::pivot_longer(
    boy_occurrences,
    cols = `1964`:`2000`,
    names_to = "Year",
    values_to = "Count"
  ) %>%
    dplyr::mutate(Year = as.integer(Year))
  top10_boysname <- boy_pivot %>%
    dplyr::group_by(Year) %>%
    dplyr::slice_max(order_by = Count, n = 10, with_ties = FALSE) %>%
    dplyr::ungroup()
  top10_boysname <- top10_boysname %>%
    dplyr::mutate(tooltip = paste("Name:", Names, "<br>Count:", Count))
  plot2 <- ggplot2::ggplot(top10_boysname, aes(x = as.factor(Year), y = Count, color = Names, group = Names)) +
    ggiraph::geom_line_interactive(aes(tooltip = tooltip), size = 1) +
    ggiraph::geom_point_interactive(aes(tooltip = tooltip), size = 2) +
    ggplot2::labs(
      title = "Top 10 boys' Names in Ireland by Year (1964–2000)",
      x = "Year", y = "Occurrences", color = "Name"
    ) +
    ggplot2::theme_minimal() +
    ggplot2::theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1))

  ggiraph::girafe(ggobj = plot2)
}
