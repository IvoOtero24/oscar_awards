library(shiny)
library(tidyverse)
library(tidyr)
library(shinydashboard)
library(ggridges)
library(waffle)


oscars_tbl <- read.csv(file = "../data/the_oscar_award.csv", header = TRUE, sep = ",", encoding = "UTF-8", na.strings = "")
oscars_merged <- read.csv(file = "../data/oscars_merged.csv", header = TRUE, sep = ",", encoding = "UTF-8", na.strings = "")


# Data preparation
oscars_tbl <- as_tibble(oscars_tbl)
oscars_tbl$winner <- as.factor(oscars_tbl$winner)
oscars_tbl$category <- as.factor(oscars_tbl$category)
biggest_categories <- oscars_tbl %>%
    mutate(category = fct_lump(category, n = 10)) %>%
    count(category, sort = TRUE)
winners <- filter(oscars_tbl, winner == "True")
# ---------------


# Define server logic required to draw a histogram
shinyServer(function(input, output) {

    
    # Historische Daten Visualisierung --------------------------------------
    output$nominated <- renderPlot({
        
        # Kategorien
        most_freq_names <- count(oscars_tbl, name) %>% arrange(desc(n)) %>% top_n(10, n)
        top_directors_nom <- filter(oscars_tbl, category == "DIRECTING") %>% count(name) %>% arrange(desc(n)) %>% top_n(10, n)
        top_actors_n <- filter(oscars_tbl, grepl('ACTOR*|ACTRESS*', category)) %>% count(name) %>% arrange(desc(n)) %>% top_n(10, n)
        most_freq_films <- oscars_tbl %>% drop_na() %>%  count(film,year_film) %>% arrange(desc(n)) %>% top_n(5, n)
        
        # gefilterte Kategorien
        top_names_filtered <- filter(oscars_tbl, name %in% most_freq_names$name)
        top_directors_filtered <- filter(oscars_tbl, category == "DIRECTING") %>% filter(name %in% top_directors_nom$name)
        top_actors_n_filtered <- filter(oscars_tbl, grepl('ACTOR*|ACTRESS*', category)) %>% filter(name %in% top_actors_n$name)
        top_films_filtered <- oscars_tbl %>% filter(film %in% most_freq_films$film)
        
        if (input$nomCategories == "Org. Name") {
            ggplot(top_names_filtered, aes(y = fct_rev(fct_infreq(sub(name ,pattern = "(\\w{15}).*",replacement = "\\1."))))) + 
                geom_bar() + labs(title = "Organisationen oder Länder: Top 10 Nominierungen", x = "Anzahl der Nominierungen", y = "Nominierte") +
                theme(plot.title = element_text(hjust = 0.5), legend.title = element_text(hjust = 0.5))  
            
        } else if (input$nomCategories == "Regisseure") {
            ggplot(top_directors_filtered, aes(y = fct_rev(fct_infreq(name)))) + 
                geom_bar() + labs(title = "Regisseure mit min. 5 Nominierungen", x = "Anzahl der Nominierungen",y = "Nominierte") +
                scale_x_continuous(breaks=c(0:12)) + 
                theme(plot.title = element_text(hjust = 0.5), legend.title = element_text(hjust = 0.5))
            
        } else if (input$nomCategories == "SchauspielerInnen") {
            ggplot(top_actors_n_filtered, aes(y = fct_rev(fct_infreq(name)))) + 
                geom_bar() + labs(title = "SchauspielerInnen mit min. 8 Nominierungen", x = "Anzahl der Nominierungen", y = "Nominierte") +
                scale_x_continuous(breaks=c(0:21)) + 
                theme(plot.title = element_text(hjust = 0.5), legend.title = element_text(hjust = 0.5)) 
            
        } else {
            ggplot(top_films_filtered, aes(y = fct_rev(fct_infreq(film)))) + 
                geom_bar() + labs(title = "Filme mit min. 13 Nominierungen", x = "Anzahl der Nominierungen", y = "Nominierte") +
                theme(plot.title = element_text(hjust = 0.5), legend.title = element_text(hjust = 0.5)) +
                scale_x_continuous(breaks=c(0:14))
        }
        

    })
    
    output$topCategories <- renderPlot({
        top_categories_filtered <- filter(oscars_tbl, category %in% biggest_categories$category) 
        top_categories_filtered |> 
            ggplot(aes(category, year_ceremony)) +
            geom_boxplot(aes(colour = category, fill = after_scale(alpha(colour, 0.4)))) +
            coord_flip() +
            scale_y_continuous(breaks = c(1928,1950, 1975, 2000, 2020)) +
            theme(legend.position = "none", plot.title = element_text(hjust = 0.5)) + labs(title = "Top 10 Kategorien zeitliche Verteilung", x = "Kategorie", y = "Jahr der Verleihung")
        
        
    })
    
    
    output$winners <- renderPlot({
        # Kategorien
        most_freq_names <- count(winners, name) %>% arrange(desc(n)) %>% top_n(10, n)
        top_directors_nom <- filter(winners, category == "DIRECTING") %>% count(name) %>% arrange(desc(n)) %>% top_n(10, n)
        top_actors_n <- filter(winners, grepl('ACTOR*|ACTRESS*', category)) %>% count(name) %>% arrange(desc(n)) %>% top_n(5, n)
        most_freq_films <- winners %>% drop_na() %>%  count(film,year_film) %>% arrange(desc(n)) %>% top_n(5, n)
        
        # gefilterte Kategorien
        top_names_filtered <- filter(winners, name %in% most_freq_names$name)
        top_directors_filtered <- filter(winners, category == "DIRECTING") %>% filter(name %in% top_directors_nom$name)
        top_actors_n_filtered <- filter(winners, grepl('ACTOR*|ACTRESS*', category)) %>% filter(name %in% top_actors_n$name)
        top_films_filtered <- winners %>% filter(film %in% most_freq_films$film) %>% filter(!(film == 'Titanic' & year_film == 1953))
        
        if (input$winningCat == "Org. Name") {
            ggplot(top_names_filtered, aes(y = fct_rev(fct_infreq(sub(name ,pattern = "(\\w{8}).*",replacement = "\\1."))))) + 
                geom_bar() + labs(title = "Personen, Organisationen oder Länder mit min. 22 Nominierungen", x = "Anzahl der Auszeichnungen", y = "Auszeichnete") +
                theme(plot.title = element_text(hjust = 0.5), legend.title = element_text(hjust = 0.5))  
            
        } else if (input$winningCat == "Regisseure") {
            ggplot(top_directors_filtered, aes(y = fct_rev(fct_infreq(name)))) + 
                geom_bar() + labs(title = "Top Regisseure (min. 2 Auszeichnungen)", x = "Anzahl der Auszeichnungen", y = "Auszeichnete") +
                scale_x_continuous(breaks=c(0:12)) + 
                theme(plot.title = element_text(hjust = 0.5), legend.title = element_text(hjust = 0.5))
            
        } else if (input$winningCat == "SchauspielerInnen") {
            ggplot(top_actors_n_filtered, aes(y = fct_rev(fct_infreq(name)))) + 
                geom_bar() + labs(title = "Top SchauspielerInnen (min. 3 Auszeichnungen)", x = "Anzahl der Auszeichnungen", y = "Auszeichnete") +
                scale_x_continuous(breaks=c(0:21)) + 
                theme(plot.title = element_text(hjust = 0.5), legend.title = element_text(hjust = 0.5)) 
            
        } else {
            ggplot(top_films_filtered, aes(y = fct_rev(fct_infreq(film)))) + 
                geom_bar() + labs(title = "Top Filme (min. 9 Auszeichnungen)", x = "Anzahl der Auszeichnungen", y = "Auszeichnete") +
                theme(plot.title = element_text(hjust = 0.5), legend.title = element_text(hjust = 0.5)) +
                scale_x_continuous(breaks=c(0:14))
        }
    })
    
    output$winVsNom <- renderPlot({
        ggplot(oscars_tbl, aes(x = winner, y = ..prop.., group = 1, fill = factor(..x..))) +
            geom_bar() +
            scale_fill_discrete(guide = guide_legend(reverse=TRUE), name = "Auszeichnung", labels = c("Nein", "Ja")) +
            scale_x_discrete(labels = (c("Nein", "Ja"))) +
            scale_y_continuous(limits = c(0,1)) +
            labs(title = "Auszeichnungen bei Nominierung", x = "Auszeichnung",
                 y = "Nomierungen (relativ)") + 
            theme(plot.title = element_text(hjust = 0.5), legend.title = element_text(hjust = 0.5))
    })
    # -----------------------------------------------------------------------
    
    
    # Prediction-Models-Tab ------------------------------------------------
    # Table
    output$merged_table <- DT::renderDataTable({
        DT::datatable(
            oscars_merged |> pivot_wider(everything()), options=list(
                pageLength = 5,
                lengthMenu = c(10, 25, 50),
                scrollX = TRUE,
                scrollY = TRUE)
        )
    })
    
    
    
    # Result Visualization
    
    # Table
    headers <- c("", "Accuracy", "Recall", "Precision", "F1")
    nbData <- c("Naive-Bayes", 0.7857, 0.9231, 0.8276, 0.8727)
    rfData <- c("RandomForest", 0.8454, 0.8539, 0.9744, 0.9102)
    nnData <- c("NeuralNetwork", 0.7959, 0.9870, 0.8000, 0.8837)
    predData <- data.frame(headers, nbData, rfData, nnData)
    
    output$resultsTable <- renderTable({predData}, rownames = FALSE, colnames = FALSE, align = "c", spacing = "l", width = "100%")
    
    # Graph
    output$resultsGraph <- renderPlot({
        
    })
    
    # ----------------------------------------------------------------------- 
    
    
    # 2022-Prediction-Tab ------------ --------------------------------------
    # ----------------------------------------------------------------------- 
    output$distPl <- renderPlot({
        
        
    })
    

})
