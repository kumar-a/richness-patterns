# Author: Abhishek Kumar
# Affiliation: Panjab University, Chandigarh
# Email: abhikumar.pu@gmail.com
# Date: 19 Dec 2023
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

## load required packages
library(rgbif)          ## access GBIF datasets
library(rWCVP)          ## plant name standardisation with WCVP
library(tidyverse)      ## general data manipulation

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

## download dataset from gbif using the key
rana_gbif <- occ_download_get(
  key = "0417447-210914110416597", path = "output/", overwrite = TRUE
) |>
  occ_download_import("output/", na.strings = c("", NA))

# read downloaded file
rana_gbif_hp <- as.download("output/0417447-210914110416597.zip") |>
  occ_download_import(na.strings = c("", NA)) |>
  ## select columns that are further used
  select(stateProvince, verbatimScientificName,
         elevationAccuracy, elevation, iucnRedListCategory) |>
  filter(stateProvince == "Himachal Pradesh")

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

## match names from Rana2017 to WCVP
rana_match <- rana_gbif_hp |>
  separate(verbatimScientificName,
           into = c("rana_genus", "rana_species", "rana_authors"),
            sep = " ", extra = "merge") |>
  unite(col = "rana_taxon", rana_genus, rana_species, sep = " ") |>
  distinct(rana_taxon, .keep_all = TRUE) |>
  ## this step takes time
  wcvp_match_names(name_col = "rana_taxon", author_col = "rana_authors")

## join WCVP accepted names and other details
rana_match_wcvp <- rana_match |>
  left_join(
    rWCVPdata::wcvp_names, by = c("wcvp_accepted_id" = "plant_name_id")
  ) |>
  select(
    rana_taxon, rana_authors, taxon_name, taxon_authors,
    elevationAccuracy, elevation, iucnRedListCategory
  ) |>
  unite("verbatimScientificName", rana_taxon, rana_authors, sep = " ") |>
  rename("LL" = elevationAccuracy, "UL" = elevation,
         "IUCN" = iucnRedListCategory)

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

## join elevation range with species checklist
site_spec_elev <- read.csv("output/site_plants_wcvp.csv") |>
  select("taxon_name", "taxon_authors") |>
  left_join(rana_match_wcvp)

## load supplementary data from Rana2019
rana2019 <- read.csv("data/ecs22945-sup-0004-datas1.csv") |>
   mutate(
     Species = str_replace(Species, pattern = "_", replacement = " ")
   ) |>
  filter(!is.na(HPLL) & !is.na(HPUL)) |>
  select(Species, HPLL, HPUL)

## add elevational ranges
site_spec_elev_rana2019 <- site_spec_elev |>
  filter(is.na(LL) & is.na(UL)) |>
  select(taxon_name, taxon_authors) |>
  left_join(rana2019, by = join_by("taxon_name" == "Species")) |>
  filter(!is.na(HPLL) & !is.na(HPUL)) |>
  rename("LL" = HPLL, "UL" = HPUL)

## merge two datasets and write to local disk
site_spec_elev |>
  ## filter plant species without elevational range
  filter(!is.na(LL) & !is.na(UL)) |>
  ## add elevation range from Rana2019
  bind_rows(site_spec_elev_rana2019) |>
  ## consider min LL and max UL for duplicates
  group_by(taxon_name) |>
  summarise(LL = min(LL), UL = max(UL)) |>
  ## adjust elevational limits to correspond full elevational gradient
  mutate(LL = ifelse(test = LL < 300,  yes = 300,  no = LL),
         UL = ifelse(test = UL < 400,  yes = 400,  no = UL),
         UL = ifelse(test = UL > 3600, yes = 3600, no = UL)) |>
  ## save the prepared data
  write.csv("output/site_spec_elev.csv", row.names = FALSE)
