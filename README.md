# 8a65fae3

# Interest Rates Package

The package has a Shiny app to explore the term structure of LIBOR interbank rates.
Data is stored as an .rda object.

## Installation

```R
# First install the R package "devtools" if not installed
devtools::install_github('unimi-dse/8a65fae3')
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