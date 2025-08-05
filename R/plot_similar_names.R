#' Internal: Plot phonetically similar names
#'
#' `plot_similar_boysnames()` and `plot_similar_girlsnames()` to generate
#' phonetically similar name plots using the Metaphone algorithm.
#'
#' @param input_name Name to find phonetically similar names for
#' @param gender_label "Male" or "Female"
#' @param gender_stat Statistic string for filtering main dataset
#' @param gender_rank_stat Statistic string for filtering ranks
#'
#' @return An interactive ggiraph plot
#' @keywords internal
#'
#' @import dplyr
#' @import ggplot2
#' @import tidyr
#' @importFrom ggiraph geom_line_interactive geom_point_interactive girafe
#' @importFrom stats reorder
#' @importFrom utils data
#' @importFrom phonics metaphone
#' @importFrom stringi stri_trans_general
#' @importFrom stringdist stringdist
#'
plot_similar_names <- function(input_name, gender_label, gender_stat, gender_rank_stat) {

  # Filter for gender
  filtered <- irishbabynames %>%
    filter(Statistic == gender_stat)

  # Reshape and clean
  names_long <- filtered %>%
    pivot_longer(
      cols = matches("^[0-9]{4}$"),
      names_to = "Year",
      values_to = "Value"
    ) %>%
    mutate(
      Year = as.numeric(Year),
      Value = as.numeric(Value),
      Gender = gender_label
    ) %>%
    select(Name, Year, Value, Gender) %>%
    filter(!is.na(Value), is.finite(Value))

  # Get ranks
  ranks <- irishbabynames %>%
    filter(Statistic %in% c(
      "Boys Names in Ireland with 3 or More Occurrences Rank",
      "Girls Names in Ireland with 3 or More Occurrences Rank"
    )) %>%
    pivot_longer(
      cols = matches("^[0-9]{4}$"),
      names_to = "Year",
      values_to = "Rank"
    ) %>%
    mutate(Year = as.numeric(Year)) %>%
    select(Name, Gender, Year, Rank)

  # Clean and apply Metaphone
  unique_names <- names_long %>% distinct(Name) %>% pull(Name)
  clean_names <- stri_trans_general(unique_names, "Latin-ASCII")
  clean_names <- gsub("[^A-Za-z]", "", clean_names)
  clean_input <- stri_trans_general(input_name, "Latin-ASCII")
  clean_input <- gsub("[^A-Za-z]", "", clean_input)

  name_codes <- metaphone(tolower(clean_names))
  input_code <- metaphone(tolower(clean_input))

  similar_names <- unique_names[name_codes == input_code]
  if (length(similar_names) == 0) {
    stop("No phonetically similar names found.")
  }

  # Merge and prepare
  df <- names_long %>%
    filter(Name %in% similar_names) %>%
    left_join(ranks, by = c("Name", "Gender", "Year"))

  if (nrow(df) == 0) {
    stop("No similar names with enough data to plot.")
  }

  # Tooltip
  df <- df %>%
    mutate(tooltip = paste0(
      "Name: ", Name,
      "<br>Year: ", Year,
      "<br>Occurrence: ", Value,
      "<br>Rank: ", ifelse(is.na(Rank), "Not Ranked", Rank)
    )) %>%
    arrange(Name, Year)

  df_lines <- df %>%
    group_by(Name) %>%
    filter(n() > 1) %>%
    ungroup()

  # Plot
  p <- ggplot() +
    geom_line_interactive(
      data = df_lines,
      aes(x = Year, y = Value, color = Name, tooltip = tooltip, data_id = Name, group = Name),
      size = 0.6, linetype = "dashed"
    ) +
    geom_point_interactive(
      data = df,
      aes(x = Year, y = Value, color = Name, tooltip = tooltip, data_id = Name),
      size = 2
    ) +
    scale_x_continuous(
      breaks = seq(min(df$Year, na.rm = TRUE), 2024, 4) # every 4 years, include 2024
    ) +
    scale_y_continuous(
      limits = c(0, max(df$Value, na.rm = TRUE) * 1.05) # buffer for readability
    ) +
    labs(
      title = paste("Similar Names to:", input_name),
      x = "Year",
      y = "Occurrence for each name",
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
