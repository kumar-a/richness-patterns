# Author: Abhishek Kumar
# Affiliation: Panjab University, Chandigarh
# Email: abhikumar.pu@gmail.com
# Date: 19 Dec 2023
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

## load required packages
library(rWCVP)          ## plant name standardisation with WCVP
library(tidyverse)      ## general data manipulation

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

## load raw recorded plant species for each site
mhp <- read.csv("data/morni_plants.csv") |>
  select(powo_taxa, powo_author, powo_dist) |>
  distinct() |>
  mutate(Site = "Morni")

clp <- read.csv("data/chail_plants.csv") |>
  select(powo_taxa, powo_author, powo_dist) |>
  distinct() |>
  mutate(Site = "Chail")

crp <- read.csv("data/churdhar_plants.csv") |>
  select(powo_taxa, powo_author, powo_dist) |>
  distinct() |>
  mutate(Site = "Churdhar")

## exclude plant species with distribution outside study sites
site_plants <- bind_rows(mhp, clp, crp) |>
  mutate(Presence = 1) |>
  pivot_wider(names_from = "Site", values_from = "Presence", values_fill = 0) |>
  filter(!is.na(powo_dist))

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

## match with WCVP (version 10)
taxa_match <- wcvp_match_names(
  site_plants, name_col = "powo_taxa", author_col = "powo_author"
)

## save WCVP standardised plant names
taxa_match |>
  left_join(
    rWCVPdata::wcvp_names, by = c("wcvp_accepted_id" = "plant_name_id")
  ) |>
  select(taxon_name, taxon_authors, genus, family,
         powo_dist, lifeform_description, climate_description,
         Morni, Chail, Churdhar) |>
  distinct() |>
  mutate(powo_dist = ifelse(powo_dist == "Doubtful", "Introduced", powo_dist)) |>
  readr::write_excel_csv("output/site_plants_wcvp.csv")

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
