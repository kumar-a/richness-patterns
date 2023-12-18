# Author: Abhishek Kumar
# Affiliation: Panjab University, Chandigarh
# Email: abhikumar.pu@gmail.com

library(tidyverse)

## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## ----- function to estimate sensitivity to number of species -----
## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

## data: a data frame of species (taxon_name) with lower (LL) and upper (UL) elevation limits
## min.elev and max.elev: minimum and maximum elevation for bands
## band.size: size of each elevational band, default to 100
## n.species: a vector of number of species
## if n.species < sample size, random sampling from data

esr.species <- function(data, min.elev, max.elev, band.size = 100, 
                        sp.steps = seq(-200, 200, 50)){
  
  n.species <- nrow(data) + sp.steps
  
  ## elevational bands for richness
  elev.bands <- seq(min.elev + band.size, max.elev, band.size)
  
  ## create an empty data list to collect results
  datalist <- list()
  
  ## for loop for number of different species
  for(i in 1:length(n.species)){
    
    ## prepare data for species ranges
    if (n.species[i] > nrow(data)) {
      
      ## number of additional species
      new.sp <- n.species[i] - nrow(data)
      
      ## generate random elevational limits for new species (new.sp)
      elev.lims <- matrix(
        data = sample(min.elev:max.elev, size = new.sp * 2, replace = TRUE),
        ncol = 2
      )
      colnames(elev.lims) <- c("LL", "UL")
      
      ## new matrix to collect sorted range limits
      new.mat <- matrix(nrow = new.sp, ncol = 2)
      colnames(new.mat) <- c("LL", "UL")
      rownames(new.mat) <- paste0("sp", 1:new.sp)
      
      ## refill random ranges so that lower value in LL and higher in UL
      new.mat[, "LL"] <- ifelse(
        test = elev.lims[, "LL"] >= elev.lims[, "UL"], 
        yes = elev.lims[, "UL"], 
        no = elev.lims[, "LL"]
      )
      new.mat[, "UL"] <- ifelse(
        test = elev.lims[, "UL"] <= elev.lims[, "LL"],
        yes = elev.lims[, "LL"], 
        no = elev.lims[, "UL"]
      )
      
      ## add new species with elevation ranges to observed data
      df <- bind_rows(
        data,
        as.data.frame(new.mat) |> rownames_to_column("taxon_name")
      )
      
    } else {
      ## sub sample data
      df <- data |> sample_n(n.species[i])
    }
    
    ## create empty data matrix
    out <- matrix(ncol = length(elev.bands), nrow = nrow(df))
    
    # for loop for all species
    for(j in 1:nrow(df)){
      
      # create species presence-absence at elevations
      # add results to a matrix
      out[j, ] <- elev.bands >= df[j, "LL"] &
        (elev.bands - band.size) <= df[j, "UL"]
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
      mutate(elevation = as.numeric(elevation),
             species = n.species[i])
    
    datalist[[i]] <- richness
    
  }
  
  ## return richness
  do.call(bind_rows, datalist)
  
}

## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## calculate elevational richness for different sample size for each site -----
## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

set.seed(261294)

## adjusted richness for available explanatory variables
esr_morni <- read.csv("output/site_plants_wcvp.csv") |>
  left_join(read.csv("output/site_spec_elev.csv"),
            by = join_by(taxon_name, taxon_authors)) |>
  filter(!is.na(UL) & Morni == 1) |>
  mutate(UL = ifelse(test = UL > 1300, yes = 1300, no = UL)) |>
  esr.species(300, 1300) |>
  mutate(site = "Morni")

esr_chail <- read.csv("output/site_plants_wcvp.csv") |>
  left_join(read.csv("output/site_spec_elev.csv"),
            by = join_by(taxon_name, taxon_authors)) |>
  filter(!is.na(UL) & Chail == 1) |>
  mutate(LL = ifelse(test = LL < 900, yes = 900, no = LL),
         LL = ifelse(test = LL > 2000, yes = 2000, no = LL),
         UL = ifelse(test = UL < 1000, yes = 1000, no = UL),
         UL = ifelse(test = UL > 2100, yes = 2100, no = UL)) |>
  esr.species(900, 2100) |>
  mutate(site = "Chail")

esr_churdhar <- read.csv("output/site_plants_wcvp.csv") |>
  left_join(read.csv("output/site_spec_elev.csv"),
            by = join_by(taxon_name, taxon_authors)) |>
  filter(!is.na(UL) & Churdhar == 1) |>
  mutate(LL = ifelse(test = LL < 1600, yes = 1600, no = LL),
         UL = ifelse(test = UL < 1700, yes = 1700, no = UL)) |>
  esr.species(1600, 3400) |>
  mutate(site = "Churdhar")

esr_all <- read.csv("output/site_plants_wcvp.csv") |>
  left_join(read.csv("output/site_spec_elev.csv"),
            by = join_by(taxon_name, taxon_authors)) |>
  filter(!is.na(UL)) |>
  distinct(taxon_name, .keep_all = T) |>
  esr.species(300, 3400) |>
  mutate(site = "All")

bind_rows(esr_morni, esr_chail, esr_churdhar, esr_all) |>
  write.csv("output/species_sensitivity_richness.csv", row.names = FALSE)

## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## calculate predicted richness (MDE) for different sample size for each site -----
## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

mde.richness <- function(n.species, min.elev, max.elev, band.size = 100){
  
  ## create an empty data list to collect results
  datalist <- list()
  
  ## for loop for number of different species
  for(i in 1:length(n.species)){
    
    ## generate random elevational limits for n.species
    elev.lims <- matrix(
      sample(min.elev:max.elev, size = n.species[i] * 2, replace = TRUE),
      ncol = 2
    )
    colnames(elev.lims) <- c("LL", "UL")
    
    ## new matrix to collect sorted ranges
    range.mat <- matrix(nrow = n.species[i], ncol = 2)
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
    
    ## elevational bands for richness
    elev.bands <- seq(min.elev + band.size, max.elev, band.size)
    
    ## ----- create presence absence matrix
    
    ## empty data matrix to collect filled range sizes
    presab <- matrix(ncol = length(elev.bands), nrow = n.species[i])
    colnames(presab) <- elev.bands
    
    ## fill range size values if species present otherwise NA
    for(j in 1:nrow(presab)){
      
      ## add results to a matrix
      presab[j, ] <- elev.bands  >= range.mat[j, "LL"] & 
        (elev.bands - band.size) <= range.mat[j, "UL"]
    }
    
    ## sum species at each elevation zone and convert to data frame
    mde_richness <- presab |> colSums() |> as.data.frame() |> 
      ## add elevation column from row names
      rownames_to_column("elevation") |> 
      ## rename column name to Species
      rename("mde" = "colSums(presab)") |>
      ## convert elevation to numeric
      mutate(elevation = as.numeric(elevation),
             species = n.species[i])
    
    datalist[[i]] <- mde_richness
    
  }
  
  ## return richness
  do.call(bind_rows, datalist)
}

## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## calculate predicted richness (MDE) for different sample size for each site -----
## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

set.seed(261294)

## adjusted richness for available explanatory variables
mde_morni <- mde.richness(n.species = 568 + seq(-200, 200, 50), 300, 1300) |>
  mutate(site = "Morni")

mde_chail <- mde.richness(n.species = 377 + seq(-200, 200, 50), 900, 2100) |>
  mutate(site = "Chail")

mde_churdhar <- mde.richness(n.species = 561 + seq(-200, 200, 50), 1600, 3400) |>
  mutate(site = "Churdhar")

mde_all <- mde.richness(n.species = 1159 + seq(-200, 200, 50), 300, 3400) |>
  mutate(site = "All")

bind_rows(mde_morni, mde_chail, mde_churdhar, mde_all) |>
  write.csv("output/species_sensitivity_mde.csv", row.names = FALSE)
