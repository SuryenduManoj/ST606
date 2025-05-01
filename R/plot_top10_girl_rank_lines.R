#' Plot Interactive Line Chart for Top 10 Girls' Names by Rank (2001–2024)
#'
#' This function creates an interactive line plot (using ggiraph) showing how the top 10
#' girls' names by average rank changed in Ireland between 2001 and 2024.
#'
#' @param data A dataset like `irishbabynames` with columns from 2001 to 2024.
#'
#' @return A `girafe` object for interactive display.
#' @export
#'
#' @import dplyr
#' @import tidyr
#' @import ggplot2
#' @import ggiraph
plot_top10_girl_rank_lines <- function(data) {
  top10_girlnames <- data %>%
    dplyr::filter(Gender == "Female",
                  Statistic == "Girls Names in Ireland with 3 or More Occurrences Rank") %>%
    tidyr::pivot_longer(cols = `2001`:`2024`, names_to = "Year", values_to = "Rank") %>%
    dplyr::mutate(Year = as.integer(Year),
                  Rank = as.numeric(Rank)) %>%
    dplyr::filter(!is.na(Rank))

  top10_rank_g <- top10_girlnames %>%
    dplyr::group_by(Names) %>%
    dplyr::summarise(AverageRank = mean(Rank, na.rm = TRUE), .groups = "drop") %>%
    dplyr::arrange(AverageRank) %>%
    dplyr::slice(1:10) %>%
    dplyr::pull(Names)

  top10_girl_ranks <- top10_girlnames %>%
    dplyr::filter(Names %in% top10_rank_g) %>%
    dplyr::mutate(tooltip = paste("Name:", Names,
                                  "<br>Year:", Year,
                                  "<br>Rank:", Rank))

  plot3 <- ggplot2::ggplot(top10_girl_ranks, aes(x = Year, y = Rank, color = Names, group = Names)) +
    ggiraph::geom_line_interactive(aes(tooltip = tooltip), size = 1) +
    ggiraph::geom_point_interactive(aes(tooltip = tooltip), size = 2) +
    ggplot2::scale_y_reverse(breaks = 1:10) +
    ggplot2::scale_x_continuous(breaks = seq(2001, 2024, by = 1)) +
    ggplot2::labs(
      title = "Rank of Top 10 Girls' Names in Ireland (2001–2024)",
      x = "Year", y = "Rank (1 = most popular)", color = "Name"
    ) +
    ggplot2::theme_minimal() +
    ggplot2::theme(axis.text.x = element_text(angle = 45, hjust = 1))

  ggiraph::girafe(ggobj = plot3)
}

