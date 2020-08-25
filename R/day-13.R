# Angus Watters
# Geog 176A
# Day 13 assignment


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

# Question 1:
USAboundaries::us_states()

conus = us_states()  %>%
  filter(!name %in% c('Puerto Rico', 'Alaska', 'Hawaii'))

usa_c= st_combine(conus) %>% st_cast('MULTILINESTRING') %>%
  st_transform(5070)

usa_u= st_union(conus) %>% st_cast('MULTILINESTRING') %>%
  st_transform(5070)

# num points in USA union
pts_usa = npts(usa_u)

# Raw conus
plot(usa_u, main = pts_usa)

# st_simplify
usa10000 = st_simplify(usa_u, dTolerance = 10000)
usa18000 = st_simplify(usa_u, dTolerance = 18000)

# dTolerance = 10000, st_simplify
plot(usa10000)
pts_usa10000 = npts(usa10000)

plot(usa10000, main = pts_usa10000)

# dTolerance = 18000, st_simplify
plot(usa18000)
pts_usa18000 = npts(usa18000)

plot(usa18000, main = pts_usa18000)

# ms_simplify
usa10 = ms_simplify(usa_u, keep = .1)
usa5 = ms_simplify(usa_u, keep = .05)


# keep = 10%, ms_simplify
plot(usa10)
pts_usa10 = npts(usa10)

plot(usa10, main = pts_usa10)

# keep = 5% ms_simplify
plot(usa5)
pts_usa5 = npts(usa5)

plot(usa5, main = pts_usa5)
?`rmapshaper`
?plot()

