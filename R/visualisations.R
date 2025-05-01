library(dplyr)
library(tidyr)
library(ggplot2)
library(ggstream)
library(plotly)
library(ggiraph)

#irishbabynames_year <- irishbabynames %>%
  #pivot_longer(cols = `1964`:`2024`, names_to = "Year", values_to = "Value") %>%
  #mutate(Year = as.integer(Year))
before20 <- irishbabynames[1:39]
girl_occurrences <- before20 %>% filter(Statistic == "Girls Names in Ireland with 3 or More Occurrences")
boys_occurrences <- before20 %>% filter(Statistic == "Boys Names in Ireland with 3 or More Occurrences")

girl_pivot <- pivot_longer(girl_occurrences, cols='1964':'2000',names_to = "Year", values_to = "Count")
boy_pivot <- pivot_longer(boys_occurrences, cols='1964':'2000',names_to = "Year", values_to = "Count")


top10_girlsname <- girl_pivot %>%
  group_by(Year) %>%
  slice_max(order_by = Count, n = 10, with_ties = FALSE) %>%
  ungroup()

top10_boyssname <- boy_pivot %>%
  group_by(Year) %>%
  slice_max(order_by = Count, n = 10, with_ties = FALSE) %>%
  ungroup()



plot1 <- ggplot(top10_girlsname, aes(x = as.factor(Year), y = Count, color = Names, group = Names)) +
  geom_line_interactive(aes(tooltip = Names), size = 1) +
  geom_point_interactive(aes(tooltip = paste(Names, Count)), size = 2) +
  labs(title = "Top 10 Girls' Names in Ireland by Year (1964–2000)",
       x = "Year", y = "Occurrences", color = "Name") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1))

girafe(ggobj = plot1)


plot2 <- ggplot(top10_boyssname, aes(x = as.factor(Year), y = Count, color = Names, group = Names)) +
  geom_line_interactive(aes(tooltip = Names), size = 1) +
  geom_point_interactive(aes(tooltip = paste(Names, Count)), size = 2) +
  labs(title = "Top 10 Boys' Names in Ireland by Year (1964–2000)",
       x = "Year", y = "Occurrences", color = "Name") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1))

girafe(ggobj = plot2)







top10_girlnames <- irishbabynames %>%
  filter(Gender == "Female",
         Statistic == "Girls Names in Ireland with 3 or More Occurrences Rank") %>%
  pivot_longer(cols = `2001`:`2024`, names_to = "Year", values_to = "Rank") %>%
  mutate(Year = as.integer(Year),
         Rank = as.numeric(Rank)) %>%
  filter(!is.na(Rank))

top10_rank_g <- top10_girlnames %>%
  group_by(Names) %>%
  summarise(AverageRank = mean(Rank, na.rm = TRUE), .groups = "drop") %>%
  arrange(AverageRank) %>%
  slice(1:10) %>%
  pull(Names)

top10_girl_ranks <- top10_girlnames %>%
  filter(Names %in% top10_rank_g) %>%
  mutate(tooltip = paste("Name:", Names,
                         "<br>Year:", Year,
                         "<br>Rank:", Rank))
rank_data_girls <- top10_girl_ranks %>%
  mutate(tooltip = paste("Name:", Names,
                         "<br>Year:", Year,
                         "<br>Rank:", Rank))
plot3 <- ggplot(rank_data_girls, aes(x = Year, y = Rank, color = Names, group = Names)) +
  geom_line_interactive(aes(tooltip = tooltip), size = 1) +
  geom_point_interactive(aes(tooltip = tooltip), size = 2) +
  scale_y_reverse(breaks = 1:10)+
  scale_x_continuous(breaks = seq(2001, 2024, by = 1)) +  # show fewer x-axis ticks
  labs(title = "Rank of Top 10 Girls' Names in Ireland (2001–2024)",
       x = "Year", y = "Rank (1 = most popular)", color = "Name") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
girafe(ggobj = plot3)
