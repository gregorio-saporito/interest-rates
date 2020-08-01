# Interest Rates Package :chart_with_upwards_trend:

The *interestrates* package has a Shiny app to explore the __term structure of LIBOR interbank rates__.
Data is stored as an .rda object.

Click on the link to view the app: http://gregorio-saporito.shinyapps.io/interest-rates

## Installation

```R
# First install the R package "devtools" if not installed
devtools::install_github('gregorio-saporito/interest-rates')
```

## Usage

Load the package

```R
require(interestrates)
```

The function of the package is `runIR()` and is run without arguments.

```R
runIR()
```
