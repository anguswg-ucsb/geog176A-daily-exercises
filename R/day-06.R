# Angus Watters
# 08/11/2020
# Exercise 6 R script


library(tidyverse)
library(scales)


url = 'https://raw.githubusercontent.com/nytimes/covid-19-data/master/us-counties.csv'

covid = read_csv(url) %>%
covid %>%
head(5)

# Question 1:

SixStates = covid %>%
  filter(date == max(date)) %>%
  group_by(state) %>%
  summarize(cases = sum(cases, na.rm = TRUE)) %>%
  ungroup() %>%
  slice_max(cases, n = 6) %>%
  pull(state)



six_states_data = covid %>%
  filter(state %in% SixStates) %>%
  group_by(date,state) %>%
  summarize(cases = sum(cases, na.rm = TRUE))

top_states_ggplot = ggplot(data = six_states_data, aes(x = date, y = cases)) +
  geom_point(aes(col = state)) +
  geom_smooth(color = 'black', size = .5) +
  labs(title = '6 States with most COVID-19 cases',
       x = 'Date',
       y = 'Number of Cases',
       color = '',
       subtitle = 'Data Source: The New York Times') +
  facet_wrap(~state, scales = 'free_x') +
  theme_bw()


ggsave(top_states_ggplot, file = 'img/top-covid-case-states.png', width = 8)



# Question 2:

covid %>%
  group_by(date) %>%
  summarize(cases = sum(cases, na.rm = TRUE))

total_daily_ggplot = ggplot(data = total_daily_cases, aes(x = date, y = cases)) +
  geom_col(color = 'cyan4') +
  labs(title = 'National Cummulatie Case Counts: COVID-19 Pandemic',
    x = 'Date',
    y = 'Cases',
    color = '',
    subtitle = 'Data Source: The New York Times') +
  theme_grey()

ggsave(total_daily_ggplot, file = 'img/total_national_cases.png', width = 8)




