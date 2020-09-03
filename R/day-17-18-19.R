# Angus Watters
# 09/01/2020
# Geog 176A
# Day 17 + 18 assignment


# Day 17:

library(tidyverse)
library(sf)
library(units)
library(USAboundaries)
library(elevatr)
library(rgdal)
library(sp)
library(raster)
library(AOI)
library(osmdata)
library(leaflet)
library(leafem)
library(leafpop)
library(mapview)


goleta = read_csv('data/uscities.csv') %>%
  filter(city == 'Goleta') %>%
  st_as_sf(coords = c('lng', 'lat'), crs = 4326) %>%
  st_transform(5070) %>%
  st_buffer(5000) %>%
  st_bbox() %>%
  st_as_sfc() %>%
  st_as_sf()


elev = get_elev_raster(goleta, z = 13) %>% crop(goleta)

plot(elev)


### Raster properties:
# The raster has dimensions of 5 rows, 5 columns, which results in 25 cells, a grid of 5 by 5 cells.
# Each cell has a resolution of 2040 by 2050 which means each cell has an x value of 2040 and a y value of 2050.
# The raster has an extent of -2156854, -2146654, 1530967, 1541217  (xmin, xmax, ymin, ymax) which means the grid of cells is within
# a bounding box with a x axis ranging from xmin = -2156854 and xmax = -2146654, and a y axis ranging from ymin = 1530967 and ymax = 1541217.
# The green and yellow cells in the upper right hand corner represent areas with higher elevations,
# and the tan/light brown cells in the lower left and lower right represent areas with lower elevations.


# Day 18:

elev2 = elev
elev2[elev2 <= 0] = NA
plot(elev2)

func = function(i) {
  ifelse(i <= 0, NA, 1)
}

elev3 = calc(elev, func)

elev4 = elev3*elev

hex = cellStats(elev2, fivenum)

reclass = data.frame(c(-Inf,100,200, 300, 400, 500), seq(100,600,100), c(0:5))

stac = stack(elev, elev3, elev4)

elev5_plot = reclassify(elev4, reclass) %>%
  plot(col = viridis::viridis(6))


# Day 19:

bb = goleta %>%
  st_bbox(stac) %>%
  st_as_sfc() %>%
  st_as_sf() %>%
  st_transform(4326)


osm = opq(bb)

osm = opq(bb) %>%
  add_osm_feature(key = 'amenity', value = 'restaurant') %>%
  osmdata_sf()

pts = osm$osm_points %>%
  dplyr::select(osm_id, name, amenity) %>%
  filter(!is.na(name))

pts_elev = pts %>%
  st_transform(crs(stac)) %>%
  st_intersection(st_as_sfc(st_bbox(elev))) %>%
  mutate(elev = raster::extract(elev, pts)) %>%
  st_transform(4326)

resta_leaflet = leaflet::leaflet() %>%
  addProviderTiles(providers$CartoDB) %>%
  addAwesomeMarkers(data = pts_elev, label = ~name, popup = (paste(as.character(pts_elev$elev), 'meters')))


