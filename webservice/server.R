## Expose prediction model as web service

## startup: read model

library(rjson)
load("model.rda")

decode <- function(s)
{
  as.data.frame(fromJSON(s$postBody))
}

#* @post /oscars-rf
#* @json
function(req)
{
  as.character(try(predict(model_rf, decode(req), type = "prob")))
}

## add more interfaces, if needed -- e.g., for other models.
