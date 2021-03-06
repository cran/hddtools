#' Data source: SEPA catalogue
#'
#' @author Claudia Vitolo
#'
#' @description This function provides the official SEPA database catalogue of
#' river level data
#' (from https://www2.sepa.org.uk/waterlevels/CSVs/SEPA_River_Levels_Web.csv)
#' containing info for hundreds of stations. Some are NRFA stations.
#' The function has no input arguments.
#'
#' @return This function returns a data frame containing the following columns:
#' \describe{
#'   \item{\code{SEPA_HYDROLOGY_OFFICE}}{}
#'   \item{\code{STATION_NAME}}{}
#'   \item{\code{LOCATION_CODE}}{Station id number.}
#'   \item{\code{NATIONAL_GRID_REFERENCE}}{}
#'   \item{\code{CATCHMENT_NAME}}{}
#'   \item{\code{RIVER_NAME}}{}
#'   \item{\code{GAUGE_DATUM}}{}
#'   \item{\code{CATCHMENT_AREA}}{in Km2}
#'   \item{\code{START_DATE}}{}
#'   \item{\code{END_DATE}}{}
#'   \item{\code{SYSTEM_ID}}{}
#'   \item{\code{LOWEST_VALUE}}{}
#'   \item{\code{LOW}}{}
#'   \item{\code{MAX_VALUE}}{}
#'   \item{\code{HIGH}}{}
#'   \item{\code{MAX_DISPLAY}}{}
#'   \item{\code{MEAN}}{}
#'   \item{\code{UNITS}}{}
#'   \item{\code{WEB_MESSAGE}}{}
#'   \item{\code{NRFA_LINK}}{}
#' }
#'
#' @export
#'
#' @examples
#' \dontrun{
#'   # Retrieve the whole catalogue
#'   SEPA_catalogue_all <- catalogueSEPA()
#' }
#'

catalogueSEPA <- function(){

  theurl <- paste0("https://www2.sepa.org.uk/waterlevels/CSVs/",
                   "SEPA_River_Levels_Web.csv")
  
  SEPAcatalogue <- utils::read.csv(theurl, stringsAsFactors = FALSE)
  
  if (ncol(SEPAcatalogue) > 1){
    
    SEPAcatalogue$CATCHMENT_NAME[SEPAcatalogue$CATCHMENT_NAME == "---"] <- NA
    SEPAcatalogue$WEB_MESSAGE[SEPAcatalogue$WEB_MESSAGE == ""] <- NA
    
  }else{
    
    message("Website temporarily unavailable")
    SEPAcatalogue <- NULL
    
  }

  return(SEPAcatalogue)

}

#' Interface for the MOPEX database of Daily Time Series
#'
#' @author Claudia Vitolo
#'
#' @description This function extract the dataset containing daily rainfall and
#' streamflow discharge at one of the MOPEX locations.
#'
#' @param id hydrometric reference number (string)
#'
#' @return The function returns river level data in metres, as a zoo object.
#'
#' @export
#'
#' @examples
#' \dontrun{
#'   sampleTS <- tsSEPA(id = "10048")
#' }
#'

tsSEPA <- function(id){

  myTS <- NULL
  myList <- list()
  counter <- 0

  for (id in as.list(id)){
    counter <- counter + 1

    theurl <- paste("https://www2.sepa.org.uk/waterlevels/CSVs/",
                    id, "-SG.csv", sep = "")

    sepaTS <- utils::read.csv(theurl, skip = 6)
    
    if (ncol(sepaTS) > 1){
      
      # Coerse first column into a date
      datetime <- strptime(sepaTS[,1], "%d/%m/%Y %H:%M")
      myTS <- zoo::zoo(sepaTS[,2], order.by = datetime) # measured in m
      
      myList[[counter]] <- myTS
      
    }else{
      
      message("Website temporarily unavailable")
      myList <- NULL
      
    }

  }
  
  if (!is.null(myList) & counter == 1) {myList <- myTS}
  
  return(myList)

}
