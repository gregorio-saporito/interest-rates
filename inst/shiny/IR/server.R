## server.R ##

server <- function(input, output, session) {
  
  # section 1 ---------------------------------------------------------------
  
  # function to show console output in shiny
  withConsoleRedirect <- function(containerId, expr) {
    # Change type="output" to type="message" to catch stderr
    # (messages, warnings, and errors) instead of stdout.
    txt <- capture.output(results <- expr, type = "output")
    if (length(txt) > 0) {
      shiny::insertUI(paste0("#", containerId), where = "beforeEnd",
                      ui = paste0(txt, "\n", collapse = "")
      )
    }
    results
  }
  
  # data
  data <- interestrates::term_structure
  
  data_gathered <- dplyr::mutate(
    tidyr::gather(
      data[,c("date", "m2", "y2")],
      key="type", value="value", -date
    ),
    type = as.factor(type)
  )
  
  spreads <- dplyr::mutate(data, spreads = y2-m2)
  
  # cointegration test
  
    # linear regression model
    mod <- lm(y2 ~ m2, data = data)
    dflm <- dplyr::mutate(
      broom::augment(mod),
      date=data$date)
    
    adfred <- aTSA::adf.test(dflm$.resid, nlag = 3)
    
    # analysis
    mysample <- data[, c("m2", "y2")]
    # VARselect(mysample, lag.max = 10, type = "const")
    cointtest <- urca::ca.jo(mysample, K=2, spec = "transitory", type="eigen")
    # cajorls(cointtest)

  # section 2 ---------------------------------------------------------------

  waiter::waiter_hide()
  
  output$menu <- shinydashboard::renderMenu({
    
    shinydashboard::sidebarMenu(id="tabs",
                                shinydashboard::menuItem("Home", tabName = "tab_1", icon=icon("home")),
                                shinydashboard::menuItem("Inspection", tabName = "tab_2", icon=icon("search")),
                                shinydashboard::menuItem("Analysis", tabName = "tab_3", icon=icon("chart-line")),
                                shinydashboard::menuItem("Conclusion", tabName = "tab_4", icon=icon("calendar-check"))
    )
  })
  
  output$distPlot <- plotly::renderPlotly({
    
    plot <- ggplot2::ggplot(data_gathered, ggplot2::aes(x=date, y=value, col = type)) +
      ggplot2::geom_line()
    
    plotly::ggplotly(plot)
    
  })
  
  observe({
    withConsoleRedirect("adfm2", {
      aTSA::adf.test(data$m2, nlag = 3)
    })
  })
  
  observe({
    withConsoleRedirect("adfy2", {
      aTSA::adf.test(data$y2, nlag = 3)
    })
  })
  
  observe({
    withConsoleRedirect("adfspreads", {
      aTSA::adf.test(spreads$spreads, nlag = 3)
    })
  })
  
  output$spreadsplot <- plotly::renderPlotly({
    plot <- ggplot2::ggplot(spreads, ggplot2::aes(x=date, y=spreads)) +
      ggplot2::geom_line()
    plotly::ggplotly(plot)
  })
  
  output$lm_plot <- plotly::renderPlotly({
    plotly::ggplotly(
      ggplot2::ggplot(dflm, ggplot2::aes(x = m2, y = y2)) +
        ggplot2::geom_line(ggplot2::aes(y=.fitted), color="lightgrey") +
        ggplot2::geom_segment(ggplot2::aes(xend = m2, yend = .fitted), alpha = .2) +
        ggplot2::geom_point(ggplot2::aes(color = abs(.resid))) + # size also mapped
        ggplot2::scale_color_continuous(low = "black", high = "red") +
        ggplot2::guides(color = FALSE, size = FALSE)
    )
  })
  
  output$lm_resid <- plotly::renderPlotly({
    plot <- ggplot2::ggplot(dflm, ggplot2::aes(x = date, y = .resid)) + 
      ggplot2::geom_line()
    plotly::ggplotly(plot)
  })
  
  observe({
    withConsoleRedirect("console", {
      aTSA::adf.test(dflm$.resid, nlag = 3)
    })
  })
  
  observe({
    withConsoleRedirect("laglength", {
      print(vars::VARselect(mysample, lag.max = 10, type = "const"))
    })
  })
  
  observe({
    withConsoleRedirect("VEC", {
      print(urca::cajorls(cointtest))
    })
  })
  
  output$download <- downloadHandler(
    filename = function(){"term_structure.csv"}, 
    content = function(fname){
      write.csv(interestrates::term_structure, fname)
    }
  )
  
  # animations
  observeEvent(input$tabs,{
    shinyanimate::startAnim(session, 'effect_1', 'slideInUp')
  })
  observeEvent(input$tabs,{
    shinyanimate::startAnim(session, 'effect_2', 'slideInUp')
  })
  observeEvent(input$tabs,{
    shinyanimate::startAnim(session, 'effect_3', 'slideInUp')
  })
  observeEvent(input$tabs,{
    shinyanimate::startAnim(session, 'effect_4', 'slideInUp')
  })
  
}
