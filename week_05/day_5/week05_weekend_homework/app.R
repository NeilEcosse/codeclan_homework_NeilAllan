library(shiny)
library(tidyverse)
library(CodeClanData)
library(sparkline)
library(shinythemes)
library(shinydashboard)
library(DT)

games_list <- unique(sort(game_sales$name))
developer_list <- unique(sort(game_sales$developer))
genre_list <- unique(sort(game_sales$genre))
publisher_list <- unique(sort(game_sales$publisher))
year_list <- unique(sort(game_sales$year_of_release))

ui <- fluidPage(
    theme = shinytheme("cerulean"),
    
    titlePanel("Game Sales"),
    
   
    
    fluidRow(
        
        column(4, 
               
               selectInput("publisher_select",
                            "Select publisher",
                            choices = publisher_list
               )
               
        ), #close 1st column
        
        #  slider for date range - why is this "squashed" at right hand side?
        column(8,
               
               sliderInput("year_select",
                              "Select date range",
                              min = min(game_sales$year_of_release),
                              max = max(game_sales$year_of_release),
                              value = c(min(game_sales$year_of_release), max(game_sales$year_of_release)),
                              sep ="",
                              width = '100%'
                              
               )
        ), # close 2nd column      
        

    ), # close fluidrow 1
 
    
    fluidRow(
        column(12,
               
               plotOutput("publisher_plot"), 
               
        ) # close 1st column
        
        
    ), # close fluidrow 2
    
    # add value boxes for max sales and ratings
    fluidRow(
        
       column(4, 
              titlePanel("Top 5 selling games in this period"),
               tableOutput("biggest_selling_titles")
               
        ), #close 1st column
    ), # close fluidrow 3     
   
    
) #close fluidpage

server <- function(input, output) {
    
    years_from_slider <- reactive({
        seq(input$year_select[1], input$year_select[2], by = 1)
    })
    
    output$publisher_plot <- renderPlot({
        game_sales %>%
            filter(publisher == input$publisher_select) %>%
            filter(year_of_release %in% years_from_slider()) %>% 
            ggplot() +
            aes(x = year_of_release, y = sales) +
            geom_col() +
            labs(
                title =  "Sales by year",
                x = "Year",
                y = "Sales"
            ) 
    }) #end 1st
   # get  boxes showing  highest selling games and highest rated games
    # Not sure how to do this
    output$biggest_selling_titles <- renderTable({
    
        game_sales %>%
            filter(publisher == input$publisher_select) %>%
            filter(year_of_release %in% years_from_slider()) %>% 
            group_by(name) %>% 
            summarise(sales = sum(sales)) %>%
            arrange(desc(sales)) %>% 
            head(5)
        
  
    })# end 2nd
}

shinyApp(ui = ui, server = server)



