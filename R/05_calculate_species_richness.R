# Author: Abhishek Kumar
# Affiliation: Panjab University, Chandigarh
# Email: abhikumar.pu@gmail.com
# Date: 19 Dec 2023
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

## load required packages
library(tidyverse)      ## general data manipulation

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

## function to calculate richness from range limits

## df: a data frame with lower (LL) and upper (UL) elevation limits
## min.elev and max.elev: minimum and maximum elevation for bands
## band.size: size of each elevational band, default to 100
calc.richness <- function(df, LL, UL, min.elev, max.elev, band.size = 100){
  
  ## elevational bands for richness
  elev.bands <- seq(min.elev + band.size, max.elev, band.size)
  
  ## create empty data matrix
  out <- matrix(ncol = length(elev.bands), nrow = nrow(df))
  
  # for loop for all species
  for(i in 1:nrow(df)){
    
    # create species presence-absence at elevations
    # add results to a matrix
    out[i, ] <- elev.bands >= df[i, "LL"] &
      (elev.bands - band.size) <= df[i, "UL"]
  }
  
  ## add column names as elevations
  colnames(out) <- elev.bands
  
  ## sum species at each elevation zone and convert to data frame
  richness <- out |> colSums() |> as.data.frame() |> 
    ## add elevation column from row names
    rownames_to_column("elevation") |> 
    ## rename column name to Species
    rename("richness" = "colSums(out)") |>
    ## convert elevation to numeric
    mutate(elevation = as.numeric(elevation))
  
  ## return richness
  return(richness)
}

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

## adjusted richness for available explanatory variables
esr_morni <- read.csv("output/site_plants_wcvp.csv") |>
  left_join(read.csv("output/site_spec_elev.csv"), by = "taxon_name") |>
  filter(!is.na(UL) & Morni == 1) |>
  mutate(UL = ifelse(test = UL > 1300, yes = 1300, no = UL)) |>
  calc.richness(LL = "LL", UL = "UL", 300, 1300) |>
  mutate(site = "Morni")

esr_chail <- read.csv("output/site_plants_wcvp.csv") |>
  left_join(read.csv("output/site_spec_elev.csv"), by = "taxon_name") |>
  filter(!is.na(UL) & Chail == 1) |>
  mutate(LL = ifelse(test = LL < 900, yes = 900, no = LL),
         LL = ifelse(test = LL > 2000, yes = 2000, no = LL),
         UL = ifelse(test = UL < 1000, yes = 1000, no = UL),
         UL = ifelse(test = UL > 2100, yes = 2100, no = UL)) |>
  calc.richness(LL = "LL", UL = "UL", 900, 2100) |>
  mutate(site = "Chail")

esr_churdhar <- read.csv("output/site_plants_wcvp.csv") |>
  left_join(read.csv("output/site_spec_elev.csv"), by = "taxon_name") |>
  filter(!is.na(UL) & Churdhar == 1) |>
  mutate(LL = ifelse(test = LL < 1600, yes = 1600, no = LL),
         UL = ifelse(test = UL < 1700, yes = 1700, no = UL)) |>
  calc.richness(LL = "LL", UL = "UL", 1600, 3400) |>
  mutate(site = "Churdhar")

esr_all <- read.csv("output/site_plants_wcvp.csv") |>
  left_join(read.csv("output/site_spec_elev.csv"), by = "taxon_name") |>
  filter(!is.na(UL)) |>
  distinct(taxon_name, .keep_all = T) |>
  calc.richness(LL = "LL", UL = "UL", 300, 3400) |>
  mutate(site = "All")

## bind and save the calculated species richness
bind_rows(esr_morni, esr_chail, esr_churdhar, esr_all) |>
  write.csv("output/band_richness.csv", row.names = FALSE)
