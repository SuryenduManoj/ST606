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

  # Step 5: Get total births per gender (for normalization)
  total_births <- long_data %>%
    group_by(Gender) %>%
    summarise(total = sum(Value, na.rm = TRUE), .groups = "drop")

  # Step 6: Merge & normalize per million births
  plot_data <- filtered %>%
    left_join(total_births, by = "Gender") %>%
    mutate(
      Rate = (Value / total) * 1e6,
      Gender = factor(Gender, levels = c("Female", "Male"))
    )

  # Step 7: Plot
  p <- ggplot(plot_data, aes(x = Name, y = Rate, fill = Gender,
                             text = paste0("Name: ", Name,
                                           "<br>Gender: ", Gender,
                                           "<br>Occurrences (per million): ", round(Rate, 1))
  )) +
    geom_col(position = "stack") +
    labs(
      title = paste("Unisex Names Starting with", toupper(start), "in", year),
      x = "Name", y = "Occurrences per million births", fill = "Gender"
    ) +
    scale_y_continuous(labels = scales::label_comma()) +
    theme_minimal() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))

  ggplotly(p, tooltip = "text")
}
