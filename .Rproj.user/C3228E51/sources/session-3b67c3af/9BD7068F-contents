# Load necessary packages
library(shiny)
library(lubridate)
library(ggplot2)
library(readr)
library(dplyr)
library(stringr)


# Load the city geocodes dataset from the www folder
city_geocodes <- read_csv("www/uscities.csv", show_col_types = FALSE)


# Function to calculate Venus Return dates
calculate_venus_return <- function(birth_date, num_returns = 5) {
  # Venus' synodic period (time between returns)
  venus_cycle_days <- 583.92
  
  # Convert birth_date to Date format
  birth_date <- as.Date(birth_date)
  
  # Generate Venus Return dates
  return_dates <- seq(from = birth_date, by = paste0(venus_cycle_days, " days"), length.out = num_returns)
  
  return(return_dates)
}

# Function to calculate the next Venus Return date
calculate_next_venus_return <- function(birth_date) {
  venus_cycle_days <- 583.92
  today <- Sys.Date()
  
  # Generate multiple return dates to find the next one
  return_dates <- seq(from = as.Date(birth_date), by = paste0(venus_cycle_days, " days"), length.out = 20)
  
  # Filter out dates before today
  future_dates <- return_dates[return_dates > today]
  
  # Check if there are any future dates, otherwise return NA
  if (length(future_dates) == 0) {
    return(NA)
  }
  
  # Find the next return date after today
  next_return <- min(future_dates)
  
  return(next_return)
}


server <- function(input, output, session) {
  
  # Reactive value to control UI state
  rv <- reactiveValues(showInputs = TRUE)
  
  # Dynamically update city suggestions as the user types
  observeEvent(input$birth_place, {
    if (nzchar(input$birth_place)) {
      city_suggestions <- city_geocodes %>%
        filter(str_detect(tolower(city), tolower(input$birth_place))) %>%
        pull(city) %>%
        unique() %>%
        sort()
      
      if (length(city_suggestions) > 0) {
        updateSelectizeInput(session, "birth_place", choices = city_suggestions, server = TRUE)
      }
      
      # Show location details if a match is found
      matching_city <- city_geocodes %>%
        filter(str_to_lower(city) == str_to_lower(input$birth_place))
      
      if (nrow(matching_city) > 0) {
        lat <- matching_city$lat[1]
        lon <- matching_city$lng[1]
        tz <- matching_city$timezone[1]
        
        output$location_details <- renderText({
          paste0(
            "Location Details: Latitude: ", lat, 
            ", Longitude: ", lon, 
            ", Timezone: ", tz, 
            " | Date of Birth: ", input$birth_date, 
            " | Time of Birth: ", input$birth_time
          )
        })
      } else {
        output$location_details <- renderText("Location not found. Please try another city.")
      }
    }
  })
  
  observeEvent(input$generate, {
    # Use a default name if none is provided
    name <- ifelse(nzchar(input$name), input$name, "Celestial Visitor")
    
    if (nzchar(input$birth_date) && nzchar(input$birth_time) && nzchar(input$birth_place)) {
      # Perform the calculations
      venus_dates <- calculate_venus_return(input$birth_date)
      next_venus_return <- calculate_next_venus_return(input$birth_date)
      
      # Plot the timeline
      output$timeline_plot <- renderPlot({
        ggplot(data = data.frame(Age = seq(8, by = 8, length.out = length(venus_dates)), Date = venus_dates), aes(x = Age, y = Date)) +
          geom_point(color = "#ffd700", size = 6, shape = 21, fill = "#282a36") +
          geom_line(color = "#ffffff", size = 1) +
          geom_text(aes(label = format(Date, "%b %d, %Y")), vjust = -1, color = "#ffd700", size = 3) +
          labs(
            title = paste("Your Wouldmate Timeline for", name),
            x = "Age",
            y = "Significant Date"
          ) +
          theme_minimal() +
          theme(
            plot.background = element_rect(fill = "#1b1b2f"),
            panel.background = element_rect(fill = "#282a36"),
            axis.text = element_text(color = "#f5f5f5"),
            axis.title = element_text(color = "#f5f5f5"),
            plot.title = element_text(color = "#ffd700", size = 20, face = "bold", hjust = 0.5)
          )
      })
      
      
      # Display the next Venus Return date
      output$positive_message <- renderText({
        paste0("Your next Venus Return is on ", format(next_venus_return, "%B %d, %Y"), ". 🌟 Embrace new connections and growth!")
      })
      
      # Hide the input box
      rv$showInputs <- FALSE
    } else {
      # Display an error message if any input is missing
      output$positive_message <- renderText("Please fill out all fields before generating your timeline.")
    }
  })
  
  
  
  # Reactive output for UI condition
  output$showInputs <- reactive({
    rv$showInputs
  })
  
  # Necessary for conditionalPanel to work
  outputOptions(output, "showInputs", suspendWhenHidden = FALSE)
}
