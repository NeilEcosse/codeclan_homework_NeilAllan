library(shiny)
library(tidyverse)
library(CodeClanData)
library(sparkline)

games_list <- unique(sort(game_sales$name))
developer_list <- unique(sort(game_sales$developer))
genre_list <- unique(sort(game_sales$genre))
publisher_list <- unique(sort(game_sales$publisher))
year_list <- unique(sort(game_sales$year_of_release))

ui <- fluidPage(
    
    titlePanel("Game Sales"),
    
   
    
    fluidRow(
        
        column(3, 
               
               selectInput("publisher_select",
                            "Select publisher",
                            choices = publisher_list
               )
               
        ), #close 1st column
        
        # add slider for date range
        #column(8,
         #      
         #      sliderInput("year_select",
         #                     "Select date range",
         #                     min = min(game_sales$year_of_release),
         #                     max = max(game_sales$year_of_release)
                              
         #      ) 
        
    column(9,
           
           plotOutput("publisher_plot"), 
           
        ) # close 2nd column
    ), # close fluidrow 1
    
   
    
) #close fluidpage

server <- function(input, output) {
    
    output$publisher_plot <- renderPlot({
        game_sales %>%
            filter(publisher == input$publisher_select) %>%
            ggplot() +
            aes(x = year_of_release, y = sales) +
            geom_col() +
            labs(
                title =  input$publisher_select,
                x = "Year",
                y = "Sales"
            )
    }) #1st
   # get text  boxes showing single value for highest selling game and highest rated game 
    #output$max_sales <- renderValueBox({
        
       # valueBox()
       # game_sales %>%
       #     filter(publisher == input$publisher_select) %>%
       #     ggplot() +
       #     aes(x = year_of_release, y = sales) +
       #     geom_col() +
       #     labs(
       #         title =  input$publisher_select,
        #        x = "Year",
        #        y = "Sales"
        #    )
   # })#2nd
}

shinyApp(ui = ui, server = server)



