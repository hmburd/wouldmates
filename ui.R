# UI Layout
ui <- fluidPage(
  tags$link(rel = "stylesheet", href = "https://fonts.googleapis.com/css2?family=Unica+One&display=swap"),
  tags$link(rel = "stylesheet", type = "text/css", href = "styles.css"),
  
  tags$h1("Your Wouldmate Timeline", class = "timeline-title"),
  
  conditionalPanel(
    condition = "output.showInputs",
    tags$div(
      class = "input-box",
      textInput("name", "What do you call yourself?", placeholder = "Your nickname or whatever!"),
      dateInput("birth_date", "Date of Birth:", format = "yyyy-mm-dd"),
      textInput("birth_time", "Time of Birth (24-hour format):", value = "12:00", placeholder = "e.g., 12:34"),
      textInput("birth_place", "Place of Birth (City, Country):", placeholder = "Start typing a city name..."),
      actionButton("generate", "Generate My Timeline!", icon = icon("star"), class = "generate-button")
    )
  ),
  
  conditionalPanel(
    condition = "!output.showInputs",
    tabsetPanel(
      tabPanel("Styled Plot", plotOutput("timeline_plot_alternate")),  # Added the plot output here
      tabPanel("Messages", tags$div(textOutput("positive_message"), class = "positive-message")),
      tabPanel("Location Details", tags$div(textOutput("location_details"), class = "location-details"))
    )
  ),
  
  tags$div(class = "footer", "Made with ❤️ by HollyTech. Bringing cosmic timelines to life!")
)
