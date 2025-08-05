#' Plot Unisex Names Starting with a Letter in a Given Year
#'
#' @param start A character letter to filter names starting with it.
#' @param year Numeric year (e.g., 2020).
#'
#' @return A plotly bar chart showing unisex names starting with the letter.
#' @export
#' @import dplyr
#' @import ggplot2
#' @import tidyr
#' @importFrom ggiraph geom_line_interactive
#' @importFrom stats reorder
#' @importFrom utils data
#' @importFrom plotly ggplotly
#' @examples
#' plot_unisex_names("A", 2020)

#' @importFrom scales label_comma
#' @param start A character letter to filter names starting with it.
#' @param year Numeric year (e.g., 2020).
#'


plot_unisex_names <- function(start, year) {
  # Step 1: Filter only valid gender stats
  unisex_data <- irishbabynames %>%
    filter(Statistic %in% c(
      "Boys Names in Ireland with 3 or More Occurrences",
      "Girls Names in Ireland with 3 or More Occurrences"
    ))

  # Step 2: Reshape the data
  long_data <- unisex_data %>%
    pivot_longer(cols = matches("^[0-9]{4}$"), names_to = "Year", values_to = "Value") %>%
    mutate(
      Year = as.numeric(Year),
      Value = as.numeric(Value)
    ) %>%
    filter(Year == year, !is.na(Value), is.finite(Value))

  # Step 3: Identify names used by both genders in that year
  names_with_both <- long_data %>%
    group_by(Name) %>%
    summarise(genders_present = n_distinct(Gender), .groups = "drop") %>%
    filter(genders_present == 2) %>%
    pull(Name)

  # Step 4: Filter names starting with the letter & having both genders
  filtered <- long_data %>%
    filter(Name %in% names_with_both,
           startsWith(tolower(Name), tolower(start)))

  if (nrow(filtered) == 0) {
    return(ggplotly(ggplot() +
                      labs(title = paste("No unisex names starting with", start, "in", year))))
  }

  # Step 4: Plot
  p <- ggplot(filtered, aes(x = Name, y = Value, fill = Gender,
                             text = paste0("Name: ", Name,
                                           "<br>Gender: ", Gender,
                                           "<br>Occurrences: ", Value)
  )) +
    geom_col(position = "stack") +
    labs(
      title = paste("Unisex Names Starting with", toupper(start), "in", year),
      x = "Name", y = "Occurrence for each name", fill = "Gender"
    ) +
    scale_y_continuous(labels = scales::label_comma()) +
    theme_minimal() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))

  ggplotly(p, tooltip = "text")
}
