library(shiny)
library(ggiraph)
library(irishbabynames)  # Load your package

ui <- fluidPage(
  titlePanel("Irish Baby Names Dashboard"),sidebarPanel(
    textInput("name", "Enter a Name", value = "Ci"),
    selectInput("gender", "Gender", choices = c("Girls", "Boys")),
    checkboxInput("per_million", "Normalize by per million births", value = FALSE),
    sliderInput("top_n", "Number of Top Similar Names to Plot", min = 1, max = 10, value = 5)
  ),
  mainPanel(
    ggiraphOutput("similarPlot", width = "100%", height = "600px")
  )
)

# ---- Server ----
server <- function(input, output, session) {
  output$similarPlot <- renderggiraph({
    req(input$name)

    if (input$gender == "Girls") {
      plot_similar_names_girls_ggiraph(
        input_name = input$name,
        max_distance = 1,  # Fixed internally
        per_million = input$per_million,
        top_n = input$top_n
      )
    } else {
      plot_similar_names_boys_ggiraph(
        input_name = input$name,
        max_distance = 1,
        per_million = input$per_million,
        top_n = input$top_n
      )
    }
  })
}

# ---- Run App ----
shinyApp(ui, server)

shinyApp(ui = ui, server = server)
