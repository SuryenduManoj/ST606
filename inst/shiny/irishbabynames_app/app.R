library(shiny)
library(irishbabynames)
library(ggiraph)
library(plotly)
library(shinythemes)
library(shinyWidgets)

ui <- fluidPage(
  theme = shinytheme("flatly"),
  titlePanel(
    div(
      h1("Irish Baby Names Dashboard", style = "color:#2c3e50"),
      p("Explore trends and patterns in Irish baby names from 1964–2024.", style = "font-size: 16px")
    )
  ),
  navbarPage("Irish Baby Names Dashboard",

    tabPanel("Trend by Name",
             sidebarLayout(
               sidebarPanel(
                 wellPanel(
                   tags$hr(),
                   icon("baby"), strong(" Enter Name"),
                   textInput("trend_name", "Name:", value = "Alex"),
                   tags$hr()
                 )
               ),
               mainPanel(
                 tags$h3("Trend Over the Years"),
                 br(),
                 girafeOutput("trend_plot")
               )
             )
    ),

    tabPanel(title = tagList(icon("user-friends"), "Similar Names"),
             sidebarLayout(
               sidebarPanel(
                 tags$h4("Find Similar Names"),
                 textInput("name", "Enter a Name:", value = ""),
                 pickerInput("gender", "Gender:", choices = c("Girls", "Boys"), multiple = FALSE),
                 helpText("Matches based on phonetic similarity.")
               ),
               mainPanel(
                 tags$h4("Phonetically Similar Names"),
                 girafeOutput("similar_plot")
               )
             )
    ),
    tabPanel(title = tagList(icon("genderless"), "Unisex Names"),
            sidebarLayout(
              sidebarPanel(
                tags$h4("Explore Unisex Names"),
                textInput("unisex_start", "Enter Starting Letter:", value = ""),
                selectInput("year", "Select Year:", choices = 1964:2024, selected = 2024),
                helpText("Filters unisex names starting with the chosen letter.")
              ),
              mainPanel(
                tags$h4("Unisex Names Distribution"),
                plotlyOutput("bar_plot")
              )
            )
    )
  ),
  tags$hr(),
  tags$footer(
    tags$p(
      "© 2025 IrishBabyNames Package | Built with Shiny",
      style = "text-align:center; color: #777; padding: 10px;"
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
        input_girls_name  = input$name,
        max_distance = 1
      )
    } else {
      plot_similar_boysnames(
        input_boys_name = input$name,
        max_distance = 1
      )
    }
  })

  output$bar_plot <- renderPlotly({
    req(input$unisex_start)
    plot_unisex_names(input$unisex_start, as.numeric(input$year))
  })

}

shinyApp(ui, server)
