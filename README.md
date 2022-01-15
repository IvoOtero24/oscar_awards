# oscar_awards

## Allgemein

Das Projekt kann in RStudio mit der Datei "oscar_awards.Rproj" geöffnet werden.

## Projektstruktur

### analysis

Im Ordner *analysis* befinden sich Explorative Analyse und Visualisierungen der Daten, sowie die Modellierung für die Vorhersage Modelle. Beide Teile können jeweils als PDF oder per RMarkdown file in RStudio geöffnet werden. 

### dashboard

Im Ordner *dashboard* befinden sich die Dateien "server.R" und "ui.R" der Shiny Web App. Zum Ausführen in RStudio genügt das Öffnen und Ausführen der "server.R"-Datei. 

### data

Im Ordner *data* befindet sich der Ausgangsdatensatz "the_oscar_award.csv" und der Datensatz "oscardata_bestpicture.csv", der für die Modellierung benötigt ist. Aus den beiden Datein wurde die Datei "oscars_merged.csv" erstellt. Im Unterordner *images* befinden sich außerdem noch Bilder, welche für die Visualisierung nötig sind. 
Quellen: the_oscar_award.csv -> https://www.kaggle.com/unanimad/the-oscar-award
         oscardata_bestpicture.csv -> https://www.kaggle.com/matevaradi/oscar-prediction-dataset

### webservice

Die Anleitung zur Ausführung des Webservices befindet sich in der Datei "Webservice_Dokumentation-README-.pdf". 
Zum Ausführen müssen folgende Packages installiert sein: "plumber", "httr", "rjson".

## Packages installieren

Zum Ausführen der Files müssen folgende R Packages installiert sein: "tidyverse", "ggplot2", "pander", "dplyr", "class", "caret", "e1071", "randomForest", "sjmisc", "shiny", "shinydashboard", "tidyr", "ggridges", "waffle", "plumber", "httr", "rjson".

## Bonus Features

- *Interaktion* im Shiny Dashboard
- Vorhersage für Oscars 2022 
