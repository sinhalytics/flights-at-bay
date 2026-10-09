
library(shiny)
library(bslib)

ui <- fluidPage(
  
  theme = bs_theme(
    version = 5,
    bg = "#111A17",
    fg = "#F3F7F2",
    primary = "#10B981",
    secondary = "#A7B8AD"
  ),
  
  tags$head(
    tags$style(HTML("
      body, button, input, select, textarea, label {
        font-family: 'Times New Roman', Times, serif !important;
      }

      body {
        background: #111A17;
        color: #F3F7F2;
        font-size: 16px;
      }

      h1, h2, h3, h4 {
        font-family: 'Times New Roman', Times, serif !important;
        color: #F3F7F2;
      }

      .brand-bar {
        background: #064E3B;
        color: #FFFFFF;
        padding: 22px 24px;
        margin: -15px -15px 28px -15px;
        border-bottom: 3px solid #10B981;
      }

      .brand-name {
        font-size: 30px;
        font-weight: bold;
        letter-spacing: 1px;
      }

      .brand-subtitle {
        color: #D1FAE5;
        font-size: 14px;
        margin-top: 5px;
      }

      .eyebrow {
        color: #6EE7B7;
        font-size: 13px;
        font-weight: bold;
        letter-spacing: 2px;
      }

      .subtitle {
        color: #C0CEC4;
        line-height: 1.7;
        font-size: 16px;
      }

      .hero {
        padding-bottom: 22px;
      }

      .sidebar-box {
        background: #18231D;
        border: 1px solid #354D3F;
        border-radius: 9px;
        padding: 18px;
        margin-bottom: 22px;
      }

      .panel-box {
        background: #1A2820;
        border: 1px solid #354D3F;
        border-radius: 9px;
        margin-bottom: 22px;
        overflow: hidden;
      }

      .panel-heading {
        background: #064E3B;
        color: #FFFFFF;
        padding: 14px 18px;
        font-size: 18px;
        font-weight: bold;
        border-bottom: 1px solid #24765B;
      }

      .panel-content {
        padding: 20px;
        color: #F3F7F2;
        overflow-wrap: anywhere;
      }

      .metric-value {
        color: #6EE7B7;
        font-size: 24px;
        font-weight: bold;
        line-height: 1.5;
        overflow-wrap: anywhere;
      }

      .metric-note {
        color: #C0CEC4;
        font-size: 15px;
        line-height: 1.6;
        margin-top: 9px;
      }

      label {
        color: #F3F7F2;
      }

      select.form-control {
        background: #F3F7F2;
        color: #17231C;
      }

      .btn-success {
        background: #10B981;
        color: #062D20;
        border: none;
        font-weight: bold;
        font-size: 16px;
        padding: 12px 8px;
        width: 100%;
        white-space: normal;
      }

      .btn-success:hover {
        background: #6EE7B7;
        color: #062D20;
      }

      .green-label {
        color: #6EE7B7;
        font-size: 13px;
        font-weight: bold;
        letter-spacing: 1px;
      }

      .help-text {
        color: #D7E2DA;
        line-height: 1.9;
      }

      .footer-note {
        color: #A7B8AD;
        font-size: 13px;
        text-align: center;
        padding: 20px 0;
      }

      hr {
        border-color: #354D3F;
      }

      @media (max-width: 767px) {
        .brand-name {
          font-size: 25px;
        }

        .metric-value {
          font-size: 21px;
        }

        .panel-content {
          padding: 15px;
        }
      }
    "))
  ),
  
  # BRANDING
  div(
    class = "brand-bar",
    div(class = "brand-name", "FLIGHTS AT BAY"),
    div(
      class = "brand-subtitle",
      "AVIATION INTELLIGENCE  |  DELAY ANALYTICS"
    )
  ),
  
  # INTRODUCTION
  div(
    class = "hero",
    p(
      "UNDERSTAND DELAYS. MAKE INFORMED DECISIONS.",
      class = "eyebrow"
    ),
    h1("Keep flight delays at bay."),
    p(
      "Explore historical flight delay patterns and estimate delay probability using airport, scheduled departure hour and flight distance.",
      class = "subtitle"
    )
  ),
  
  sidebarLayout(
    position = "left",
    
    # FLIGHT INPUTS
    sidebarPanel(
      width = 3,
      
      div(
        class = "sidebar-box",
        
        h3("Flight configuration"),
        
        p(
          "Configure your flight scenario.",
          class = "subtitle"
        ),
        
        selectInput(
          "origin",
          "Departure airport",
          choices = c(
            "John F. Kennedy (JFK)" = "JFK",
            "LaGuardia (LGA)" = "LGA",
            "Newark Liberty (EWR)" = "EWR"
          ),
          selected = "JFK"
        ),
        
        sliderInput(
          "hour",
          "Scheduled departure hour",
          min = 0,
          max = 23,
          value = 17,
          step = 1
        ),
        
        sliderInput(
          "distance",
          "Flight distance (miles)",
          min = 100,
          max = 3000,
          value = 1000,
          step = 100
        ),
        
        actionButton(
          "analyze",
          "ANALYZE FLIGHT",
          class = "btn-success"
        ),
        
        hr(),
        
        p(
          "DATA: NYC FLIGHTS, 2013",
          class = "green-label"
        ),
        
        p(
          "This application analyses historical records from three New York-area airports. It does not use live flight data.",
          class = "subtitle"
        )
      )
    ),
    
    # DASHBOARD
    mainPanel(
      width = 9,
      
      fluidRow(
        column(
          width = 6,
          
          div(
            class = "panel-box",
            
            div(
              class = "panel-heading",
              "01 / ESTIMATED DELAY RISK"
            ),
            
            div(
              class = "panel-content",
              
              div(
                class = "metric-value",
                textOutput("risk")
              ),
              
              p(
                "Estimated probability of a departure delay exceeding 15 minutes.",
                class = "metric-note"
              )
            )
          )
        ),
        
        column(
          width = 6,
          
          div(
            class = "panel-box",
            
            div(
              class = "panel-heading",
              "02 / HISTORICAL FLIGHT SAMPLE"
            ),
            
            div(
              class = "panel-content",
              
              div(
                class = "metric-value",
                textOutput("sample")
              ),
              
              p(
                "Historical records from your selected airport.",
                class = "metric-note"
              )
            )
          )
        )
      ),
      
      div(
        class = "panel-box",
        
        div(
          class = "panel-heading",
          "03 / DEPARTURE DELAY PATTERNS"
        ),
        
        div(
          class = "panel-content",
          
          p(
            "Percentage of recorded flights delayed by more than 15 minutes, grouped by scheduled departure hour.",
            class = "subtitle"
          ),
          
          plotOutput(
            "delay_plot",
            height = "400px",
            width = "100%"
          )
        )
      ),
      
      fluidRow(
        column(
          width = 6,
          
          div(
            class = "panel-box",
            
            div(
              class = "panel-heading",
              "HOW TO USE"
            ),
            
            div(
              class = "panel-content help-text",
              
              tags$ol(
                tags$li("Choose JFK, LGA or EWR."),
                tags$li("Select a scheduled departure hour."),
                tags$li("Adjust the flight distance."),
                tags$li("Click ANALYZE FLIGHT."),
                tags$li("Review the estimate and chart.")
              )
            )
          )
        ),
        
        column(
          width = 6,
          
          div(
            class = "panel-box",
            
            div(
              class = "panel-heading",
              "DATA & MODEL NOTES"
            ),
            
            div(
              class = "panel-content help-text",
              
              tags$p(tags$strong("DATA SOURCE")),
              p("NYC flight records from 2013."),
              
              tags$p(tags$strong("METHOD")),
              p("Logistic regression using airport, hour and distance."),
              
              tags$p(tags$strong("LIMITATIONS")),
              p(
                "Historical associations do not establish causation. This educational model is not validated for operational forecasting."
              )
            )
          )
        )
      )
    )
  ),
  
  p(
    "FLIGHTS AT BAY  |  EDUCATIONAL ANALYTICS  |  HISTORICAL DATA",
    class = "footer-note"
  )
)
