library(tidyverse)
library(sf)
library(units)

library(USAboundaries)
library(rnaturalearth)

library(gghighlight)
library(ggrepel)
library(knitr)

# Day 10 - Question 1:

us_cities = read_csv('data/uscities.csv')

cities_sf = st_as_sf(us_cities, coords = c('lng', 'lat'), crs = 4326) %>%
  filter(city %in% c('Santa Barbara', 'Mammoth Lakes'))

cities_5070 = st_transform(cities_sf, 5070)

cities_eqds = st_transform(cities_sf, '+proj=eqdc +lon_0=-96 +lat_0=40 +lat_1=20 +lat_2=60 +x_0=0 +y_0=0 +datum=NAD83 +units=m +no_defs')


#distance between in 4326 projection
st_distance(cities_sf)
set_units(st_distance(cities_sf), "km") %>% drop_units()


#distance between in 5070 projection
st_distance(cities_5070)

#distance between in eqds projection
st_distance(cities_eqds)
