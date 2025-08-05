#' Plot name trend over years
#'
#' @description
#' Displays the trend of a given name (boys or girls) across years,
#' showing occurrences and rank as tooltip.
#' @import dplyr
#' @import ggplot2
#' @import tidyr
#' @importFrom ggiraph geom_line_interactive geom_point_interactive girafe
#' @importFrom stats reorder
#' @importFrom utils data
#' @param name_input Name to visualize (character)
#' @return A `girafe` interactive ggplot object
#' @export



plot_trend <- function(name_input) {
  occurences <- irishbabynames %>%
    pivot_longer(
      cols = matches("^[0-9]{4}$"),
      names_to = "Year",
      values_to = "Value"
    ) %>%
    mutate(
      Year = as.numeric(Year),
      Value = as.numeric(Value)
    ) %>%
    filter(!is.na(Value), is.finite(Value))

  counts <- occurences %>%
    filter(Statistic %in% c(
      "Girls Names in Ireland with 3 or More Occurrences",
      "Boys Names in Ireland with 3 or More Occurrences"
    ))
  ranks <- occurences %>%
    filter(Statistic %in% c(
      "Girls Names in Ireland with 3 or More Occurrences Rank",
      "Boys Names in Ireland with 3 or More Occurrences Rank"
    )) %>%
    rename(Rank = Value) %>%
    select(Name, Gender, Year, Rank)


  data_names <- counts %>%
    filter(tolower(Name) == tolower(name_input)) %>%
    left_join(ranks, by = c("Name", "Gender", "Year"))

  if (nrow(data_names) == 0) {
    return(girafe(ggobj = ggplot() + labs(title = paste("Name", name_input, "not found."))))
}



  data_names <- data_names %>%
    mutate(tooltip = paste0(
      "Name: ", Name,"<br>Occurrence in ",Year,": ",Value,
      "<br>Rank:", ifelse(is.na(Rank), "Not Ranked", Rank)
    ))
  p <- ggplot(data_names, aes(x = Year, y = Value, color = Gender)) +
    geom_line_interactive(aes(data_id = Gender, tooltip = tooltip, group = Gender), size = .6, linetype = "dashed") +
    geom_point_interactive(aes(data_id = Gender, tooltip = tooltip), size = 3) +
    scale_x_continuous(
      breaks = seq(min(data_names$Year, na.rm = TRUE), 2024,4) # every 4 years, include 2024
    ) +
    scale_y_continuous(limits = c(0, max(data_names$Value, na.rm = TRUE)*1.05)) +
    labs(
      title = paste("Trend for Name:", name_input),
      x = "Year",
      y = "Occurrence for each name",
      color = "Gender"
    ) +
    theme_minimal() +
    theme(
      legend.position = "top",
      axis.text.x = element_text(angle = 45, hjust = 1)
    )

  girafe(ggobj = p, width_svg = 10, height_svg = 6)
}
