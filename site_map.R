# Author: Abhishek Kumar
# Affiliation: Panjab University, Chandigarh
# Email: abhikumar.pu@gmail.com

## load required packages
library(sf)             ## vector data handling
library(terra)          ## raster data handling
library(tidyverse)      ## general data manipulation and visualisation
library(tmap)           ## visualising spatial data

## boundaries for protected aras boundary
mh <- st_read("data/morni.gpkg", quiet = TRUE) |> 
  summarise() |> mutate(Name = "Morni Hills") |> st_transform(4326)
khr <- st_read("data/khol_hi_raitan.gpkg", quiet = TRUE) |>
  filter(Type == "WLS") |> mutate(Name = "KHR WLS")
chail <- st_read("data/chail.gpkg", quiet = TRUE) |> 
  summarise() |> mutate(Name = "Chail")
churdhar <- st_read("data/chur.gpkg", quiet = TRUE) |> 
  summarise() |> mutate(Name = "Churdhar")
study_area <- bind_rows(mh, chail, churdhar)

## bounding box for main map
ssb <- st_bbox(c(xmin = 76.75, ymin = 30.54, xmax = 77.56, ymax = 31.02),
               crs = st_crs(4326)) |> st_as_sfc()

## Download and save elevation data
# ssb |> elevatr::get_elev_raster(z = 10) |>
#   rast() |> crop(vect(ssb)) |> writeRaster("data/site_elev.tif")

elev <- rast("data/site_elev.tif")

## Calculate hillshade
slope  <- terrain(elev, "slope",  unit = "radians")
aspect <- terrain(elev, "aspect", unit = "radians")
hs <- shade(slope, aspect)

## state level boundaries
ind1 <- st_read("data/siwalik_states.gpkg", quiet = TRUE) |>
  st_transform(crs = st_crs(4326)) |>
  ## Remove Rajasthan from Text labels
  mutate(STATE = case_when(
    STATE == "Himachal Pradesh" ~"HP",
    STATE == "Punjab" ~"PB"
  ))

## District level boundaries
ind2 <- st_read("data/site_districts.gpkg", quiet = TRUE) |>
  st_intersection(ssb) |>
  mutate(District = ifelse(test = District %in% c("Ambala", "Patiala"), 
                           yes = NA, no = District))

## switch off spherical geometry
sf_use_s2(FALSE) 

## Make the map
main_map <- tm_shape(hs) + 
  tm_raster(palette = "-Greys", legend.show = FALSE) +
  tm_graticules(lines = FALSE, labels.size = 0.75) +
  tm_shape(elev) + 
  tm_raster(alpha = 0.2, title = "Elevation (m)", legend.reverse = TRUE) +
  
  tm_shape(ind2) + tm_borders(col = "black", lwd = 1.25) + 
  tm_text("District", bg.color = "white", bg.alpha = 0.6, 
          xmod = c(Chandigarh = 0.7, Shimla = -9, Sirmaur = 0, Solan = 0, 
                   NA, Panchkula = 0.75, NA, "SAS Nagar" = 0.75), 
          ymod = c(Chandigarh = 0, Shimla = 3.75, Sirmaur = 0, Solan = 0, 
                   NA, Panchkula = -4.5, NA, "SAS Nagar" = -1)) +
  tm_shape(ind1, bbox = st_bbox(ssb)) + tm_borders(lwd = 1.5, col = "black") +
  
  tm_shape(study_area) + 
  tm_fill(col = "palegreen1", alpha = 0.4) +
  tm_borders(col = "darkgreen", lwd = 2) +
  tm_text("Name", shadow = T, size = 1,
          xmod = c("Morni Hills" = 0.2, Chail = 0, Churdhar = 0),
          ymod = c("Morni Hills" = 1, Chail = 0.1, Churdhar = 0.5)) +  
  tm_shape(khr) + tm_borders(col = "darkgreen", lwd = 1) + 
  tm_text("Name", shadow = T, size = 0.75) +
  
  tm_compass(position = c(0.975, 0.975), just = c("right", "top"), 
             bg.color = "white", bg.alpha = 0.5) +
  tm_scale_bar(position = c(0.75, 0.025), just = c(1, 0), text.size = 0.75, 
               breaks = c(0, 5, 10), bg.color = "white", bg.alpha = 0.5) +
  tm_layout(legend.bg.color = "grey85", legend.bg.alpha = 0.9,
            legend.position = c(0.025, 0.975), legend.just = c(0, 1),
            legend.text.size = 0.85, legend.title.size = 1.25)

## bounding box for inset map
sbox <- st_bbox(c(xmin = 75, ymin = 29, xmax = 79, ymax = 33),
                crs = st_crs(4326)) |> st_as_sfc()

## state level boundaries
ind1 <- st_read("data/siwalik_states.gpkg", quiet = TRUE) |>
  st_transform(crs = st_crs(4326)) |>
  ## Remove Rajasthan from Text labels
  mutate(STATE = case_when(
    STATE == "Himachal Pradesh" ~"HP", STATE == "Punjab" ~"PB",
    STATE == "Haryana" ~"HR"
  ))

## Prepare inset map
inset_map <- tm_shape(ind1, bbox = st_bbox(sbox)) +
  tm_fill(col = "grey80", alpha = 0.2) + tm_borders(col = "grey40") + 
  tm_text("STATE", remove.overlap = TRUE) +
  
  tm_shape(ssb) + 
  tm_fill(col = "lightpink", alpha = 0.3) + tm_borders(col = "red")

## arrange and save maps
myvp <- grid::viewport(
  x = 0.975, y = 0.11, just = c("right", "bottom"), 
  width = unit(1.5, "inches"), height = unit(1.5, "inches")
)

## save to local disc
tmap_save(main_map, filename = "figs/fig1.pdf", insets_tm = inset_map,
          insets_vp = myvp, height = 5, width = 7, units = "in")
tmap_save(main_map, filename = "figs/fig1.png", insets_tm = inset_map,
          insets_vp = myvp, height = 5, width = 7, units = "in", dpi = 600)
