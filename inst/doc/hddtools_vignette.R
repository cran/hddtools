## ----init, echo=FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  comment = "#>",
  collapse = TRUE,
  warning = FALSE,
  message = FALSE,
  cache = FALSE,
  eval = FALSE
)

## ----installation1------------------------------------------------------------
#  install.packages("hddtools")

## ----installation2------------------------------------------------------------
#  devtools::install_github("ropensci/hddtools")

## ----loading, eval = TRUE-----------------------------------------------------
library("hddtools")

## ----dplyr, eval = TRUE-------------------------------------------------------
library("dplyr")

## ----KGClimateClass1, eval = TRUE---------------------------------------------
# Define a bounding box
areaBox <- raster::extent(-10, 5, 48, 62)

# Extract climate zones from Peel's map:
KGClimateClass(areaBox = areaBox, updatedBy = "Peel")

## ----KGClimateClass2, eval = TRUE---------------------------------------------
# Extract climate zones from Kottek's map:
KGClimateClass(areaBox = areaBox, updatedBy = "Kottek")

## ----catalogueGRDC1, eval = FALSE---------------------------------------------
#  # GRDC full catalogue
#  GRDC_catalogue <- catalogueGRDC()

## ----catalogueGRDC2, eval = FALSE---------------------------------------------
#  # Filter GRDC catalogue based on a country code
#  GRDC_catalogue %>%
#    filter(country == "IT")
#  
#  # Filter GRDC catalogue based on rivername
#  GRDC_catalogue %>%
#    filter(river == "PO, FIUME")
#  
#  # Filter GRDC catalogue based on which daily data is available since 2000
#  GRDC_catalogue %>%
#    filter(d_start >= 2000)
#  
#  # Filter the catalogue based on a geographical bounding box
#  GRDC_catalogue %>%
#    filter(between(x = long, left = -10, right = 5),
#           between(x = lat, left = 48, right = 62))
#  
#  # Combine filtering criteria
#  GRDC_catalogue %>%
#    filter(between(x = long, left = -10, right = 5),
#           between(x = lat, left = 48, right = 62),
#           d_start >= 2000,
#           area > 1000)

## ----catalogueGRDC7, eval = FALSE---------------------------------------------
#  # Visualise outlets on an interactive map
#  library(leaflet)
#  leaflet(data = GRDC_catalogue %>% filter(river == "PO, FIUME")) %>%
#    addTiles() %>%  # Add default OpenStreetMap map tiles
#    addMarkers(~long, ~lat, popup = ~station)

## ----catalogueData60UK1, eval = TRUE------------------------------------------
# Data60UK full catalogue
Data60UK_catalogue_all <- catalogueData60UK()

# Filter Data60UK catalogue based on bounding box
areaBox <- raster::extent(-4, -3, 51, 53)
Data60UK_catalogue_bbox <- catalogueData60UK(areaBox = areaBox)

## ----catalogueData60UK2-------------------------------------------------------
#  # Visualise outlets on an interactive map
#  library(leaflet)
#  leaflet(data = Data60UK_catalogue_bbox) %>%
#    addTiles() %>%  # Add default OpenStreetMap map tiles
#    addMarkers(~Longitude, ~Latitude, popup = ~Location)

## ----catalogueData60UK3, eval = TRUE, message = FALSE, fig.width = 7, fig.height = 7----
# Extract time series 
id <- catalogueData60UK()$id[1]

# Extract only the time series
MorwickTS <- tsData60UK(id)

## ----MOPEX_meta, eval = FALSE, message = FALSE, fig.width = 7, fig.height = 7----
#  # MOPEX full catalogue
#  MOPEX_catalogue <- catalogueMOPEX()
#  
#  # Extract data within a geographic bounding box
#  MOPEX_catalogue %>%
#    filter(dplyr::between(x = Longitude, left = -95, right = -92),
#           dplyr::between(x = Latitude, left = 37, right = 41))

## ----MOPEX_meta2, eval = FALSE, message = FALSE, fig.width = 7, fig.height = 7----
#  # Get stations with recondings in the period 1st Jan to 31st Dec 1995
#  MOPEX_catalogue %>%
#    filter(Date_start <= as.Date("1995-01-01"),
#           Date_end >= as.Date("1995-12-31"))
#  
#  # Get only catchments within NC
#  MOPEX_catalogue %>%
#    filter(State == "NC")

## ----MOPEX_data, eval = FALSE, message = FALSE, fig.width = 7, fig.height = 7----
#  # Take the first record in the catalogue
#  river_metadata <- MOPEX_catalogue[1,]
#  
#  # Get corresponding time series
#  river_ts <- tsMOPEX(id = river_metadata$USGS_ID)
#  
#  # Extract data between 1st Jan and 31st December 1948
#  river_ts_shorter <- window(river_ts,
#                             start = as.Date("1948-01-01"),
#                             end = as.Date("1948-12-31"))
#  
#  # Plot
#  plot(river_ts_shorter,
#       main = river_metadata$Name,
#       xlab = "",
#       ylab = c("P [mm/day]","E [mm/day]", "Q [mm/day]", "Tmax [C]","Tmin [C]"))

## ----SEPA1, eval = TRUE-------------------------------------------------------
# SEPA catalogue
SEPA_catalogue <- catalogueSEPA()

## ----SEPA2, eval = TRUE, message = FALSE, fig.width = 7-----------------------
# Take the first record in the catalogue
Perth_metadata <- SEPA_catalogue[1,]

# Single time series extraction
Perth_ts <- tsSEPA(id = Perth_metadata$LOCATION_CODE)

# Plot
plot(Perth_ts,
     main = Perth_metadata$STATION_NAME,
     xlab = "",
     ylab = "Water level [m]")

# Get only catchments with area above 4000 Km2
SEPA_catalogue %>%
  filter(CATCHMENT_AREA >= 4000)

# Get only catchments within river Ayr
SEPA_catalogue %>%
  filter(RIVER_NAME == "Ayr")

## ----SEPA3, eval=FALSE, message = FALSE, fig.width = 7------------------------
#  # Multiple time series extraction
#  y <- tsSEPA(id = c("234253", "234174", "234305"))
#  
#  plot(y[[1]], ylim = c(0, max(y[[1]], y[[2]], y[[3]])),
#       xlab = "", ylab = "Water level [m]")
#  lines(y[[2]], col = "red")
#  lines(y[[3]], col = "blue")

