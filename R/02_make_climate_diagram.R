# Author: Abhishek Kumar
# Affiliation: Panjab University, Chandigarh
# Email: abhikumar.pu@gmail.com
# Date: 19 Dec 2023
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

## load required packages
library(sf)             ## vector data handling
library(terra)          ## raster data handling
library(tidyverse)      ## general data manipulation and visualisation
library(tmap)           ## visualising spatial data

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

## bounding box of study area
ssb <- st_bbox(c(xmin = 76.75, ymin = 30.54, xmax = 77.56, ymax = 31.02),
               crs = st_crs(4326)) |> st_as_sfc()

mypath <- "E:/spatial-data/climate/wc2.1_country/IND_wc2.1_30s_"

## monthly precipitation
sprec <- paste0(mypath, "prec.tif") |> rast() |> crop(vect(ssb))
names(sprec) <- month.abb

## monthly minimum temperature
tmin <- paste0(mypath, "tmin.tif") |> rast() |> crop(vect(ssb))
names(tmin) <- month.abb

## monthly maximum temperature
tmax <- paste0(mypath, "tmax.tif") |> rast() |> crop(vect(ssb))
names(tmax) <- month.abb

## Boundary for study area
mh <- st_read("data/morni.gpkg", quiet = TRUE) |>
  summarise() |> mutate(Name = "Morni Hills") |> st_transform(4326)
chail <- st_read("data/chail.gpkg", quiet = T) |>
  summarise() |> mutate(Name = "Chail")
churdhar <- st_read("data/churdhar.gpkg", quiet = T) |>
  summarise() |> mutate(Name = "Churdhar")
sites_all <- bind_rows(mh, chail, churdhar) |> summarise() |> mutate(Name = "All")
study_area <- bind_rows(mh, chail, churdhar, sites_all)

## WorlClim site data
bind_rows(
  sprec |> terra::extract(study_area, fun = mean) |> mutate(Clim = "prec"),
  tmax  |> terra::extract(study_area, fun = mean) |> mutate(Clim = "tmax"),
  tmin  |> terra::extract(study_area, fun = mean) |> mutate(Clim = "tmin"),
  tmin  |> terra::extract(study_area, fun = mean) |> mutate(Clim = "abstmin")
) |>
  mutate(ID = factor(
    ID, levels = c(1:4),
    labels = c("Morni Hills", "Chail WLS", "Churdhar WLS", "All Sites")
  )) |>
  select(ID, Clim, Jan:Dec) |>
  write.csv("output/site_climate_wld.csv", row.names = F)

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

## function to plot Walter-Leith Climate diagram 
wld.plot <- function(sitename, ...){

  read.csv("output/site_climate_wld.csv") |>
    filter(ID == {{sitename}}) |>
    select(-c(ID, Clim)) |>
    climatol::diagwl(cols = NULL, stname = sitename, mlab = "en",
                     per = "1970 to 2000", ...)
}

## save all climate charts

pdf("figs/fig2a.pdf", width = 7, height = 5)
wld.plot("Morni Hills", alt = "400-1500")
dev.off()

pdf("figs/fig2b.pdf", width = 7, height = 5)
wld.plot("Chail WLS", alt = "900-2200")
dev.off()

pdf("figs/fig2c.pdf", width = 7, height = 5)
wld.plot("Churdhar WLS", alt = "1700-3600")
dev.off()

pdf("figs/fig2d.pdf", width = 7, height = 5)
wld.plot("All Sites", alt = "400-3600")
dev.off()

