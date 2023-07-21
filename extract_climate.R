# Author: Abhishek Kumar
# Affiliation: Panjab University, Chandigarh
# Email: abhikumar.pu@gmail.com

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
churdhar <- st_read("data/chur.gpkg", quiet = T) |>
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
  write.csv("data/site_climate_wld.csv", row.names = F)
