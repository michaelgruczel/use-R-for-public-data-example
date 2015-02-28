liabilitiesSum <- function(filename, columnname) {
  data <- read.csv(filename, header=TRUE, sep=";")
  liabilitiesSum = 0
  for(j in 1:nrow(data)) {
    row <- data[j,]
    # only if value is a number add the value 
    check <- isNumeric(row[columnname]) 
    if(check) {
      a <- as.numeric(row[columnname])
      liabilitiesSum <- liabilitiesSum + a
    }
  }
  liabilitiesSum
}

isNumeric <- function(x) {
  !is.na(x) & is.numeric(as.numeric(x)) 
}

showLiabilityPieChart <- function(filename) {
  liabilitiesCreditmarket <- liabilitiesSum(filename, "SchuldenAmKreditmarkt")
  liabilitiesStateOrganisations <- liabilitiesSum(filename, "SchuldenKommunaleEigenbetriebe")
  liabilitiesHospitals <- liabilitiesSum(filename, "SchuldenKrankenhaeuser")
  slices <- c(liabilitiesCreditmarket, liabilitiesStateOrganisations, liabilitiesHospitals) 
  lbls <- c("market", "organisations", "hospitals")
  pie(slices, labels = lbls)
}

showLiabilityPieChart3D <- function(filename) {
  liabilitiesCreditmarket <- liabilitiesSum(filename, "SchuldenAmKreditmarkt")
  liabilitiesStateOrganisations <- liabilitiesSum(filename, "SchuldenKommunaleEigenbetriebe")
  liabilitiesHospitals <- liabilitiesSum(filename, "SchuldenKrankenhaeuser")
  slices <- c(liabilitiesCreditmarket, liabilitiesStateOrganisations, liabilitiesHospitals) 
  lbls <- c("market", "organisations", "hospitals")
  pie3D(slices, labels = lbls)
}