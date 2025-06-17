library(shiny)
library(irishbabynames)
library(ggiraph)

ui <- fluidPage(
  titlePanel("Irish Baby Names Dashboard"),
  tabsetPanel(

    tabPanel("Trend by Name",
             sidebarLayout(
               sidebarPanel(
                 textInput("trend_name", "Enter Name:", value = "")
               ),
               mainPanel(
                 girafeOutput("trend_plot")
               )
             )
    ),

    tabPanel("Similar Names",
             sidebarLayout(
               sidebarPanel(
                 textInput("name", "Enter Name:", value = ""),
                 selectInput("gender", "Gender", choices = c("Girls", "Boys"))
               ),
               mainPanel(
                 girafeOutput("similar_plot")
               )
             )
    ),
    tabPanel("Unisex Names",
             sidebarLayout(
               sidebarPanel(
                 textInput("unisex_start", "Enter Letter:", value = ""),
                 selectInput("year", "Select Year:", choices = 1964:2022, selected = "")

               ),
               mainPanel(
                 plotlyOutput("bar_plot")
               )
             )
    )
  )
)

server <- function(input, output, session) {

  output$trend_plot <- renderGirafe({
    plot_trend(input$trend_name)
  })

  output$similar_plot <- renderGirafe({
    req(input$name)

    if (input$gender == "Girls") {
      plot_similar_girlsnames(
        input_name1  = input$name,
        max_distance = 1
      )
    } else {
      plot_similar_boysnames(
        input_name2 = input$name,
        max_distance = 1
      )
    }
  })

  output$bar_plot <- renderPlotly({
    req(input$unisex_start)
    plot_bar_unisex_names(input$unisex_start, as.numeric(input$year))
  })

}

shinyApp(ui, server)
