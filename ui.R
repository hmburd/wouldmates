# Load necessary packages
library(lubridate)

ui <- fluidPage(
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "styles.css")
  ),
  titlePanel("Your Wouldmate Timeline"),
  
  # Sidebar layout
  sidebarLayout(
    sidebarPanel(
      textInput("name", "What's your name?", value = ""),
      dateInput("birth_date", "Date of Birth:", format = "yyyy-mm-dd"),
      textInput("birth_time", "Time of Birth:", value = "12:00"),
      textInput("birth_place", "Place of Birth (City, Country):", value = ""),
      actionButton("generate", "Generate My Timeline!", icon = icon("star"))
    ),
    
    mainPanel(
      textOutput("greeting"),
      plotOutput("timeline_plot"),
      textOutput("positive_message")
    )
  )
)
