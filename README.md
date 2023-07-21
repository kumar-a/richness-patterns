# Exploring Elevational Patterns of Plant Species Richness: Insights from Western Himalayas
**Authors:** [Abhishek Kumar](https://akumar.netlify.app/)[^\#], [Meenu Patil](https://www.researchgate.net/profile/Meenu-Patil), [Pardeep Kumar](https://www.researchgate.net/profile/Pardeep-Kumar-22), [Anand Narain Singh](https://www.researchgate.net/profile/Anand-Singh-15)[^\*]  
**Affiliation:** *Soil Ecosystem and Restoration Ecology Lab, Department of Botany, Panjab University, Chandigarh 160014, India*  
[^\*]: Corresponding author: dranand1212@gmail.com; ansingh@pu.ac.in  
[^\#]: Maintainer: abhikumar.pu@gmail.com

## Direct structure

```
.
  |- apa6.csl
  |- calc_richness.R
  |- credit_author.csv
  |- data
    |- 0417447-210914110416597.zip
    |- band_mde.csv
    |- band_richness.csv
    |- chail_plants.csv
    |- chail.gpkg
    |- chur_plants.csv
    |- chur.gpkg
    |- churdhar_plants_powo.csv
    |- ecs22945-sup-0004-datas1.csv
    |- khol_hi_raitan.gpkg
    |- morni_plants.csv
    |- morni.gpkg
    |- rana_elev_rang.csv
    |- site_climate_wld.csv
    |- site_districts.gpkg
    |- site_elev.tif
    |- site_plants_wcvp.csv
    |- site_plants.csv
    |- site_spec_elev.csv
    |- siwalik_states.gpkg
  |- figs
    |- all_climate.pdf
    |- chail_climate.pdf
    |- chur_climate.pdf
    |- combined_site_map
  |- index.qmd
  |- README.md
  |- refs.bib
  |- richness-patterns.Rproj
```

## Description of files

| File name | Description |  
|-----------|-------------|
| [apa6.csl](/apa6.csl) | Citation Style Language citation styles for American Psychological Association 6th edition |
| [credit_author.csv](/credit_author.csv) | Documentation of each authors' contribution in CRediT (Contributor Roles Taxonomy) author statement |
| [0417447-210914110416597.zip](/data/0417447-210914110416597.zip) | Dataset downloaded from  [GBIF](https://www.gbif.org/) via `rgbif` package |  
| [band_mde.csv](/data/band_mde.csv) | Data generated from 10,000 replications of mid-domain effec (MDE) null model |
| [band_richness.csv](/data/band_richness.csv) | Estimated species richness for 100-m elevational bands for each site |
| [uniqueref.ris](/publications/2023-patil/data/bib/uniqueref.ris)	                     | Unique records after de-duplication |
| [wos1.bib](/publications/2023-patil/data/bib/wos1.bib)	                             | Bibliographic records (1-500) obtained from Web of Science Core Collection using the search string: *(mycorrhiza\* OR ectomycorrhiza\* OR "saprotrophic fungi" OR plant-fung\*) AND (litter OR "litter decay" OR (litter AND decompos\*) OR decomposition OR "nutrient acquisition") AND (forest)* |
| [wos2.bib](/publications/2023-patil/data/bib/wos2.bib)	                             | Bibliographic records (501-1,000) obtained from Web of Science Core Collection using the search string: *(mycorrhiza\* OR ectomycorrhiza\* OR "saprotrophic fungi" OR plant-fung\*) AND (litter OR "litter decay" OR (litter AND decompos\*) OR decomposition OR "nutrient acquisition") AND (forest)* |
| [wos3.bib](/publications/2023-patil/data/bib/wos3.bib)	                             | Bibliographic records (1,001-1,293) obtained from Web of Science Core Collection using the search string: *(mycorrhiza\* OR ectomycorrhiza\* OR "saprotrophic fungi" OR plant-fung\*) AND (litter OR "litter decay" OR (litter AND decompos\*) OR decomposition OR "nutrient acquisition") AND (forest)* |
| [data/article_screening.gv](/publications/2023-patil/data/article_screening.gv)        | [Graphviz](https://graphviz.org/) codes for reproducing [fig1.svg](/publications/2023-patil/data/fig1.svg) |
| [fig1.svg](/publications/2023-patil/data/fig1.svg)                                     | Schematic flow diagram for literature search, screening and inclusion process |
| [mass_remaining.csv](/publications/2023-patil/data/mass_remaining.csv)                 | Extracted raw mass remaining data from eligible studies (See codebook for details) |
| [phylo.tre](/publications/2023-patil/data/phylo.tre)                                   | Phylogenetic tree for plant species included in eligible studies |
| [raw_entry1991.csv](/publications/2023-patil/data/raw_entry1991.csv)                   | Extracted raw data for litter decomposition rates from Entry et al 1991 | 
| [species_classification.csv](/publications/2023-patil/data/species_classification.csv) | Taxonomic classification of plant species included |
| [study_metadata.csv](/publications/2023-patil/data/study_metadata.csv)                 | Study characteristics such as number of experiments, duration of experiment, mycorrhizal type, forest type, etc. |
| [index.qmd](/publications/2023-patil/index.qmd)	                 | Quarto markdown file with embedded `R` codes to reproduce the initial draft of manuscript |
| [refs.bib](/publications/2023-patil/refs.bib)                                          | Bibliographic entries for literature cited in the manuscript |

## Codebook for [band_mde.csv](/data/band_mde.csv)

| Column  | Description | Units  |
|---------|-------------|--------|
| id      | ID assigned to each observation in the dataset | NA |
| author  | Authors of the study (in *in-text* citation style) | NA |
| year    | Year in which the study was published | NA |
| species | Botanical name of the plant species to which the litter belongs | NA |
| time    | Time interval at which litter weight was estimated | years |
| mean_ab | Mean value of litter weight in control (absence of mycorrhizal fungi) | %<sup>**a**</sup> |
| se_ab1  | Upper bound of standard error (mean + SE) associated with litter weight in control (absence of mycorrhizal fungi) | % |
| se_ab2  | Lower bound of standard error (mean - SE) associated with litter weight in control (absence of mycorrhizal fungi) | % |
| mean_pr | Mean value of litter weight in experimental (presence of mycorrhizal fungi) | % |
| se_pr1  | Upper bound of standard error (mean + SE) associated with litter weight in experimental (presence of mycorrhizal fungi) | % |
| se_pr2  | Lower bound of standard error (mean - SE) associated with litter weight in experimental (presence of mycorrhizal fungi) | % |

<sup>**a**</sup> % of initial litter weight

## Codebook for [band_richness.csv](/data/band_richness.csv)

| Column  | Description | Units  |
|---------|-------------|--------|
| id      | ID assigned to each observation in the dataset | NA |
| author  | Authors of the study (in *in-text* citation style) | NA |
| year    | Year in which the study was published | NA |
| species | Botanical name of the plant species to which the litter belongs | NA |
| n       | Total number of replicates used | NA |
| w0_g    | Inital weight of litter in grams | grams |
| t_yr    | Time duration of experiment | years |
| k_pr    | Litter decay constant in experimental (presence of mycorrhizal fungi) | year<sup>-1</sup> |
| sd_pr   | Standard deviation associated with litter decay constant in experimental (presence of mycorrhizal fungi) | year<sup>-1</sup> |
| k_ab    | Litter decay constant in control (absence of mycorrhizal fungi) | year<sup>-1</sup> |
| sd_ab   | Standard deviation associated with litter decay constant in control (absence of mycorrhizal fungi) | year<sup>-1</sup> |

## References

