library(dplyr)
library(tidyr)
library(ggplot2)
library(ggstream)
library(plotly)

irishbabynames_year <- irishbabynames %>%
  pivot_longer(cols = `1964`:`2024`, names_to = "Year", values_to = "Value") %>%
  mutate(Year = as.integer(Year))

girls_rank <- irishbabynames_year %>%
  filter(Statistic == "Girls Names in Ireland with 3 or More Occurrences Rank")%>%    # Convert Year to integer type
  filter(!is.na(Value)) %>% group_by(Names) %>%
  filter(Value == min(Value)) %>%
  ungroup()


girls_count <- irishbabynames_year %>%
  filter(Statistic == "Girls Names in Ireland with 3 or More Occurrences")

boys_rank <- irishbabynames_year %>%
  filter(Statistic == "boysNames in Ireland with 3 or More Occurrences Rank")

boys_count <- irishbabynames_year %>%
  filter(Statistic == "boysNames in Ireland with 3 or More Occurrences")

#ggplot(girls_rank, aes(x = Year, y = Value, fill = Names)) +
 #      geom_stream() +
  #     theme_minimal() +
   #   labs(
    #         title = "Popularity of Girls Names in Ireland Over Time",
#x = "Year",  y = "Popularity") +   theme(legend.position = "none")



# Assuming you have your data properly loaded and filtered as 'girls_rank'
ggplot_plot <- ggplot(girls_rank, aes(x = Year, y = Value, fill = Names, text = paste("Name:", Names, "<br>Value:", Value))) +
  geom_stream() +
  theme_minimal() +
  labs(
    title = "Popularity of Girls Names in Ireland Over Time",
    x = "Year",
    y = "Popularity"
  ) +
  theme(legend.position = "none")

# Convert to interactive plot
ggplotly(ggplot_plot, tooltip = "text")




