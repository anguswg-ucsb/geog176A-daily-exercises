# Angus Watters
# 08/13/2020
# Day 8 rolling mean script

library(tidyverse)
library(zoo)
library(ggthemes)

url = 'https://raw.githubusercontent.com/nytimes/covid-19-data/master/us-counties.csv'

covid = read_csv(url)

state1 = 'Oklahoma'

dailyNewCases = covid %>%
  select(state, date, cases) %>%
  filter(state == state1) %>%
  group_by(date) %>%
  summarise(cases = sum(cases, na.rm = TRUE)) %>%
  mutate(new_cases = cases - lag(cases),
        rollMean_7 = rollmean(new_cases, 7, fill = NA, align = 'right'))

rollingMean_ggplot = ggplot(data = dailyNewCases, aes(x = date)) +
  geom_col(aes(y = new_cases), col = 'aquamarine4', fill = 'aquamarine3') +
  geom_line(aes(y = rollMean_7), col = 'darkgreen', size = 1.5) +
  theme_economist() +
  labs(title = paste('New daily cases in', state1),
       x = 'Date',
       y = 'Cases',
       color = '',
       subtitle = 'Data Source: The New York Times') +
  theme(plot.title = element_text(size = 15, face = 'bold')) +
  theme(aspect.ratio = .5)

rollingMean_ggplot

ggsave(rollingMean_ggplot, file = 'img/new-cases-7-day-rolling-mean.png')





