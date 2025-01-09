library(ggplot2)
# Server logic for the Wouldmate Timeline app
server <- function(input, output) {
  observeEvent(input$generate, {
    name <- input$name
    birth_date <- input$birth_date
    
    # Greeting message
    output$greeting <- renderText({
      paste0("Hello, ", name, "! Let's explore your Wouldmate Timeline...")
    })
    
    # Timeline plot placeholder
    output$timeline_plot <- renderPlot({
      ggplot() +
        geom_point(aes(x = c(8, 16, 24, 32, 40), y = c(1, 2, 3, 4, 5))) +
        labs(title = "Your Wouldmate Timeline", x = "Age", y = "Event")
    })
    
    # Positive message
    output$positive_message <- renderText({
      paste0("Your next big soulmate moment could happen around age ", year(birth_date) %% 8 * 8, "!")
    })
    
    # Calculate Venus Return Dates
    calculate_venus_return <- function(birth_date, num_returns = 5) {
      # Venus returns roughly every 8 years
      venus_cycle <- 8
      return_dates <- seq(from = birth_date, by = paste0(venus_cycle, " years"), length.out = num_returns)
      return(return_dates)
    }
    
  })
}