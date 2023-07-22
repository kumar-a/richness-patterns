# Exploring Elevational Patterns of Plant Species Richness: Insights from Western Himalayas
**Authors:** [Abhishek Kumar](https://akumar.netlify.app/)<sup>#</sup>, [Meenu Patil](https://www.researchgate.net/profile/Meenu-Patil), [Pardeep Kumar](https://www.researchgate.net/profile/Pardeep-Kumar-22), [Anand Narain Singh](https://www.researchgate.net/profile/Anand-Singh-15)\*   
**Affiliation:** *Soil Ecosystem and Restoration Ecology Lab, Department of Botany, Panjab University, Chandigarh 160014, India*  
\*Corresponding author: dranand1212@gmail.com; ansingh@pu.ac.in  
<sup>#</sup>Maintainer: abhikumar.pu@gmail.com

## Directory structure

```
.
  |- data
    |- 0417447-210914110416597.zip
    |- band_mde.csv
    |- band_richness.csv
    |- chail_plants.csv
    |- chail.gpkg
    |- chur_plants.csv
    |- chur.gpkg
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
  |- apa6.csl
  |- calc_richness.R
  |- credit_author.csv
  |- extract_climate.R
  |- index.qmd
  |- README.md
  |- refs.bib
  |- richness-patterns.Rproj
```

## Description of files

| File name | Description |  
|-----------|-------------|
| [0417447-210914110416597.zip](/data/0417447-210914110416597.zip) | Species distribution dataset[^1] downloaded from  [GBIF](https://www.gbif.org/) via `rgbif` package |  
| [band_mde.csv](/data/band_mde.csv) | Data generated from 10,000 replications of mid-domain effect (MDE) null model[^2] |
| [band_richness.csv](/data/band_richness.csv) | Estimated species richness for 100-m elevational bands for each site |
| [chail_plants.csv](/data/chail_plants.csv) | Recorded plant species from literature survey for Chail Wildlife Sanctuary |
| [chail.gpkg](/data/chail.gpkg) | Digitised spatial boundary for Chail Wildlife Sanctuary |
| [chur_plants.csv](/data/chur_plants.csv) | Recorded plant species from literature survey for Churdhar Wildlife Sanctuary |
| [chur.gpkg](/data/chail.gpkg) | Digitised spatial boundary for Churdhar Wildlife Sanctuary |
| [ecs22945-sup-0004-datas1.csv](/data/ecs22945-sup-0004-datas1.csv) | Additional species distribution data from Rana, Price, & Qian ([2019](https://doi.org/10.1002/ecs2.2945))[^3] |
| [khol_hi_raitan.gpkg](/data/khol_hi_raitan.gpkg) | Digitised spatial boundary for Khol Hi Raitan Wildlife Sanctuary |
| [morni_plants.csv](/data/morni_plants.csv) | Recorded plant species from literature survey for Morni Hills |
| [morni.gpkg](/data/morni.gpkg) | Digitised spatial boundary for Morni Hills |
| [rana_elev_rang.csv](/data/rana_elev_rang.csv) | Species elevational ranges with botanical names standardised according to the *Plants of World Online* ([POWO](https://powo.science.kew.org/)) |
| [site_climate_wld.csv](/data/site_climate_wld.csv) | Climate dataset from WorldClim2 database[^4] processed for preparing the Walter-Leith Diagrams for study sites |
| [site_districts.gpkg](/data/site_districts.gpkg) | Spatial boundaries for Indian districts sharing the bounding box for selected study sites in the Himalayas |
| [site_elev.tif](/data/site_elev.tif) | Elevation raster data cropped for bounding box of the selected study sites |
| [site_plants_wcvp.csv](/data/site_plants_wcvp.csv) | Combined species check-list with botanical names standardised according to World Checklist of Vascular Plants (WCVP)[^5] |
| [site_plants.csv](/data/site_plants.csv) | All recorded plants from literature survey for all selected sites |
| [site_spec_elev.csv](/data/site_spec_elev.csv) | Finally prepared dataset for standardised unique species and their elevational ranges for selected study sites |
| [siwalik_states.gpkg](/data/siwalik_states.gpkg) | Spatial boundaries for north-western Indian States covering the Siwalik foothills of Himalayas |
| [apa6.csl](/apa6.csl) | Citation Style Language citation styles for American Psychological Association 6th edition |
| [calc_richness.R](/calc_richness.R) | `R` script with function used to calculate species richness from compiled dataset and MDE null model | 
| [credit_author.csv](/credit_author.csv) | Documentation of each authors' contribution in CRediT (Contributor Roles Taxonomy) author statement |
| [extract_climate.R](/extract_climate.R) | `R` script to extract climate data from WorldClim2 database and process to prepare Walter-Leith Diagrams for study sites |
| [index.qmd](/index.qmd) | Quarto markdown file with embedded `R` codes to reproduce the initial draft of manuscript |
| [refs.bib](/refs.bib) | Bibliographic entries for literature cited in the manuscript |
| [site_map.R](/site_map.R) | `R` script to prepare the map for study sites |

## Codebook for [band_mde.csv](/data/band_mde.csv)

| Column    | Description                                                       |
|-----------|-------------------------------------------------------------------|
| Elevation | Upper elevation of each 100-m elevational band in metres |
| mde_mean  | Mean predicted species richness from 10,000 runs of MDE null model |
| mde_sd    | Standard deviation for predicted species richness from 10,000 runs of MDE null model |
| mde_min   | Minimum predicted species richness from 10,000 runs of MDE null model |
| mde_max   | Maximum predicted species richness from 10,000 runs of MDE null model |
| site      | Name of site for which the MDE null model was run |

## Codebook for [band_richness.csv](/data/band_richness.csv)

| Column    | Description                                                       |
|-----------|-------------------------------------------------------------------|
| Elevation | Upper elevation of each 100-m elevational band in metres |
| Richness  | Estimated species richness for each 100-m elevational band for selected sites |
| site      | Name of site for which the elevational species richness was estimated |

## Codebook for [chail_plants.csv](/data/chail_plants.csv), [chur_plants.csv](/data/chur_plants.csv) and [morni_plants.csv](/data/morni_plants.csv)

| Column      | Description                                                       |
|-------------|-------------------------------------------------------------------|
| given_name  | Botanical name given in the published study |
| powo_taxa   | Accepted botanical name by *Plants of World Online* ([POWO](https://powo.science.kew.org/)) |
| powo_author | Accepted botanical name authorship by *Plants of World Online* ([POWO](https://powo.science.kew.org/)) |
| powo_dist   | Distribution status (Introduced vs. Native) of plant according to *Plants of World Online* ([POWO](https://powo.science.kew.org/)) |

All other columns refer to citation keys for studies identified through literature survey, i.e., Bhardwaj2017[^6], Champion1968[^7], eFI2022[^8], FOI2022[^9], Kumar2013[^10], Choudhary2007[^11], Choudhary2012[^12], Gupta1998[^13], Radha2019[^14], Subramani2014[^15], Thakur2021a[^16], Balkrishna2018a[^17], Balkrishna2018b[^18], Dhiman2020[^19], Dhiman2021[^20], Singh2014[^21]

## Codebook for [rana_elev_rang.csv](/data/rana_elev_rang.csv)

| Column    | Description                                                       |
|-----------|-------------------------------------------------------------------|
| verbatimScientificName | Botanical name given in dataset downloaded from GBIF |
| taxon_name | Accepted botanical names standardised according to World Checklist of Vascular Plants (WCVP) |
| taxon_authors | Accepted botanical authorship standardised according to World Checklist of Vascular Plants (WCVP) |
| LL | Lower elevational limit of the species in Himalayas |
| UL | Upper elevational limit of the species in Himalayas |
| IUCN | Status of plant species in IUCN Red List of Threatened Species |

## Codebook for [site_plants_wcvp.csv](/data/site_plants_wcvp.csv)

| Column    | Description                                                       |
|-----------|-------------------------------------------------------------------|
| taxon_name | Accepted botanical names standardised according to World Checklist of Vascular Plants (WCVP) |
| taxon_authors | Accepted botanical authorship standardised according to World Checklist of Vascular Plants (WCVP) |
| genus | Accepted botanical genus epithet standardised according to World Checklist of Vascular Plants (WCVP) |
| family | Accepted family of plant species standardised according to World Checklist of Vascular Plants (WCVP), which follows Angiosperm Phylogeny Group (APG) classification |
| powo_dist | Distribution status (Introduced vs. Native) of plant according to World Checklist of Vascular Plants (WCVP) |
| lifeform_description | Lifeform description of selected plant species according to World Checklist of Vascular Plants (WCVP) |
| climate_description | Climate description of selected plant species according to World Checklist of Vascular Plants (WCVP) |
| Morni | Short for Morni Hills |
| Chail | Short for Chail Wildlife Sanctuary |
| Churdhar | Short for Churdhar Wildlife Sanctuary |

## References

[^1]: Rana, S. K., & Rawat, G. S. (2019). *Database of vascular plants of Himalaya*. Version 1.6. Dehradun: Wildlife Institute of India. <https://doi.org/10.15468/zdeuix>

[^2]: Colwell, R. K., & Lees, D. C. (2000). The mid-domain effect: Geometric constraints on the geography of species richness. *Trends in Ecology & Evolution, 15*(2), 70–76. <https://doi.org/10.1016/s0169-5347(99)01767-x>

[^3]: Rana, S. K., Price, T. D., & Qian, H. (2019). Plant species richness across the Himalaya driven by evolutionary history and current climate. *Ecosphere, 10*(11), e02945. <https://doi.org/10.1002/ecs2.2945>

[^4]: Fick, S. E., & Hijmans, R. J. (2017). WorldClim 2: New 1-km spatial resolution climate surfaces for global land areas. *International Journal of Climatology, 37*(12), 4302–4315. <https://doi.org/10.1002/joc.5086>

[^5]: Govaerts, R., Lughadha, E. N., Black, N., Turner, R., & Paton, A. (2021). The World Checklist of Vascular Plants, a continuously updated resource for exploring global plant diversity. *Scientific Data, 8*(1), 215. <https://doi.org/10.1038/s41597-021-00997-6>

[^6]: Bhardwaj, A. (2017). *Study on dynamics of plant bioresources in Chail wildlife sanctuary of Himachal Pradesh* (PhD thesis, Forest Research Institute (Deemed) University; p. 342). Forest Research Institute (Deemed) University, Dehradun. Retrieved from <http://hdl.handle.net/10603/175719>

[^7]: Champion, H. G., & Seth, S. K. (1968). *A revised survey of the forest types of India* (p. 404). Delhi: Government of India.

[^8]: eFI. (2022). *eFlora of India: Database of plants of Indian subcontinent*. Retrieved from <https://efloraofindia.com/>

[^9]: FOI. (2022). *Flowers of India*. Retrieved from <http://www.flowersofindia.net/>

[^10]: Kumar, R. (2013). *Studies on plant biodiversity of Chail wildlife sanctuary in Himachal Pradesh* (Master’s thesis, Dr Yashwant Singh Parmar University of Horticulture and Forestry; p. 119). Dr Yashwant Singh Parmar University of Horticulture and Forestry, Solan. Retrieved from <http://krishikosh.egranth.ac.in/handle/1/91126>

[^11]: Choudhary, A. K., Punam, Sharma, P. K., & Chandel, S. (2007). Study on the physiography and biodiversity of Churdhar wildlife sanctuary of Himachal Himalayas, India. *Tigerpaper, 34*, 27–32.

[^12]: Choudhary, R. K., & Lee, J. (2012). A floristic reconnaissance of Churdhar wildlife sanctuary of Himachal Pradesh, India. *Manthan, 13*, 2–12.

[^13]: Gupta, H. (1998). *Comparative studies on the medicinal and aromatic flora of Churdhar and Rohtang areas of Himachal Pradesh* (Master’s thesis, Dr Yashwant Singh Parmar University of Horticulture and Forestry; p. 228). Dr Yashwant Singh Parmar University of Horticulture and Forestry, Solan. Retrieved from <http://krishikosh.egranth.ac.in/handle/1/5810135063>

[^14]: Radha, Puri, S., Chandel, K., Pundir, A., Thakur, M. S., Chauhan, B., … Kumar, S. (2019). Diversity of ethnomedicinal plants in Churdhar wildlife sanctuary of district Sirmour of Himachal Pradesh, India. *Journal of Applied Pharmaceutical Science, 9*(11), 48–53. <https://doi.org/10.7324/japs.2019.91106>

[^15]: Subramani, S. P., Kapoor, K. S., & Goraya, G. S. (2014). Additions to the floral wealth of Sirmaur district, Himachal Pradesh from Churdhar wildlife sanctuary. *Journal of Threatened Taxa, 6*(11), 6427–6452. <https://doi.org/10.11609/jott.o2845.6427-52>

[^16]: Thakur, U., Bisht, N. S., Kumar, M., & Kumar, A. (2021). Influence of altitude on diversity and distribution pattern of trees in Himalayan temperate forests of Churdhar wildlife sanctuary, India. *Water, Air, & Soil Pollution, 232*, 205. <https://doi.org/10.1007/s11270-021-05162-8>

[^17]: Balkrishna, A., Srivastava, A., Shukla, B., Mishra, R., & Joshi, B. (2018). Medicinal plants of Morni Hills, Shivalik Range, Panchkula, Haryana. *Journal of Non-Timber Forest Products, 25*(1), 1–14. <https://doi.org/10.54207/bsmps2000-2018-ir3j0n>

[^18]: Balkrishna, A., Joshi, B., Srivastava, A., & Shukla, B. (2018). Phyto-resources of Morni Hills, Panchkula, Haryana. *Journal of Non-Timber Forest Products, 25*(2), 91–98. <https://doi.org/10.54207/bsmps2000-2018-p430i5>

[^19]: Dhiman, H., Saharan, H., & Jakhar, S. (2020). Floristic diversity assessment and vegetation analysis of the upper altitudinal ranges of Morni Hills, Panchkula, Haryana, India. *Asian Journal of Conservation Biology, 9*(1), 134–142.

[^20]: Dhiman, H., Saharan, H., & Jakhar, S. (2021). Study of invasive plants in tropical dry deciduous forests – biological spectrum, phenology, and diversity. *Forestry Studies, 74*(1), 58–71. <https://doi.org/10.2478/fsmu-2021-0004>

[^21]: Singh, N., & Vashistha, B. D. (2014). Flowering plant diversity and ethnobotany of Morni Hills, Siwalik Range, Haryana, India. *International Journal of Pharma and Bio Sciences, 5*(2), B214–B222.
