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
            menuItem("Historische Daten", tabName = "histData", icon = icon("history")),
            menuItem("Vorhersagemodellen", tabName = "predModels", icon = icon("project-diagram")),
            menuItem("Oscar 2022: Vorhersage", tabName = "oscars2022", icon = icon("star")),
            menuItem("Oscar-Tabelle", tabName = "fullTable", icon = icon("table"))
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
                hr(style = "border-top: 1px solid #BFC9CA;"),
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
                    column(6, 
                           h3("Gewinner vs Nominierten"),
                           br(),
                           box(plotOutput("winVsNom"), width = 12)
                           )
                )
            ),
            # ----------------------
            
            # Prediction-Models Tab
            tabItem(
                tabName = "predModels",
                fluidRow(
                    column(4,
                        h3("Data Modellng und Vorhersage"),
                        sidebarPanel(
                            HTML("In diesem Teil des Projektes wurden verschiedenen Klassifizierungsmethoden miteinander verglichen <br>Anhand der Daten aus dem <b>Oscar-Dataset</b> und <b>oscardata_bestpicture</b> aus Kaggle (https://www.kaggle.com/matevaradi/) <br>
                            um den urprünglichen Datensatz mit Daten aus IMDB (Film und Rating-Website) zu erwitern.
                            <hr>
                            Wir benutzen die Methode der <b>Klassifikation</b>, um die kategoriale Variable <i>winner</i> vorhersagen zu können. <br>
                            In diesem Projekt haben wir uns auf 3 unterschiedliche Methoden fokussiert: <b>Random Forest</b>, <b>Naive Bayes Classifier</b> und <b>Neural Networks</b>. <br>
                            <hr>
                            Diese Methoden wurden anhand eines <i>Performance Assesment</i> miteinander verglichen, und die beste Methode für die Vorhersage anzuwenden.
                            "),
                            helpText(""), width = 12    
                        )
                    ),
                    column(8,
                        h4("'Best Picture' Tabelle (Oscar + IMDB Daten)"),
                        box(DT::dataTableOutput("merged_table"), width = 12, style = "height:450px; overflow-y: scroll"), style = ""
                    )
                ),
                hr(style = "border-top: 1px solid #BFC9CA;"),
                fluidRow(
                    column(6,
                        h3("Ergebnisse (Training):"),
                        sidebarPanel(
                            HTML("Alle Modelle wurden mit den gleichen <i>training</i> und <i>test</i> Daten trainiert.
                                Bei den Ergebnissen zeigte sich das <b>RandomForest</b> als der beste für die 'Best Picture' vorhersage.  
                                "),
                            hr(),
                            h4("Code Behind:"),
                            p("RandomForest: ", code('train(winner ~ Oscarstat_totalnoms + Rating_rtcritic + Win_GoldenGlobe_bestdrama,
                                                        data = train,
                                                        method = "rf",
                                                        preProcess = c("scale", "center"),
                                                        tuneGrid = data.frame(mtry = 1))')),
                            p("NaiveBayes: ", code('train(winner ~ Win_GoldenGlobe_bestdrama + Oscarstat_totalnoms + Rating_rtcritic,
                                                        data = train,
                                                        method = "nb",
                                                        preProcess = c("scale", "center")
                                                        )')),
                            p("NeuralNetwork: ", code('train(winner ~  Win_GoldenGlobe_bestdrama + Oscarstat_totalnoms + Rating_rtcritic,
                                                        data = train,
                                                        method = "nnet",
                                                        preProcess = c("scale", "center"),
                                                        tuneGrid = data.frame(size = 1, decay = seq(from = 0.01, to = 0.11, by = 0.01)))'))
                            
                            , width = 12, style = "margin-top: 5%")
                    ),
                    column(
                        6,
                        fluidRow(
                            column(6, h3("Perfomance Assesment:"), style = ""),
                            column(6, selectInput("visualization", "", c("Tabellenform", "Graphische Darstellung")))
                        ),
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
                                h4("Accuracy und Kappa der verschiedenen Vorhersagemodellen:"),
                                imageOutput("resultsGraph"),
                                hr(),
                                p("*Auch hier erkennt man, dass obwohl alle Modelle eine hohe Accuracy haben, das RandomForest besser beim Kappa-Wert ausschneidet.")
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
                column(7,
                       h1("Oscar 2022: Vorhersage"),
                       sidebarPanel(
                            tags$p(HTML('Für die Vorhersage der 2022 Oscars wurde die gleiche Klassifikationsmethode benutzt (<b>RandomForest</b>), <br> aber doch mit
                            einem wichtigen Unterschied: <br> in diesem Fall die Anzahl an Nominierungen bei den <b>"Golden Globes Award"</b> wurden als
                            Variablen genommen, da die ofizielle Oscar-Nominierungen für "Best Picture" noch nicht bekannt sind (erst in März 2022)')),
                            hr(),
                            tags$p(HTML('Für die "Golden Globes" wurden folgende filme nominiert: ')),
                            HTML("<ul>
                                    <li>
                                    The Power Of The Dog
                                    </li>
                                    <li>
                                    Belfast
                                    </li>
                                    <li>
                                    CODA
                                    </li>
                                    <li>
                                    Dune
                                    </li>
                                    <li>
                                    King Richard
                                    </li>
                                 </ul>")
                            , style = "font-size: 14px" , width = 12 
                       ),
                       h3("Code behind und Ergebnis: "),
                       sidebarPanel(
                           p("Model Train: ", code('train(winner ~ Oscarstat_totalnoms + Rating_rtcritic + Win_GoldenGlobe_bestdrama,
                                data = train,
                                method = "rf",
                                preProcess = c("scale", "center"),
                                tuneGrid = data.frame(mtry = 1))')),
                           p("Vorhersage", code("predict(model_rf, goldenglobes, type = 'prob'")), 
                           h4("Ergebnis:"),
                           p("Obwohl keine der Golgen-Globe-Nominierten Filme laut der Methode eine Chance von über 50% bekamm, 
                             der Film mit der höchste Wahrscheinlichkeit der 2022 Oscar für 'Best Picture' ist..."), width = 12
                       )
                       ),
                       
                        
                
                column(5, 
                       imageOutput("predictionImage")
                        )
            ),
            # ---------------------
            
            
            # Full data tab
            tabItem(
                tabName = "fullTable",
                box(DT::dataTableOutput("fullTable"), width = "100%", height = "100%")
            )
            # ---------------------
        )
    )
)
