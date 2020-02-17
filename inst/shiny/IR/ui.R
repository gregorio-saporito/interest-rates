## ui.R ##

if(interactive()){
  
  ui <- shinydashboard::dashboardPage(
    
    shinydashboard::dashboardHeader(title = "Time Series Project"),
    
    shinydashboard::dashboardSidebar(
      
      shinydashboard::sidebarMenuOutput("menu")
      
    ),
    
    shinydashboard::dashboardBody(
      
      # css
      tags$head(
        
        tags$link(rel = "stylesheet", type = "text/css", href = "custom.css"),
        
        tags$link(rel = "shortcut icon",
                  href = "https://cdn0.iconfinder.com/data/icons/data-collection-and-privacy/100/Data_Science_Analysis-512.png")
      ),
      
      waiter::use_waiter(),
      waiter::waiter_show_on_load(html = waiter::spin_flower()), # will show on load
      
      shinydashboard::tabItems(
        shinydashboard::tabItem(tabName = "tab_1",
                shinyanimate::withAnim(),
                tags$div(id = 'effect_1',
                         
                         HTML("
                   <h1>Time Series Project<br>
                   Analysis on the Term Structure of Interest Rates</h1>
                   <h2>Author: <font color=\"#00ccff\">Gregorio Saporito</font></h2>
                   <h3><font color=\"gray\">An analysis of US dollar LIBOR interbank rates,
                   observed at monthly frequency, for rates spanning the period 1961-2008</font></h3>
                   <h4><br>This research topic has been extensively explored due to the level 
                   of insight that it could provide to central banks. Central banks mostly rely on
                   short-term financial instruments for the implementation of monetary policies. 
                   A better understanding of the relations between short and long-term rates could 
                   help central banks implement more effective policies. This research aims to 
                   empirically confirm this framework of the yield curve through an analysis of US dollar LIBOR 
                   interbank rates.</h4>
                   <h4><br>The term_structure dataset can be downloaded by clicking on the button below.</h4>
                   "),
                         downloadButton('download',"Download the data")
                         
                         )
        ),
        
        
        shinydashboard::tabItem(tabName = "tab_2",
                shinyanimate::withAnim(),
                tags$div(id = 'effect_2',
                         HTML("<h2>Data Inspection</h2>"),
                         shinyWidgets::addSpinner(
                          plotly::plotlyOutput(outputId = "distPlot")
                         ),
                         HTML("<h4>M2 and y2 are the main interest rates analysed in this report. M2 refers
                   to the US dollar LIBOR interbank rate with maturity 2 months, whereas y2 refers
                   to a 2-year maturity. As can be seen from figure 1, the yield curve is not 
                   inverted since long-term rates tend to lay above short-term ones. This suggests
                   long-term rates have a larger yield due to a risk premium, in line with the 
                   expectation hypothesis(Shiller R.J., 1979). Nevertheless, the presence of some
                   outliers is worth noting. For example, during the 2007 financial crisis an 
                   inversion of the yield curve occurred, leading to a scenario where short-term
                   investments had higher yields than long-term ones.</h4>
                   <h2>Interest Rates are I(1)</h2>"),
                         fluidRow(
                           column(6, pre(id = "adfm2")),
                           column(6, pre(id = "adfy2"))
                         ),
                         HTML("<h4>Firstly, the short-term interest rate m2 is analysed with the Augmented 
                   Dickey-Fuller test. As can be seen from the ADF test output, the null hypothesis 
                   cannot be rejected therefore we have no evidence to say that m2 is I(0). The 
                   long term-interest rates are analysed with the same ADF test. Even in this case,
                   we fail to reject the null hypothesis at 5 percent confidence level. 
                   Therefore there are no reasons to say that y2 is I(0).
                   <br>As previous empirical findings suggest, interest rates are I(1).</h4>
                   <h2>The Spreads are I(0)</h2>"),
                         fluidRow(
                           column(6,
                                  pre(id = "adfspreads")
                           ),
                           column(6,
                                  shinyWidgets::addSpinner(
                                    plotly::plotlyOutput("spreadsplot")
                                  )
                           )
                         ),
                         HTML("<h4>The results confirm the literature findings since the null hypothesis is 
                   rejected at 5 percent confidence level. Therefore it can be concluded that the spreads
                   are integrated of order zero. This finding has relevant implications since the 
                   spread provides information about the expectations of future rates. In other words,
                   we can derive from the spread whether long-term rates will increase or drop in the
                   future - provided that the expectation theory holds.</h4>")
                )
        ),
        
        shinydashboard::tabItem(tabName = "tab_3",
                shinyanimate::withAnim(),
                tags$div(id = 'effect_3',
                         HTML("
                   <h2>Cointegration Test</h2>
                   <h4>We now proceed to run a cointegration test to confirm that there is a connection
                   between short and long-term interest rates. For this purpose, the Engle and Granger
                   cointegration test was run using y2 as a dependent variable.</h4>
                   "),
                         fluidRow(
                           column(6,
                                  shinyWidgets::addSpinner(
                                    plotly::plotlyOutput("lm_plot")
                                  )
                           ),
                           column(6,
                                  shinyWidgets::addSpinner(
                                    plotly::plotlyOutput("lm_resid")
                                  )
                           )
                         ),
                         HTML("
                    <h4>The cointegration test summarises two steps into a single output which, if it was
                    broken down into its components, it would look as follows:<br>
                    <ul>
                    <li>based on the ADF test, the two series are I(1)</li>
                    <li>their residuals from OLS are I(0) (reject null hypothesis in adf test).</li>
                    </ul></h4>
                   "),
                         pre(id = "console"),
                         HTML("
                   <h2>Lag Length Criteria</h2>
                   <h4>Before running the vector error correction estimates, the correct lag order is selected 
                   based on the Schwarz information criterion.</h4>
                   "),
                         pre(id="laglength"),
                         HTML("
                   <h4>The SC criterion was chosen because it provides a consistent estimate as opposed to
                   other criteria like the AIC. Our sample size of 568 observations can be considered 
                   large enough for the SIC to be a consistent estimate. Therefore, the lag order 
                   selected is 2 and this information will be used to tune the VEC model.
                   <br>Since the variables m2 and y2 are I(1) and cointegrated the vector error correction
                   term has to be included in the VAR. This leads to the following VEC estimates.</h4>
                   "),
                         pre(id="VEC")
                )
        ),
        shinydashboard::tabItem(tabName = "tab_4",
                shinyanimate::withAnim(),
                tags$div(id = 'effect_4',
                         
                         HTML("
                    <h2>Conclusions</h2>
                    <h4>The main findings of this report are as follows:<br>
                    <ul>
                    <li>US Dollar LIBOR interbank rates with maturity 2 months (m2) 
                    and 2 years (y2) are I(1)</li>
                    <li>The corresponding spread is I(0)</li>
                    <li>m2 and y2 are cointegrated</li>
                    </ul>
                    The outcomes seem to suggest that the expectation hypothesis holds for
                    the US Dollar LIBOR interbank rates m2 and y2</h4>
                   ")
                )
                
        )
      )
    )
  )
  
}
