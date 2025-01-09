# Load necessary packages
library(shiny)
library(lubridate)
library(ggplot2)
library(readr)
library(dplyr)
library(stringr)

# Load the city geocodes dataset from the www folder
city_geocodes <- read_csv("www/uscities.csv")

# Function to calculate Venus Return dates
calculate_venus_return <- function(birth_date, num_returns = 5) {
  venus_cycle <- 8
  return_dates <- seq(from = birth_date, by = paste0(venus_cycle, " years"), length.out = num_returns)
  return(return_dates)
}

server <- function(input, output, session) {
  
  # Dynamically update city suggestions as the user types
  # Dynamically update city suggestions as the user types
  observeEvent(input$birth_place, {
    if (nzchar(input$birth_place)) {
      # Case-insensitive search
      city_suggestions <- city_geocodes %>%
        filter(str_detect(tolower(city), tolower(input$birth_place))) %>%
        pull(city) %>%
        unique() %>%
        sort()
      
      # Update text input with city suggestions
      updateTextInput(
        session,
        "birth_place",
        value = input$birth_place,
        placeholder = "Start typing a city name..."
      )
      
      # Check for matching city and show location details
      matching_city <- city_geocodes %>%
        filter(str_to_lower(city) == str_to_lower(input$birth_place))
      
      if (nrow(matching_city) > 0) {
        lat <- matching_city$lat[1]
        lon <- matching_city$lng[1]
        tz <- matching_city$timezone[1]
        
        output$location_details <- renderText({
          paste0("Location Details: Latitude: ", lat, ", Longitude: ", lon, ", Timezone: ", tz)
        })
      } else {
        output$location_details <- renderText("Location not found. Please try another city.")
      }
    }
  })
  
  
  # Generate the timeline plot
  observeEvent(input$generate, {
    # Validate inputs before generating the timeline
    if (nzchar(input$name) && nzchar(input$birth_date) && nzchar(input$birth_time) && nzchar(input$birth_place)) {
      
      venus_dates <- calculate_venus_return(input$birth_date)
      
      # Plot the timeline
      output$timeline_plot <- renderPlot({
        ggplot(data = data.frame(Age = seq(8, by = 8, length.out = length(venus_dates)), Date = venus_dates), aes(x = Age, y = Date)) +
          geom_point(color = "#ffd700", size = 6, shape = 21, fill = "#282a36") +
          geom_line(color = "#ffffff", size = 1) +
          labs(
            title = paste("Your Wouldmate Timeline for", input$name),
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
      
      # Display a positive message
      output$positive_message <- renderText({
        paste0("Your next Venus Return is on ", format(venus_dates[2], "%B %d, %Y"), ". 🌟 Embrace new connections and growth!")
      })
    } else {
      # Display an error message if any input is missing
      output$positive_message <- renderText("Please fill out all fields before generating your timeline.")
    }
  })
}
