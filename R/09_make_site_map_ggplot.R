# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Author: Abhishek Kumar
# Affiliation: Panjab University, Chandigarh
# Email: abhikumar.pu@gmail.com
# Date: 2025-10-16
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

## load required packages
library(sf)             ## vector data handling
library(terra)          ## raster data handling
library(tidyverse)      ## general data manipulation and visualisation

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

## boundaries for protected areas boundary
mh <- st_read("data/morni.gpkg", quiet = TRUE) |> 
  summarise() |> mutate(Name = "Morni Hills") |> st_transform(4326)

khr <- st_read("data/khol_hi_raitan.gpkg", quiet = TRUE) |>
  filter(Type == "WLS") |> mutate(Name = "KHR WLS")

chail <- st_read("data/chail.gpkg", quiet = TRUE) |> 
  summarise() |> mutate(Name = "Chail")

churdhar <- st_read("data/churdhar.gpkg", quiet = TRUE) |> 
  summarise() |> mutate(Name = "Churdhar")

study_area <- bind_rows(mh, chail, churdhar)

## bounding box for main map
ssb <- st_bbox(c(xmin = 76.75, ymin = 30.54, 
                 xmax = 77.56, ymax = 31.02),
               crs = st_crs(4326)) |> 
  st_as_sfc()

## Download and save elevation data
# elevatr::get_elev_raster(locations = st_as_sf(ssb), z = 10) |>
#   rast() |>
#   crop(vect(st_as_sf(ssb))) |>
#   writeRaster("output/site_elev.tif")

## read elevation data
elev <- rast("output/site_elev.tif")
names(elev) <- "elevation"

## Calculate hill shade
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
  mutate(District = ifelse(
    test = District %in% c("Ambala", "Patiala"), 
    yes = NA, no = District
  ))

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

## bounding box for inset map
sbox <- st_bbox(c(xmin = 72, ymin = 30, 
                  xmax = 82, ymax = 37),
                crs = st_crs(4326)) |> 
  st_as_sfc()

## state level boundaries
ind1 <- st_read("data/siwalik_states.gpkg", quiet = TRUE) |>
  st_transform(crs = st_crs(4326)) |>
  mutate(STATE = case_when(
    STATE == "Ladakh"           ~"LA",
    STATE == "Jammu & Kashmir"  ~"JK",
    STATE == "Himachal Pradesh" ~"HP",
    STATE == "Punjab"           ~"PB",
    STATE == "Uttarakhand"      ~"UK"
  ))

## Prepare inset map
inset_map <- ggplot() +
  geom_sf(data = ind1, fill = "grey80", alpha = 0.2,
          color = "grey40", linewidth = 0.1) +
  geom_sf_text(data = ind1, aes(label = STATE),
               size = 2) +
  
  geom_sf(data = ssb, fill = "lightpink", alpha = 0.3,
          color = "red") +
  
  coord_sf(xlim = c(72, 82),
           ylim = c(29.8, 37.2),
           expand = FALSE) +
  theme_void() +
  theme(
    plot.background = element_rect(fill = "white", color = "grey30")
  )

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

main_map <- ggplot() +
  geom_raster(data = as.data.frame(hs, xy = TRUE),
              aes(x, y, fill = hillshade), 
              show.legend = FALSE) +
  scale_fill_distiller(palette = "Greys") +
  
  ggnewscale::new_scale_fill() +
  geom_raster(data = as.data.frame(elev, xy = TRUE),
              aes(x, y, fill = elevation),
              alpha = 0.2) +
  scale_fill_fermenter(
    name = "Elevation (m)", 
    palette = "YlOrBr", direction = 1,
    breaks = seq(0, 4000, 500),
    guide = guide_legend(override.aes = list(alpha = 0.6),
                         reverse = TRUE)
  ) +
  
  # scale_fill_distiller(name = "Elevation (m)", 
  #                      palette = "YlOrBr", direction = 1) +
  
  geom_sf(data = ind2, fill = NA, 
          color = "#662506", linewidth = 0.2) +
  geom_sf_label(
    data = ind2, aes(label = District),
    size = 3, alpha = 0.7,
    fill = "#ffffe5", color = "#662506", border.colour = NA,
    nudge_x = c(Chandigarh = 0.00, Shimla = -0.21, Sirmaur = 0, 
                Solan = 0, 0, Panchkula = 0.02, 0, 
                "SAS Nagar" = 0),
    nudge_y = c(Chandigarh = -0.01, Shimla = 0.1, Sirmaur = 0, 
                Solan = 0, 0, Panchkula = -0.13, 0, 
                "SAS Nagar" = 0)
    
  ) +
  
  geom_sf(data = ind1, fill = NA) +
  
  geom_sf(data = study_area, 
          fill = "palegreen1", alpha = 0.5,
          color = "darkgreen", linewidth = 0.7) +
  geom_sf(data = khr, fill = NA, 
          color = "darkgreen", linewidth = 0.2) +
  annotate(geom = "label",
           label = c("Morni Hills", "Chail", "Churdhar"),
           x = c(77.071, 77.20, 77.47),
           y = c(30.694, 30.96, 30.87),
           border.color = NA, alpha = 0.6
  ) +
  
  ggspatial::annotation_north_arrow(
    location = "tr",
    height = unit(0.1, "npc"), width = unit(0.04, "npc")
  ) +
  ggspatial::annotation_scale(
    pad_x = unit(0.6, "npc"), pad_y = unit(0.08, "npc")
  ) +
  coord_sf(xlim = c(76.75, 77.56),
           ylim = c(30.54, 31.02),
           expand = FALSE) +
  theme(legend.position = "inside",
        legend.justification.inside = c(1, 0),
        legend.position.inside = c(0.99, 0.01),
        legend.background = element_rect(fill = alpha("white", 0.7)),
        axis.title = element_blank())


# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

cowplot::ggdraw() +
  cowplot::draw_plot(main_map) +
  cowplot::draw_plot(
    inset_map, 
    x = 0.06, hjust = 0,
    y = 0.95, vjust = 1,
    width = 0.3, height = 0.3
  )

# ggsave("figs/site-map-ggplot.pdf", width = 7, height = 5)
# ggsave("figs/site-map-ggplot.png", width = 7, height = 5, dpi = 600)
