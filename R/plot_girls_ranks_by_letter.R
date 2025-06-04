plot_girls_ranks_by_letter <- function(selected_year, prefix) {
  df <- girls_rank %>%
    filter(Year == selected_year) %>%
    filter(startsWith(tolower(Name), tolower(prefix))) %>%
    filter(!is.na(Rank), is.finite(Rank), Rank <= 100) %>%
    arrange(Rank) %>%
    mutate(Name = factor(Name, levels = rev(Name))) %>%
    mutate(tooltip = paste0("Name: ", Name, "<br>Rank: ", Rank))

  if (nrow(df) == 0) {
    return(girafe(ggobj = ggplot() + labs(title = "No matching names ranked in top 100.")))
  }

  p <- ggplot(df, aes(x = Rank, y = Name)) +
    geom_point_interactive(
      aes(tooltip = tooltip, data_id = Name, color = Name),
      size = 4
    ) +
    scale_x_reverse(breaks = seq(1, 100, 5)) +
    labs(
      title = paste0("Girls' Names Starting with '", prefix, "' Ranked in Top 100 (", selected_year, ")"),
      x = "Rank (Lower is More Popular)", y = "Name"
    ) +
    theme_minimal() +
    theme(legend.position = "none")

  girafe(ggobj = p, width_svg = 10, height_svg = 6)
}
