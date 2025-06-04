library(shiny)
library(ggiraph)
library(irishbabynames)  # Load your package

ui <- fluidPage(
  titlePanel("Irish Baby Names Dashboard"),

  tabsetPanel(
    tabPanel("Similar Names",
             sidebarLayout(
               sidebarPanel(
                 textInput("name", "Enter a Name", value = ""),
                 selectInput("gender", "Gender", choices = c("Girls", "Boys"))
               ),
               mainPanel(
                 girafeOutput("similarPlot", width = "100%", height = "600px")
               )
             )
    ),

    tabPanel("Top 10 Ranked Names",
             sidebarLayout(
               sidebarPanel(
                 sliderInput("year", "Select Year", min = 1964, max = 2023, value = 2000, step = 1)
               ),
               mainPanel(
                 girafeOutput("top10Plot", width = "100%", height = "600px")
               )
             )
    )
  )
)

# ---- Server ----
server <- function(input, output, session) {
  output$similarPlot <- renderGirafe({
    req(input$name)

    if (input$gender == "Girls") {
      plot_similar_names_girls_ggiraph(
        input_name = input$name,
        max_distance = 1
      )
    } else {
      plot_similar_names_boys_ggiraph(
        input_name = input$name,
        max_distance = 1
      )
    }
  })
  output$top10Plot <- renderGirafe({
    req(input$year)
    plot_girls_rank_trend(input$year)
  })
}



# ---- Run App ----
shinyApp(ui, server)

