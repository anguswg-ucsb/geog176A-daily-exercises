# Angus Watters
# 08/27/2020
# Geog 176A
# Day 15 assignment

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

cities = us_cities()
regions = data.frame(region = state.region, state_name = state.name)

south_counties = left_join(us_counties(), regions) %>%
  filter(region == "South") %>%
  st_transform(st_crs(cities))

south_states = south_counties %>%
  group_by(state_name) %>% summarise()

south_cent = st_centroid(south_counties)


plot_tess = function(data, title){
  ggplot() +
    geom_sf(data = data, fill = "white", col = "navy", size = .2) +
    theme_void() +
    labs(title = title, caption = paste("This tesselation has:", nrow(data), "tiles" )) +
    theme(plot.title = element_text(hjust = .5, color =  "navy", face = "bold"))
}
plot_tess(south_counties, 'counties')

# Create a grid over the south with 70 rows and 50 columns
sq_grid = st_make_grid(south_counties, n = c(70, 50)) %>%
  st_as_sf() %>%
  mutate(id = 1:n())

plot_tess(sq_grid, "Square Coverage")

hex_grid = st_make_grid(south_counties, n = c(70, 50), square = FALSE) %>%
  st_as_sf() %>%
  mutate(id = 1:n())

plot_tess(hex_grid, "Hexegonal Coverage")

