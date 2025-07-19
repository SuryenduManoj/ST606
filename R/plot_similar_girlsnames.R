# File: R/plot_similar_girlsnames.R

#' Plot Phonetically Similar Girls' Names Over Time
#'
#' This function visualizes phonetically similar girls' names based on the Metaphone algorithm.
#' It shows trends over years using per million births for similar names for girls.
#'
#' @param input_girls_name A name string to find phonetically similar girls' names.
#' @param max_distance Maximum string distance to consider for name similarity.
#' @return An interactive ggiraph plot.
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
#' @export

plot_similar_girlsnames <- function(input_girls_name, max_distance = 1) {
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


  df1 <- girls_similar1
  unique_names1 <- df1 %>% distinct(Name) %>% pull(Name)
  clean_names1 <- stri_trans_general(unique_names1, "Latin-ASCII")
  clean_names1 <- gsub("[^A-Za-z]", "", clean_names1)
  clean_input1 <- stri_trans_general(input_girls_name, "Latin-ASCII")
  clean_input1 <- gsub("[^A-Za-z]", "", clean_input1)

  name_codes1 <- metaphone(tolower(clean_names1))
  input_code1 <- metaphone(tolower(clean_input1))

  similar_names1 <- unique_names1[name_codes1 == input_code1]
  if (length(similar_names1) == 0) {
    stop("No phonetically similar names found.")
  }

  df1 <- df1 %>%
    filter(Name %in% similar_names1)%>%
    left_join(ranks, by = c("Name", "Gender", "Year"))

  if (nrow(df1) == 0) {
    stop("No similar names with enough data to plot.")
  }
  total_births_all <-  irishbabynames %>%
    filter(Statistic %in% c(
      "Boys Names in Ireland with 3 or More Occurrences",
      "Girls Names in Ireland with 3 or More Occurrences"
    )) %>%
    pivot_longer(
      cols = matches("^[0-9]{4}$"),
      names_to = "Year", values_to = "Total"
    ) %>%
    mutate(Year = as.numeric(Year)) %>%
    filter(!is.na(Total), is.finite(Total)) %>%
    group_by(Year) %>%
    summarise(total_births = sum(Total, na.rm = TRUE), .groups = "drop")

  df1 <- df1 %>%
    left_join(total_births_all, by = "Year") %>%
    mutate(Value = (Value / total_births) * 1e6)
  df1 <- df1 %>%
    mutate(tooltip = paste0(
      "Name: ", Name,
      "<br>Year: ", Year,
      "<br>Per Million Births: ", round(Value, 2),
      "<br>Rank: ", ifelse(is.na(Rank), "Not Ranked", Rank)
    )) %>%
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
      title = paste("Similar Names to:", input_girls_name),
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
