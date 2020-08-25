# Angus Watters
# 08/21/2020
# Geog 176A
# Day 12 assignment

library(tidyverse)
library(sf)
library(units)
library(ggthemes)

library(USAboundaries)
library(rnaturalearth)


usa = st_as_sf(us_states(), coords = c('lng', 'lat'), crs = 4326) %>%
  filter(!name %in% c('Puerto Rico', 'Alaska', 'Hawaii'))

usa_c = st_combine(usa) %>%
  st_cast('MULTILINESTRING')

plot(usa_c)

state = st_as_sf(us_states(), coords = c('lng', 'lat'), crs = 4326) %>%
  filter(name %in% 'Tennessee')


states_touch = st_filter(us_states(), state, .predicate = st_intersects)

border_states_ggplot = ggplot() +
  geom_sf(data = usa_c) +
  geom_sf(data = states_touch, fill = 'red', alpha = .5) +
  theme_gray() +
  theme(aspect.ratio = .5) +
  labs(title = 'Tennessee border states',
       subtitle = 'Number of border states: 8')

ggsave(border_states_ggplot, file = 'img/TN-border-states-map.png', width = 8)
