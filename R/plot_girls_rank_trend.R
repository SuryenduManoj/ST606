#' @param prefix Character. Name prefix to filter (e.g. "b")
#' @param top_n Integer. Number of top names to show (default = 10)
#' @return A ggiraph plot object
#' @export

#' @import tidyr
#' @import ggplot2
#' @import ggiraph

girls_rank <- irishbabynames %>%
  filter(Statistic == "Girls Names in Ireland with 3 or More Occurrences Rank") %>%
  pivot_longer(
    cols = matches("^[0-9]{4}$"),
    names_to = "Year",
    values_to = "Rank"
  ) %>%
  mutate(
    Year = as.numeric(Year),
    Rank = as.numeric(Rank),
    Gender = "Female"
  ) %>%
  filter(!is.na(Rank), is.finite(Rank)) %>%
  select(Name, Year, Rank, Gender)
plot_girls_rank_trend <- function(selected_year)  {
  df <- girls_rank %>%
    filter(Year == selected_year) %>%
    arrange(Rank) %>%
    slice(1:10) %>%
    mutate(Name = factor(Name, levels = rev(Name))) %>%  # for reversed bar order
    mutate(tooltip = paste0("Name: ", Name, "<br>Rank: ", Rank))

  gg <- ggplot(df, aes(x = Name, y = Rank)) +
    geom_col_interactive(
      aes(tooltip = tooltip, data_id = Name, fill = Name),
      width = 0.8
    ) +
    coord_flip() +
    scale_y_reverse(breaks = 1:10) +
    labs(
      title = paste("Top 10 Ranked Girls Names in", selected_year),
      x = "Name", y = "Rank (Lower = More Popular)"
    ) +
    theme_minimal() +
    theme(
      legend.position = "none",
      panel.grid.minor = element_blank()
    )

  girafe(ggobj = gg, width_svg = 10, height_svg = 6)
}
