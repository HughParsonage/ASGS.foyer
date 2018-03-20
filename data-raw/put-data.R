library(ASGS)

# http://www.abs.gov.au/AUSSTATS/abs@.nsf/DetailsPage/1270.0.55.001July%202016?OpenDocument
setwd("~/../Downloads/1270055001_ste_2016_aust_shape/")
STE_2016 <- readOGR(".", layer = "STE_2016_AUST")
# mapshaper -o precision=0.0001 format=topojson
library(geojsonio)
STE_2016_simple <- geojsonio::geojson_read("~/../Downloads/STE_2016_AUST (1).json", what = "sp")

devtools::use_data(STE_2016_simple, compress = "xz")


