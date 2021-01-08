library(shiny)
library(tidyverse)
library(shinythemes)
library(dplyr)
olympics_overall_medals <- read_csv("data/olympics_overall_medals.csv") 
olympics_overall_medals <- olympics_overall_medals %>% 
    arrange(team)

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
            column(2,  
                 tags$a("The Olympics", href = "https://www.Olympic.org/"),
                 tags$a("British Athletics", href = "https://www.britishathletics.org.uk/")
# how do I add more links and show them vertically in a column rather than in a row?                 
                 )
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
            geom_col() +
            scale_fill_manual(
                values = c(
                    "1 - Gold" = "Gold",
                    "2 - Silver" = "#B4B4B4",
                    "3 - Bronze" = "#AD8A56"
                ) 
            ) +
            labs(
                x = "Team",
                y = "Number of Medals",
                fill = "Medal Type"
            )

    })
}


shinyApp(ui = ui, server = server)