#' Interactive Plot of Girls with similar names
#'
#'
#' @param data The full `irishbabynames` dataset.
#' @return A `girafe` interactive plot object.
#' @export
#'
#' @import dplyr
#' @import tidyr
#' @import ggplot2
#' @import ggiraph
#' @import stringdist
#'
filtered <- irishbabynames %>%
  filter(Statistic == "Girls Names in Ireland with 3 or More Occurrences")

girls_similar <- filtered %>%
  pivot_longer(
    cols = matches("^[0-9]{4}$"),
    names_to = "Year",
    values_to = "Value"
  ) %>%
  mutate(
    Year = as.numeric(Year),
    Value = as.numeric(Value),
    Gender = "Female"
  ) %>%
  select(Name, Year, Value, Gender) %>%
  filter(!is.na(Value), is.finite(Value))


plot_similar_names_girls_ggiraph <- function(input_name, max_distance = 1, per_million = FALSE, top_n = 5) {


  df <- girls_similar

  # Step 1: Find similar names by string distance
  unique_names <- df %>% distinct(Name) %>% pull(Name)
  distances <- stringdist::stringdist(tolower(input_name), tolower(unique_names), method = "lv")
  similar_names <- unique_names[distances <= max_distance]

  if (length(similar_names) == 0) {
    stop("No similar names found.")
  }

  # Step 2: Filter relevant data
  df <- df %>%
    filter(Name %in% similar_names) %>%
    filter(!is.na(Value), is.finite(Value)) %>%
    group_by(Name) %>%
    filter(n() >= 2) %>%  # keep names with at least 2 points
    ungroup()

  if (nrow(df) == 0) {
    stop("No similar names with enough data to plot.")
  }

  # Step 3: Keep only the top N popular names among similar ones
  top_similar <- df %>%
    group_by(Name) %>%
    summarise(total = sum(Value, na.rm = TRUE), .groups = "drop") %>%
    slice_max(order_by = total, n = top_n) %>%
    pull(Name)

  df <- df %>% filter(Name %in% top_similar)

  # Step 4: Normalize if requested
  if (per_million) {
    df <- df %>%
      group_by(Year) %>%
      mutate(total_occurences = sum(Value, na.rm = TRUE),
             Value = (Value / total_occurences) * 1e6) %>%
      ungroup()
  }

  # Step 5: Add tooltip
  df <- df %>%
    mutate(tooltip = paste0(Name, "<br>", Year, ": ", round(Value, 2)))


  # Step 6: Create interactive ggiraph plot
  p <- ggplot(df, aes(x = Year, y = Value, color = Name)) +
    geom_point_interactive(aes(tooltip = tooltip, data_id = Name), size = 2) +
    scale_y_continuous(limits = c(0, max(df$Value, na.rm = TRUE) * 1.05)) +
    labs(
      title = paste("Popularity of Names Similar to:", input_name),
      x = "Year",
      y = ifelse(per_million, "Per Million occurences", "Raw Count"),
      color = "Name"
    ) +
    theme_minimal() +
    theme(
      legend.position = "top",
      panel.grid.minor = element_blank(),
      axis.text.x = element_text(angle = 45, hjust = 1)
    )

  girafe(ggobj = p, width_svg = 10, height_svg = 6)
}
