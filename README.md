# Interest Rates Package

The package has a Shiny app to explore the term structure of LIBOR interbank rates.
Data is stored as an .rda object.

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