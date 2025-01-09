library(shiny)

ui <- fluidPage(
  tags$link(rel = "stylesheet", href = "https://fonts.googleapis.com/css2?family=Unica+One&display=swap"),
  tags$link(rel = "stylesheet", type = "text/css", href = "styles.css"),
  
  tags$h1("Your Wouldmate Timeline", class = "timeline-title"),
  
  conditionalPanel(
    condition = "output.showInputs",
    tags$div(
      class = "input-box",
      textInput("name", "What do you call yourself?", placeholder = "Your nickname or whatever!"),
      tags$div("We don’t collect any data. This is just for fun and inspiration! 💫",
               style = "color: #ffd700; font-size: 8px; text-align: center; margin-top: -10px; margin-bottom: 20px;"),
      dateInput("birth_date", "Date of Birth:", format = "yyyy-mm-dd"),
      textInput("birth_time", "Time of Birth (24-hour format):", value = "12:00", placeholder = "e.g., 12:34"),
      textInput("birth_place", "Place of Birth (City, Country):", placeholder = "Start typing a city name..."),
      actionButton("generate", "Generate My Timeline!", icon = icon("star"), class = "generate-button")
    )
  ),
  
  conditionalPanel(
    condition = "!output.showInputs",
    plotOutput("timeline_plot"),
    tags$div(textOutput("positive_message"), class = "positive-message"),
    tags$div(textOutput("location_details"), class = "location-details")
  ),
  
  tags$div(class = "footer", "Made with ❤️ by HollyTech. Bringing cosmic timelines to life!")
)
