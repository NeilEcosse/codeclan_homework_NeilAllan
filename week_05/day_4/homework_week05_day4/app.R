# Issues:
    # How do I sort "all_teams" alphabetically, so they show in this order in my dropdown?
    # How do I list my links in a column rather than a row on the links tab?

library(shiny)
library(tidyverse)
library(shinythemes)
library(dplyr)
olympics_overall_medals <- read_csv("data/olympics_overall_medals.csv")
all_teams <- unique(olympics_overall_medals$team) 



ui <- fluidPage(
    
    titlePanel("Compare medal results for any two countries"),
    
        tabsetPanel(
            tabPanel("Data",  
    
   
                sidebarLayout(
                sidebarPanel(
            
                radioButtons("season",
                         tags$i("Choose Summer or Winter Olympics"),
                         choices = c("Summer", "Winter")
                ),
            
            
                selectInput("team_1",
                         tags$i("Choose first team"),
                         choices = all_teams
                ),
            
                selectInput("team_2",
                            tags$i("Choose second team"),
                            choices = all_teams
                )        
                
                ),
        
        mainPanel(
            plotOutput("medal_plot")
        )
        
                )
            ),
        tabPanel("Links",
                 tags$a("The Olympics", href = "https://www.Olympic.org/"),
                 tags$a("British Athletics", href = "https://www.britishathletics.org.uk/")
# how do I add more links and show them vertically in a column rather than in a row?                 
                 )
        )
)


server <- function(input, output) {
    output$medal_plot <- renderPlot({
        olympics_overall_medals %>%
            mutate(medal_ordered = recode(medal,
                                          "Gold" = "1 - Gold",
                                          "Silver" = "2 - Silver",
                                          "Bronze" = "3 - Bronze")) %>% 
            filter(team %in% c(input$team_1,
                               input$team_2)) %>%
            filter(season == input$season) %>%
            ggplot() +
            aes(x = team, y = count, fill = medal_ordered) +
            geom_col(show.legend = FALSE) +
            scale_fill_manual(
                values = c(
                    "1 - Gold" = "Gold",
                    "2 - Silver" = "#B4B4B4",
                    "3 - Bronze" = "#AD8A56"
                ) 
            )

    })
}


shinyApp(ui = ui, server = server)