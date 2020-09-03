# Angus Watters
# 08/26/2020
# Geog 176A
# Day 14 assignment

library(tidyverse)
library(sf)
library(units)
library(USAboundaries)
library(rnaturalearth)
library(gghighlight)
library(ggrepel)
library(knitr)
library(rmapshaper)
library(mapview)

cities = us_cities() %>% st_as_sf(coords = c('lng', 'lat'), crs = 4326) %>%
  filter(!state_name %in% c('Puerto Rico', 'Alaska', 'Hawaii')) %>%
  st_transform(5070)


conus = us_states() %>% st_as_sf(coords = c('lng', 'lat'), crs = 4326) %>%
  filter(!state_name %in% c('Puerto Rico', 'Alaska', 'Hawaii')) %>%
  st_transform(5070)

counties = us_counties() %>% st_as_sf(coords = c('lng', 'lat'), crs = 4326) %>%
  filter(!state_name %in% c('Puerto Rico', 'Alaska', 'Hawaii')) %>%
  st_transform(5070)


point_in_polygon3 = function(points, polygon, id){
  st_join(polygon, points) %>%
    st_drop_geometry() %>%
    count(get(id)) %>%
    setNames(c(id, "n")) %>%
    left_join(polygon, by = id) %>%
    st_as_sf()
}

city_in_county = point_in_polygon3(cities, counties, 'geoid')

plot_pip = function(data){
  ggplot() +
    geom_sf(data = data, aes(fill = log(n)), alpha = .9, size = .2) +
    scale_fill_gradient(low = "white", high = "darkblue") +
    theme_void() +
    theme(legend.position = 'none',
          plot.title = element_text(face = "bold", color = "darkblue", hjust = .5, size = 24)) +
    labs(title = "Number of cities in US counties",
         caption = paste0(sum(data$n), " cities represented"))
}

city_in_county = point_in_polygon3(cities, counties, 'geoid')

cities_per_county_plot = plot_pip(city_in_county)

ggsave(cities_per_county_plot, file = 'img/num-cities-in-US-counties.png')



