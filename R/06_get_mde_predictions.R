# Author: Abhishek Kumar
# Affiliation: Panjab University, Chandigarh
# Email: abhikumar.pu@gmail.com
# Date: 19 Dec 2023
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

## load required packages
library(tidyverse)      ## general data manipulation

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

## function to generate richness from random species

null.richness <- function(n.species, min.elev, max.elev, band.size = 100){
  
  ## generate random elevational limits for n.species
  elev.lims <- matrix(
    sample(min.elev:max.elev, size = n.species * 2, replace = TRUE),
    ncol = 2
  )
  colnames(elev.lims) <- c("LL", "UL")
  
  ## arrange range limits to have lower value in LL and higher in UL
  
  ## new matrix to collect sorted ranges
  range.mat <- matrix(nrow = n.species, ncol = 2)
  colnames(range.mat) <- c("LL", "UL")
  
  ## refill random ranges so that lower value in LL and higher in UL
  range.mat[, "LL"] <- ifelse(
    test = elev.lims[, "LL"] >= elev.lims[, "UL"],
    yes = elev.lims[, "UL"], 
    no = elev.lims[, "LL"]
  )
  range.mat[, "UL"] <- ifelse(
    test = elev.lims[, "UL"] <= elev.lims[, "LL"],
    yes = elev.lims[, "LL"], 
    no = elev.lims[, "UL"]
  )
  
  ## calculate richness 
  
  ## elevational bands for richness
  elev.bands <- seq(min.elev + band.size, max.elev, band.size)
  
  ## ----- create presence absence matrix
  
  ## empty data matrix to collect filled range sizes
  presab <- matrix(ncol = length(elev.bands), nrow = n.species)
  colnames(presab) <- elev.bands
  
  ## fill range size values if species present otherwise NA
  for(j in 1:nrow(presab)){
    
    ## add results to a matrix
    presab[j, ] <- elev.bands >= range.mat[j, "LL"] & 
      (elev.bands - band.size) <= range.mat[j, "UL"]
  }
  
  ## calculate richness by adding columns
  richness <- presab |> colSums()
  
  ## return richness
  return(richness)
}

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

## function to iterate random richness

rep.null.rich <- function(n.iter, n.species, min.elev, max.elev, n.steps = 100) {
  
  elev.bands <- seq(min.elev + n.steps, max.elev, n.steps)
  
  ## matrix to collect results
  out <- matrix(ncol = length(elev.bands), nrow = n.iter)
  colnames(out) <- elev.bands
  
  ## fill matrix by iterations
  for (k in 1:n.iter) {
    out[k, ] <- null.richness(n.species, min.elev, max.elev, n.steps)
  }
  
  ## calculate summary measures
  df <- data.frame(
    mde_mean = apply(out, 2, mean),
    mde_sd   = apply(out, 2, sd),
    mde_min  = apply(out, 2, min),
    mde_max  = apply(out, 2, max)
  ) |>
    tibble::rownames_to_column("elevation")
  
  ## return the results
  return(df)
}

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

## calculate null elevational richness for each site

set.seed(261294) ## reproducibility

system.time(
  mde_morni <- rep.null.rich(n.iter = 1e4, n.species = 568, 
                             min.elev = 300, max.elev = 1300) |>
    mutate(site = "Morni")
)

system.time(
  mde_chail <- rep.null.rich(n.iter = 1e4, n.species = 377,
                             min.elev = 900, max.elev = 2100) |>
    mutate(site = "Chail")
)

system.time(
  mde_chur <- rep.null.rich(n.iter = 1e4, n.species = 561,
                            min.elev = 1600, max.elev = 3400) |>
    mutate(site = "Churdhar")
)

system.time(
  mde_all <- rep.null.rich(n.iter = 1e4, n.species = 1159,
                           min.elev = 300, max.elev = 3400) |>
    mutate(site = "All")
)

## bind and save the results
bind_rows(mde_morni, mde_chail, mde_chur, mde_all) |>
  mutate(elevation = as.numeric(elevation)) |>
  write.csv(file = "output/band_mde.csv", row.names = F)
