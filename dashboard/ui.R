library(shiny)
library(tidyverse)
library(tidyr)
library(shinydashboard)
library(ggridges)
library(waffle)

ui <- dashboardPage(
    dashboardHeader(title = "Oscar Data Visualisierung und Vorhersage"),
    dashboardSidebar(
        sidebarMenu(
            menuItem("Historische Daten", tabName = "histData", icon = icon("dashboard")),
            menuItem("Vorhersagemodellen", tabName = "predModels", icon = icon("dashboard")),
            menuItem("Oscar 2022: Vorhersage", tabName = "oscars2022", icon = icon("dashboard")),
            menuItem("Oscar-Tabelle", tabName = "fullTable", icon = icon("dashboard"))
        )
    ),
    dashboardBody(
        tabItems(
            
            # Historical Data Tab
            tabItem(
                tabName = "histData",
                fluidRow(
                    column(6,
                        #title and dropdown for graphs
                        fluidRow(
                            column(6, h3("Top Nominierungen")),
                            column(5, selectInput("nomCategories", "", c("Org. Name", "Regisseure", "SchauspielerInnen", "Filme")))
                            ),
                        #graph
                        box(plotOutput("nominated"), width = 12)   
                    ),
                    column(6, 
                           # title and infobox
                           fluidRow(
                               column(6, h3("Top 10 Kategorien (zeitliche Verteilung)")),
                               column(5)
                           ),
                           #graph
                           box(plotOutput("topCategories"), width = 12))
                    ),
                
                fluidRow(
                    column(6,
                           #title and dropdown for graphs
                           fluidRow(
                               column(6, h3("Top Gewinner")),
                               column(5, selectInput("winningCat", "", c("Org. Name", "Regisseure", "SchauspielerInnen", "Filme")))
                           ),
                           #graph
                           box(plotOutput("winners"), width = 12) 
                ), 
                         column(6, box(plotOutput("winVsNom"), width = 12)))
            ),
            # ----------------------
            
            # Prediction-Models Tab
            tabItem(
                tabName = "predModels",
                fluidRow(
                    column(4,
                        h3("Data Modellng und Vorhersage"),
                        box(
                            p("In diesem Teil des Projektes wurden verschiedenen Klassifizierungsmethoden miteinander vergleicht Anhand der Daten aus dem Oscar-Dataset und 'oscardata_bestpicture' (*Kaggle: Data on Oscar nominated films between 1960 and 2021*) Datensatz, um den urprünglichen Datensatz mit Daten aus IMDB (Film und Rating-Website) zu
                            Wir benutzen die **Klassifikation**, um eine kategoriale Variable vorhersagen zu können.
                            In diesem Projekten haben wir uns fokussiert auf 3 unterschiedliche Methoden, die oft in Data Science Anwendungen zu diesem Zweck verwendet werden: *Random Forest*, *Naive Bayes Classifiers* und *Neural Networks*.
                            Die 3 erwähnte Methoden werden miteinander verglichen, und die Methode mit dem besten Ergebnis beim Performance Assesment wird anschließend für die Vorhersage angewendet.
                            "),
                            helpText(""), width = 12    
                        )
                    ),
                    column(8,
                        box(DT::dataTableOutput("merged_table"), width = 12, style = "height:500px; overflow-y: scroll;")
                    )
                ),
                
                fluidRow(
                    column(4,
                        #title 
                        h3("Ergebnisse: "),
                        
                        #graph
                        box(plotOutput("resultsView"), width = 12)
                    ),
                    column(
                        8,
                        selectInput("visualization", "", c("Tabellenform", "Graphische Darstellung", "Detail-Darstellung")),
                        box(
                            
                            # Table form
                            conditionalPanel(
                                condition = "input.visualization == 'Tabellenform'",
                                tags$head(
                                    tags$style(
                                        "tr:nth-child(1) {font-weight: bold;}
                                        td:nth-child(1) {font-weight: bold;}"
                                    )
                                ),
                                tableOutput("resultsTable"), width = 12
                                    ), 
                            
                            # Graph form 
                            conditionalPanel(
                                condition = "input.visualization == 'Graphische Darstellung'",
                                tableOutput("resultsGraph")
                            ), 
                            width = 12
                            )
                        
                    )
                )
            ),
            # ---------------------
            
            
            # Oscar 2022 Tab
            tabItem(
                tabName = "oscars2022",
                column(5,
                       h3(),
                       p(),
                       br(),
                       p()
                       ),
                
                column(7, 
                       "Infographic comes here"
                       )
            ),
            # ---------------------
            
            
            # Full data tab
            tabItem(
                tabName = "fullTable",
                box(DT::dataTableOutput("fullTable"))
            )
            # ---------------------
        )
    )
)
