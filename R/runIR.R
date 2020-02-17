#' Shiny app with exploratory analysis of the term structure of interest rates
#' 
#' The function works with no arguments. The function depends on the dataset \code{\link{term_structure}}
#'
#' @return Runs the Shiny app retreiving the data, running the analysis and showing the report with interactive visualisations.
#' 
#' @seealso \code{\link{term_structure}}
#' 
#' @export
runIR <- function() {

# run app -----------------------------------------------------------------
  shiny::runApp(system.file("shiny/IR", package = "interestrates"), launch.browser = T)

}