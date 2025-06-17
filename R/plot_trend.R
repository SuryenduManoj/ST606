#' Plot name trend over years
#'
#' @description
#' Displays the trend of a given name (boys or girls) across years,
#' showing occurrences per million births, and rank as tooltip.
#'
#' @param name_input Name to visualize (character)
#' @return A `girafe` interactive ggplot object
#' @export
#' @import dplyr tidyr ggplot2 ggiraph

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
 per_million_births <- counts %>%
      group_by(Year) %>%
      summarise(total_occurences = sum(Value, na.rm = TRUE), .groups = "drop")

    data_names <- data_names %>%
      left_join(per_million_births, by = "Year") %>%
      mutate(Value = (Value / total_occurences) * 1e6)

  data_names <- data_names %>%
    mutate(tooltip = paste0(
      "Name: ", Name,
      "<br>Rank in ",Year,": ", ifelse(is.na(Rank), "Not Ranked", Rank)
    ))
  p <- ggplot(data_names, aes(x = Year, y = Value, color = Gender)) +
    geom_line_interactive(aes(data_id = Gender, tooltip = tooltip, group = Gender), size = 1.5) +
    geom_point_interactive(aes(data_id = Gender, tooltip = tooltip), size = 3)+
    labs(
      title = paste("Trend for Name:", name_input),
      x = "Year",
      y = "per million births",
      color = "Gender"
    ) +
    theme_minimal() +
    theme(
      legend.position = "top",
      axis.text.x = element_text(angle = 45, hjust = 1)
    )

  girafe(ggobj = p, width_svg = 10, height_svg = 6)
}
