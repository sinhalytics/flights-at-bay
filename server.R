
library(shiny)
library(nycflights13)
library(dplyr)
library(ggplot2)

# -----------------------------------------------
# 1. PREPARE HISTORICAL FLIGHT DATA
# -----------------------------------------------

flight_data <- nycflights13::flights |>
  dplyr::filter(
    !is.na(dep_delay),
    !is.na(hour),
    !is.na(distance),
    !is.na(origin)
  ) |>
  dplyr::mutate(
    origin = factor(origin),
    delayed = as.integer(dep_delay > 15)
  )

# -----------------------------------------------
# 2. TRAIN LOGISTIC REGRESSION MODEL
# -----------------------------------------------

delay_model <- stats::glm(
  delayed ~ origin + hour + distance,
  data = flight_data,
  family = stats::binomial()
)

# -----------------------------------------------
# 3. SHINY SERVER
# -----------------------------------------------

server <- function(input, output, session) {
  
  # Prediction runs when the user clicks the button
  prediction <- shiny::eventReactive(
    input$analyze,
    {
      
      new_flight <- data.frame(
        origin = factor(
          input$origin,
          levels = levels(flight_data$origin)
        ),
        hour = as.numeric(input$hour),
        distance = as.numeric(input$distance)
      )
      
      probability <- stats::predict(
        delay_model,
        newdata = new_flight,
        type = "response"
      )
      
      as.numeric(probability)
      
    },
    ignoreInit = TRUE
  )
  
  # ---------------------------------------------
  # OUTPUT 1: PREDICTED DELAY PROBABILITY
  # ---------------------------------------------
  
  output$risk <- shiny::renderText({
    
    req(input$analyze > 0)
    
    probability <- prediction()
    
    validate(
      need(
        length(probability) == 1 &&
          is.finite(probability),
        "Prediction unavailable. Please try again."
      )
    )
    
    paste0(
      round(probability * 100, 1),
      "% chance of a departure delay over 15 minutes"
    )
  })
  
  # ---------------------------------------------
  # OUTPUT 2: HISTORICAL SAMPLE SIZE
  # ---------------------------------------------
  
  output$sample <- shiny::renderText({
    
    req(input$analyze > 0)
    
    airport_count <- sum(
      flight_data$origin == input$origin
    )
    
    paste0(
      format(airport_count, big.mark = ","),
      " historical flights from ",
      input$origin
    )
  })
  
  # ---------------------------------------------
  # OUTPUT 3: HISTORICAL DELAY CHART
  # ---------------------------------------------
  
  output$delay_plot <- shiny::renderPlot({
    
    hourly_data <- flight_data |>
      dplyr::filter(origin == input$origin) |>
      dplyr::group_by(hour) |>
      dplyr::summarise(
        delay_rate = mean(delayed) * 100,
        flights = dplyr::n(),
        .groups = "drop"
      ) |>
      dplyr::arrange(hour)
    
    validate(
      need(
        nrow(hourly_data) > 0,
        "No historical data available for this airport."
      )
    )
    
    ggplot2::ggplot(
      hourly_data,
      ggplot2::aes(
        x = hour,
        y = delay_rate
      )
    ) +
      ggplot2::geom_line(
        color = "#10B981",
        linewidth = 1.3
      ) +
      ggplot2::geom_point(
        color = "#6EE7B7",
        size = 2.5
      ) +
      ggplot2::scale_x_continuous(
        breaks = seq(0, 23, by = 3),
        limits = c(0, 23)
      ) +
      ggplot2::scale_y_continuous(
        labels = function(x) paste0(x, "%"),
        expand = ggplot2::expansion(mult = c(0.05, 0.12))
      ) +
      ggplot2::labs(
        x = "Scheduled departure hour",
        y = "Flights delayed over 15 minutes"
      ) +
      ggplot2::theme_minimal(base_size = 13) +
      ggplot2::theme(
        text = ggplot2::element_text(
          family = "serif",
          color = "#F3F7F2"
        ),
        plot.background = ggplot2::element_rect(
          fill = "#1A2820",
          color = NA
        ),
        panel.background = ggplot2::element_rect(
          fill = "#1A2820",
          color = NA
        ),
        axis.text = ggplot2::element_text(
          color = "#D7E2DA"
        ),
        axis.title = ggplot2::element_text(
          color = "#F3F7F2"
        ),
        axis.line = ggplot2::element_line(
          color = "#52665A"
        ),
        panel.grid.major = ggplot2::element_line(
          color = "#354D3F"
        ),
        panel.grid.minor = ggplot2::element_blank(),
        plot.margin = ggplot2::margin(
          t = 12, r = 16, b = 12, l = 12
        )
      )
  }, res = 96)
  
}
