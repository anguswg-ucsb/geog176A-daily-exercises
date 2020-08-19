# Angus Watters
# 08/12/2020
# Geog176A Day 7 daily exercise

library(tidyverse)

url = 'https://raw.githubusercontent.com/nytimes/covid-19-data/master/us-counties.csv'

covid = read_csv(url)


covid %>%
  select(state, cases)

region = data.frame(state = state.name, region = state.region)

covid_region = covid %>%
  right_join(region, by = "state") %>%
  group_by(region, date) %>%
  summarize(cases  = sum(cases),
            deaths = sum(deaths)) %>%
  pivot_longer(cols = c('cases', 'deaths'))

region_ggplot = ggplot(covid_region, aes(x = date, y = value)) +
  geom_line(aes(col = region)) +
  facet_grid(name~region, scale = "free_y") +
  theme_linedraw() +
  theme_bw()
  labs(title = "Cummulative Cases and Deaths: Region",
       y = "Daily Total Count",
       x = "Date",
       caption = "Daily Exercise 7",
       subtitle = "COVID-19 Data: New York Times" )

region_ggplot

ggsave(region_ggplot, file = 'img/cases-deaths-regions.png')






