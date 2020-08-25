library(tidyverse)
library(sf)
library(units)

library(USAboundaries)
library(rnaturalearth)

library(gghighlight)
library(ggrepel)
library(knitr)

#Question 1:

USAboundaries::us_states(resolution = "low")
eqdc = '+proj=eqdc +lon_0=-96 +lat_0=40 +lat_1=20 +lat_2=60 +x_0=0 +y_0=0 +datum=NAD83 +units=m +no_defs'

# continental USA sf
usaStates = us_states() %>%
  filter(!name %in% c('Puerto Rico', 'Alaska', 'Hawaii'))

usa_eqdc = st_transform(usaStates, eqdc)



# Mexico, USA, Canada sf
rnaturalearth::countries110

country_sf = st_as_sf(countries110, coords = c('lng', 'lat'), crs = eqdc) %>%
  filter(admin %in% c('Mexico', 'United States of America', 'Canada'))

country_b = st_combine(country_sf) %>%
  st_cast('MULTILINESTRING')


# US Cities sf
us_cities = read_csv('data/uscities.csv') %>%
  filter(!state_name %in% c('Puerto Rico', 'Alaska', 'Hawaii'))

cities_sf = st_as_sf(us_cities, coords = c('lng', 'lat'), crs = eqdc) %>%
  filter(!state_name %in% c('Puerto Rico', 'Alaska', 'Hawaii'))
cities_sf
plot(cities_sf)



# Question 2:

# Distance to USA Border



# Distance to States (km)

usa_c = st_combine(usa_eqdc)
usa_c


