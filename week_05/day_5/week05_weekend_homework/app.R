library(shiny)
library(tidyverse)
library(CodeClanData)
library(sparkline)
library(shinythemes)
library(shinydashboard)
library(scales)

# This app is just going to let you select a publisher
# and a date range, and then show a bar chart of sales
# over time, along with a "top 5" of best selling and 
#  best rated games

# I don't think this is the most useful view of the data -
# e.g. wouldn't let you compare to a competitor, and I'm not
# sure that selecting a smaller/larger date range adds anything
# to your understanding of the data. Just practicing at the moment!

# I've left in comments I was using after closed brackets
# which explain what they do - I'm still getting easily confused
# by these



games_list <- unique(sort(game_sales$name))
developer_list <- unique(sort(game_sales$developer))
genre_list <- unique(sort(game_sales$genre))
publisher_list <- unique(sort(game_sales$publisher))
year_list <- unique(sort(game_sales$year_of_release))

ui <- fluidPage(
    theme = shinytheme("paper"),
    
    titlePanel("Game Sales"),
    
   
    
    fluidRow(
        
        column(4, 
               
               selectInput("publisher_select",
                            tags$h5("Select publisher"),
                            choices = publisher_list
               )
               
        ), #close 1st column
        
        #  slider for date range
        column(8,
               
               sliderInput("year_select",
                              tags$h5("Select date range"),
                              min = min(game_sales$year_of_release),
                              max = max(game_sales$year_of_release),
                              value = c(min(game_sales$year_of_release), max(game_sales$year_of_release)),
                              sep ="",
                              width = '95%'
                              
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
              titlePanel(tags$h5("Top selling games")),
              titlePanel(tags$h6("Total for all platforms")),
               tableOutput("biggest_selling_titles")
               
        ), #close 1st column
       
       column(4, 
              titlePanel(tags$h5("Top critic scores")),
              titlePanel(tags$h6("Average across all platforms")),
              tableOutput("best_critic_rating")
              
       ), #close 2nd column
       
       column(4, 
              titlePanel(tags$h5("Top user scores")),
              titlePanel(tags$h6("Average across all platforms")),
              tableOutput("best_user_rating")
              
       ), #close 2nd column
    ), # close fluidrow 3     
   
    
) #close fluidpage




# I think the server section could be more efficient, not sure 
# what to change at the moment, though

server <- function(input, output) {
    
    years_from_slider <- reactive({
        seq(input$year_select[1], input$year_select[2], by = 1)
    })
    
    output$publisher_plot <- renderPlot({
        game_sales %>%
            filter(publisher == input$publisher_select) %>%
            filter(year_of_release %in% years_from_slider()) %>% 
            ggplot() +
            aes(x = year_of_release, y = sales,) +
            geom_col() +
            theme_minimal() +
        scale_x_continuous(labels = number_format(accuracy = 1)) +
            labs(
                title =  "Sales by year",
                x = "Year",
                y = "Sales"
            ) 
    }) #end 1st
   # get  boxes showing  highest selling games and highest rated games
    
    output$biggest_selling_titles <- renderTable({
    
        game_sales %>%
            filter(publisher == input$publisher_select) %>%
            filter(year_of_release %in% years_from_slider()) %>% 
            group_by(name) %>% 
            summarise(sales = sum(sales)) %>%
            arrange(desc(sales)) %>% 
            head(5)
        
  
    }, width = "90%")# end 2nd

output$best_critic_rating <- renderTable({
    
    game_sales %>%
        filter(publisher == input$publisher_select) %>%
        filter(year_of_release %in% years_from_slider()) %>% 
        group_by(name) %>% 
        summarise(`avg critic rating` = mean(critic_score)) %>%
        arrange(desc(`avg critic rating`)) %>% 
        head(5)
    
    
}, width = "90%")# end 3rd

output$best_user_rating <- renderTable({
    
    game_sales %>%
        filter(publisher == input$publisher_select) %>%
        filter(year_of_release %in% years_from_slider()) %>% 
        group_by(name) %>% 
        summarise(`avg user rating` = mean(user_score)) %>%
        arrange(desc(`avg user rating`)) %>% 
        head(5)
    
    
}, width = "90%")# end 4th
}
shinyApp(ui = ui, server = server)



