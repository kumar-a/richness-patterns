# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++# Author: Abhishek Kumar
# Affiliation: Panjab University, Chandigarh
# Email: abhikumar.pu@gmail.com
# Date: 19 Dec 2023
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

## load required packages
library(tidyverse)  ## general data manipulation
library(iNEXT)      ## Estimate species diversity

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

## function to create presence-absence matrix from range limits

## df: a data frame with lower (LL) and upper (UL) elevation limits
## min.elev and max.elev: minimum and maximum elevation for bands
## band.size: size of each elevational band, default to 100
calc.presab <- function(df, LL, UL, min.elev, max.elev, 
                        band.size = 100){
  
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
  colnames(out) <- paste0("e", elev.bands)
  rownames(out) <- rownames(df)
  
  ## return richness
  return(out)
}

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

## data for species and elevation ranges
df_sp_elev <- read_csv("output/site_plants_wcvp.csv") |>
  select(taxon_name, Morni, Chail, Churdhar) |>
  
  ## merge duplicate species
  group_by(taxon_name) |>
  mutate_all(~sum(.x)) |>
  distinct(taxon_name, .keep_all = TRUE) |>
  
  ## join elevational limits
  left_join(read_csv("output/site_spec_elev.csv"),
            by = "taxon_name") |>
  select(-taxon_authors)


## calculate presence absence matrices
df_morni <- df_sp_elev |>
  column_to_rownames("taxon_name") |>
  filter(!is.na(UL) & Morni == 1) |>
  calc.presab(min.elev = 300, max.elev = 1300) |>
  as.data.frame() |>
  mutate_all(~as.numeric(.x))

df_chail <- df_sp_elev |>
  column_to_rownames("taxon_name") |>
  filter(!is.na(UL) & Chail == 1) |>
  calc.presab(min.elev = 900, max.elev = 2100) |>
  as.data.frame() |>
  mutate_all(~as.numeric(.x))

df_churdhar <- df_sp_elev |>
  column_to_rownames("taxon_name") |>
  filter(!is.na(UL) & Churdhar == 1) |>
  calc.presab(min.elev = 1600, max.elev = 3400) |>
  as.data.frame() |>
  mutate_all(~as.numeric(.x))

# df_all <- df_sp_elev |>
#   column_to_rownames("taxon_name") |>
#   filter(!is.na(UL)) |>
#   calc.presab(min.elev = 300, max.elev = 3400) |>
#   as.data.frame() |>
#   mutate_all(~as.numeric(.x))

## merge all matrices to list
plants <- list(
  Morni = df_morni,
  Chail = df_chail,
  Churdhar = df_churdhar
)

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

## run rarefaction analysis
out_inext <- iNEXT(
  x = plants, 
  q = 0, 
  datatype = "incidence_raw",
  endpoint = 20,
  knots = 40,
  se = TRUE,
  conf = 0.95,
  nboot = 100
)

## save asymptotic estimates of species diversity
out_inext$AsyEst |>
  write.csv("output/site_richness_rarefaction.csv", row.names = FALSE)

## bind and save the calculated species richness based on sample size
out_inext$iNextEst$size_based |>
  write.csv("output/site_rarefaction_size.csv", row.names = FALSE)

## bind and save the calculated species richness based on coverage
out_inext$iNextEst$coverage_based |>
  write.csv("output/site_rarefaction_coverage.csv", row.names = FALSE)
