library(tidyverse)
library(USAboundaries)
library(USAboundariesData)
library(sf)


USAboundaries::us_states()

states = us_states()


lower48 = states %>%
  filter(!name %in% c('Puerto Rico', 'Alaska', 'Hawaii'))

#Question 1:

usa_c= st_combine(lower48) %>% st_cast('MULTILINESTRING')
plot(usa_c)

#Question 2:

usa_u= st_union(lower48) %>% st_cast('MULTILINESTRING')
plot(usa_u)


