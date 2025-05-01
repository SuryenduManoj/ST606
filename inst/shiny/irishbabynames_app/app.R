library(shiny)
library(ggiraph)
library(irishbabynames)  # Load your package

ui <- fluidPage(
  titlePanel("Irish Baby Names Dashboard"),
  mainPanel(
    girafeOutput("plot")
  )
)

server <- function(input, output) {
  output$plot <- renderGirafe({
    plot_top10_girl_rank_lines(irishbabynames)
  })
}

shinyApp(ui = ui, server = server)
