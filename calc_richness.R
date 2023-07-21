## Author: Abhishek Kumar
## Email: abhikumar.pu@gmail.com

library(tidyverse)

#################################################################
## ----- function to calculate richness from range limits -----
#################################################################

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
    rownames_to_column("Elevation") |> 
    ## rename column name to Species
    rename("Richness" = "colSums(out)") |>
    ## convert elevation to numeric
    mutate(Elevation = as.numeric(Elevation))
  
  ## return richness
  return(richness)
}

##################################################################
## ----- function to generate richness from random species -----
##################################################################

null.richness <- function(n.species, min.elev, max.elev, band.size = 100){
  
  ## generate random elevational limits for n.species
  elev.lims <- sample(min.elev:max.elev, size = n.species * 2, 
                      replace = TRUE) |> matrix(ncol = 2)
  colnames(elev.lims) <- c("LL", "UL")
  
  ## arrange range limits to have lower value in LL and higher in UL
  
  ## new matrix to collect sorted ranges
  range.mat <- matrix(nrow = n.species, ncol = 2)
  colnames(range.mat) <- c("LL", "UL")
  ## refill random ranges so that lower value in LL and higher in UL
  range.mat[, "LL"] <- ifelse(elev.lims[, "LL"] >= elev.lims[, "UL"],
                              yes = elev.lims[, "UL"], no = elev.lims[, "LL"])
  range.mat[, "UL"] <- ifelse(elev.lims[, "UL"] <= elev.lims[, "LL"],
                              yes = elev.lims[, "LL"], no = elev.lims[, "UL"])
  
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

###############################################################
## ----- function to iterate random richness -----
###############################################################

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
    tibble::rownames_to_column("Elevation")
  
  ## return the results
  return(df)
}

#########################################################################
## ----- calculate richness for elevational richness for each site -----
#########################################################################

## adjusted richness for available explanatory variables
esr_morni <- read.csv("data/site_plants_wcvp.csv") |>
  left_join(read.csv("data/site_spec_elev.csv"),
            by = join_by(taxon_name, taxon_authors)) |>
  filter(!is.na(UL) & Morni == 1) |>
  mutate(UL = ifelse(test = UL > 1300, yes = 1300, no = UL)) |>
  calc.richness(LL = "LL", UL = "UL", 300, 1300) |>
  mutate(site = "Morni")

esr_chail <- read.csv("data/site_plants_wcvp.csv") |>
  left_join(read.csv("data/site_spec_elev.csv"),
            by = join_by(taxon_name, taxon_authors)) |>
  filter(!is.na(UL) & Chail == 1) |>
  mutate(LL = ifelse(test = LL < 900, yes = 900, no = LL),
         LL = ifelse(test = LL > 2000, yes = 2000, no = LL),
         UL = ifelse(test = UL < 1000, yes = 1000, no = UL),
         UL = ifelse(test = UL > 2100, yes = 2100, no = UL)) |>
  calc.richness(LL = "LL", UL = "UL", 900, 2100) |>
  mutate(site = "Chail")

esr_churdhar <- read.csv("data/site_plants_wcvp.csv") |>
  left_join(read.csv("data/site_spec_elev.csv"),
            by = join_by(taxon_name, taxon_authors)) |>
  filter(!is.na(UL) & Churdhar == 1) |>
  mutate(LL = ifelse(test = LL < 1600, yes = 1600, no = LL),
         UL = ifelse(test = UL < 1700, yes = 1700, no = UL)) |>
  calc.richness(LL = "LL", UL = "UL", 1600, 3400) |>
  mutate(site = "Churdhar")

esr_all <- read.csv("data/site_plants_wcvp.csv") |>
  left_join(read.csv("data/site_spec_elev.csv"),
            by = join_by(taxon_name, taxon_authors)) |>
  filter(!is.na(UL)) |>
  distinct(taxon_name, .keep_all = T) |>
  calc.richness(LL = "LL", UL = "UL", 300, 3400) |>
  mutate(site = "All")

bind_rows(esr_morni, esr_chail, esr_churdhar, esr_all) |>
  write.csv("data/band_richness.csv", row.names = FALSE)

##################################################################
## ----- calculate null elevational richness for each site ----- 
##################################################################

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
  mutate(Elevation = as.numeric(Elevation)) |>
  write.csv(file = "data/band_mde.csv", row.names = F)


