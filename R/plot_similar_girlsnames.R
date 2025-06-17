# File: R/plot_similar_girlsnames.R

#' Plot Phonetically Similar Girls' Names Over Time
#'
#' This function visualizes phonetically similar girls' names based on the Metaphone algorithm.
#' It shows trends over years using per million births for similar names for girls.
#'
#' @param input_name1 A name string to find phonetically similar girls' names.
#' @return An interactive ggiraph plot.
#' @import dplyr
#' @import tidyr
#' @import ggplot2
#' @import ggiraph
#' @importFrom phonics metaphone
#' @importFrom stringi stri_trans_general
#' @importFrom stringdist stringdist
#' @export

plot_similar_girlsnames <- function(input_name1, max_distance = 1) {
  filteredg <- irishbabynames %>%
    filter(Statistic == "Girls Names in Ireland with 3 or More Occurrences")

  girls_similar1 <- filteredg %>%
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

  df1 <- girls_similar1
  unique_names1 <- df1 %>% distinct(Name) %>% pull(Name)
  clean_names1 <- stri_trans_general(unique_names1, "Latin-ASCII")
  clean_names1 <- gsub("[^A-Za-z]", "", clean_names1)
  clean_input1 <- stri_trans_general(input_name1, "Latin-ASCII")
  clean_input1 <- gsub("[^A-Za-z]", "", clean_input1)

  name_codes1 <- metaphone(tolower(clean_names1))
  input_code1 <- metaphone(tolower(clean_input1))

  similar_names1 <- unique_names1[name_codes1 == input_code1]
  if (length(similar_names1) == 0) {
    stop("No phonetically similar names found.")
  }

  df1 <- df1 %>%
    filter(Name %in% similar_names1)

  if (nrow(df1) == 0) {
    stop("No similar names with enough data to plot.")
  }
 per_million <- df1 %>%
      group_by(Year) %>%
      mutate(total_birth1 = sum(Value, na.rm = TRUE),
             Value = (Value / total_birth1) * 1e6) %>%
      ungroup()

  df1 <- df1 %>%
    mutate(tooltip = paste0(Name, "<br>", Year, ": ", round(Value, 2))) %>%
    arrange(Name, Year)

  df1_lines1 <- df1 %>%
    group_by(Name) %>%
    filter(n() > 1) %>%
    ungroup()

  p1 <- ggplot() +
    geom_line_interactive(
      data = df1_lines1,
      aes(x = Year, y = Value, color = Name, tooltip = tooltip, data_id = Name, group = Name),
      size = 1
    ) +
    geom_point_interactive(
      data = df1,
      aes(x = Year, y = Value, color = Name, tooltip = tooltip, data_id = Name),
      size = 2
    ) +
    scale_y_continuous(limits = c(0, max(df1$Value, na.rm = TRUE) * 1.05)) +
    labs(
      title = paste("Similar Names to:", input_name1),
      x = "Year",
      y = "Per Million births",
      color = "Name"
    ) +
    theme_minimal() +
    theme(
      legend.position = "top",
      panel.grid.minor = element_blank(),
      axis.text.x = element_text(angle = 45, hjust = 1)
    )

  girafe(ggobj = p1, width_svg = 10, height_svg = 6)
}

