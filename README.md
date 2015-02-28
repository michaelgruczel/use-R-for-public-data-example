# use-R-for-public-data-example

This example gives a very simple example how to use the programming 
language R (http://www.r-project.org) to analyse public data.

A lot of organisations are forced to make data public. Very often that means downloading cvs files and not nice rest apis.
This is a very simple example how to use R to ectract some data from the german government data portal.

## public data

There is a public german data portal "https://www.govdata.de". 
I will use data from this service "https://www.govdata.de/suchen/-/details/stlae-service--1049350546".
The data is free to use as long as it is clear from which source it comes. It is copyrighted by the Federal Statistical Office and the statistical offices of the  Länder, Germany, 2015.
Please check https://www.regionalstatistik.de/genesis/online?sequenz=tabelleErgebnis&selectionname=358-61-4-B&regionalschluessel=

I've copied one version of a "Schulden" summary in this repo to show how it could work.

## R

R is a programming language for statistical data. R is available as Free Software under the terms of the 
Free Software Foundation's GNU General Public License in source code form (see http://www.r-project.org).

# lets start

you can import the data:

    liabilities <- read.csv("./openData/Schulden.csv", header=TRUE, sep=";")
    
a first look at the dat you will get by
    
    head(schulden)
    
Its a table, you can retrieve columns by index or name, e.g.a list of credits at the credit market you can get by 

    liabilities[,4] or liabilities[,"SchuldenAmKreditmarkt"]

It works by [row, column] and in this case we use a blan for all rows.
The real power of the language is the native support for statistical data. 
Examples are:

    mean(as.numeric(liabilities[, 6]))
    hist(as.numeric(liabilities[, 6]))

which calculates and plot the mean value and an histogramm, even cooler is a pie chart for the first 5 organisations.

    pie(as.numeric(liabilities[, 6])[1:5])
  
If you check the data (e.g. by liabilities[, 6]), then you will realize that the data is incomplete. 
In some cases . or - is filled in. So lets create a function which will sum up one kind of liabilities from a file
(there are different type of liabilities) in the data sheet and ignores empty or invalid values.

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
  
Now lets sum up the different liabilitiy types and put the sums in a pie chart

    showLiabilityPieChart <- function(filename) {
      liabilitiesCreditmarket <- liabilitiesSum(filename, "SchuldenAmKreditmarkt")
      liabilitiesStateOrganisations <- liabilitiesSum(filename, "SchuldenKommunaleEigenbetriebe")
      liabilitiesHospitals <- liabilitiesSum(filename, "SchuldenKrankenhaeuser")
      slices <- c(liabilitiesCreditmarket, liabilitiesStateOrganisations, liabilitiesHospitals) 
      lbls <- c("creditmarket", "organisations", "hospitals")
      pie(slices, labels = lbls)
    }

    showLiabilityPieChart3D <- function(filename) {
      liabilitiesCreditmarket <- liabilitiesSum(filename, "SchuldenAmKreditmarkt")
      liabilitiesStateOrganisations <- liabilitiesSum(filename, "SchuldenKommunaleEigenbetriebe")
      liabilitiesHospitals <- liabilitiesSum(filename, "SchuldenKrankenhaeuser")
      slices <- c(liabilitiesCreditmarket, liabilitiesStateOrganisations, liabilitiesHospitals) 
      lbls <- c("creditmarket", "organisations", "hospitals")
      pie3D(slices, labels = lbls)
    }

On MAC, you have to set defaults write org.R-project.R force.LANG en_US.UTF-8 first on the terminal and then
you can import the plotrix lib for the 3d pie chart

    install.packages("plotrix")
    library("plotrix");
    
If you have checked out this repo and installed R, then you should be able to execute
   
    source('simpleexample.R')
    showLiabilityPieChart3D("opendata/Schulden.csv")

And then you should have this

![piechart]: (https://raw.githubusercontent.com/michaelgruczel/use-R-for-public-data-example/master/piechart.png)

