library(shiny)
library(ggplot2)
library(dplyr)
library(lubridate)

# Function to calculate Venus Return dates
calculate_venus_return <- function(birth_date, num_returns = 5) {
  venus_cycle_days <- 583.92
  birth_date <- as.Date(birth_date)
  return_dates <- seq(from = birth_date, by = paste0(venus_cycle_days, " days"), length.out = num_returns)
  return(return_dates)
}

# Function to calculate the next Venus Return date
calculate_next_venus_return <- function(birth_date) {
  venus_cycle_days <- 583.92
  today <- Sys.Date()
  return_dates <- seq(from = as.Date(birth_date), by = paste0(venus_cycle_days, " days"), length.out = 20)
  future_dates <- return_dates[return_dates > today]
  next_return <- ifelse(length(future_dates) > 0, min(future_dates), NA)
  return(next_return)
}

# Server Logic
server <- function(input, output, session) {
  rv <- reactiveValues(showInputs = TRUE)
  
  observeEvent(input$generate, {
    name <- ifelse(nzchar(input$name), input$name, "Celestial Visitor")
    
    if (nzchar(input$birth_date) && nzchar(input$birth_time) && nzchar(input$birth_place)) {
      venus_dates <- calculate_venus_return(input$birth_date)
      next_venus_return <- calculate_next_venus_return(input$birth_date)
      
      # Horizontal timeline plot with matching styling
      # Horizontal Timeline Plot with Shadow Effect
      output$timeline_plot_alternate <- renderPlot({
        ggplot(data = data.frame(Age = seq(8, by = 8, length.out = length(venus_dates)), Date = venus_dates), aes(x = Age, y = 1)) +
          # Shadow text layer (offset and darker)
          geom_text(aes(label = format(Date, "%b %d, %Y")), vjust = -1.2, color = "black", size = 4.5, family = "Unica One", fontface = "bold") +
          # Main text layer (bright and centered)
          geom_text(aes(label = format(Date, "%b %d, %Y")), vjust = -1, color = "#4682B4", size = 4, family = "Unica One", fontface = "bold") +
          geom_point(aes(size = Age), color = "#4682B4", shape = 21, fill = "#B0E0E6") +  # Light blue theme
          geom_line(color = "#4682B4", size = 1.5) +
          scale_y_continuous(limits = c(0.5, 1.5)) +
          theme_minimal() +
          theme(
            plot.background = element_rect(fill = "#ffd600", color = "#4682B4", size = 2),  # Alice blue background
            panel.background = element_rect(fill = "#F0e68c", color = NA),
            panel.grid.major = element_blank(),
            panel.grid.minor = element_blank(),
            axis.text.y = element_text(color = "#4682B4", family = "Unica One", size = 14),
            axis.title.x = element_text(color = "#4682B4", family = "Unica One", size = 14),
            plot.title = element_text(color = "#4682B4", size = 24, face = "bold", hjust = 0.5, family = "Unica One")
          )
      })
      
      rv$showInputs <- FALSE
    } else {
      output$positive_message <- renderText("Please fill out all fields before generating your timeline.")
    }
  })
  
  output$showInputs <- reactive({
    rv$showInputs
  })
  
  outputOptions(output, "showInputs", suspendWhenHidden = FALSE)
}