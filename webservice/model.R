oscars_merged <- read.csv(file = "../data/oscars_merged.csv", header = TRUE, sep = ",", encoding = "UTF-8", na.strings = "")

set.seed(23489)
ind = createResample(oscars_merged$winner, times = 1)

train = oscars_merged[ind$Resample1,]
test = oscars_merged[-ind$Resample1,]

model_rf = train(winner ~ Oscarstat_totalnoms + Rating_rtcritic + Win_GoldenGlobe_bestdrama,
                 data = train,
                 method = "rf",
                 preProcess = c("scale", "center"),
                 tuneGrid = data.frame(mtry = 1))

save(model_rf, file = "model.rda")


