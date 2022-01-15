library(httr)
library(rjson)

film = c("The Power of The Dog", "Belfast", "CODA", "Dune", "King Richard")
ceremony = c(93, 93, 93, 93, 93)
name = c("Jane Campion, Producer", "Kenneth Branagh, Producer", "Sian Heder, Producer", "Denis Villeneuve, Producer", "Reinaldo Green, Producer")
#winner = c()
year = c(2021, 2021, 2021, 2021, 2021)
Rating_IMDB = c(7.0, 7.4, 8.1, 8.1, 7.6) 
Oscarstat_totalnoms = c(7, 7, 2, 3, 4)
Nom_Oscar_bestdirector = c(NA, NA, NA, NA, NA)
Rating_rtcritic = c(95, 87, 96, 83, 90)
Nom_GoldenGlobe_bestdrama = c(1, 1, 1, 1, 1) 
Win_GoldenGlobe_bestdrama = c(1, 0, 0, 0, 0)
genre = c("Drama", "Drama", "Drama", "Drama", "Drama")

goldenglobes = data.frame(film, ceremony, name, year, Rating_IMDB, Oscarstat_totalnoms, Nom_Oscar_bestdirector, Rating_rtcritic, Nom_GoldenGlobe_bestdrama, Win_GoldenGlobe_bestdrama)

str = toJSON(goldenglobes)

content(POST("http://127.0.0.1:8080/oscars-rf", body = str, encode = "json"))