library(visNetwork)

createGraph <-function(df, drugs, fileName, shape, colorByATC = F){
  #sort drugs in alphabetical order for easy search
  drugs <- sort(drugs)
  
  if(colorByATC){

     group <- unlist(lapply(drugs, function(d) ifelse(d %in% data$atcCodeMapping$Drug,
                                                      data$atcCodeMapping$ATC.Category[data$atcCodeMapping$Drug == d],
                                                      "None")))

  }else{
    ##set nodes
    group <- unlist(lapply(shape, function(s) ifelse(s == "circle",
                                                     "searched",
                                                     "found")))
  } 
  ##set nodes
  nodes <- data.frame(id = drugs,
                      title = paste("Drug:", drugs),
                      label=drugs,
                      group = group,
                      shape = shape)
  
  edges <- data.frame(from = df$drug1, to = df$drug2,
                      label = signif(df$Probability, digits=3))
  
  full_subnetwork <- visNetwork(nodes, edges, main = "Drugs with Shared Indications", 
                                height = "700px", width = "100%") %>%
    visOptions(highlightNearest = list(enabled =TRUE, degree = 1, hover = T),
               nodesIdSelection = TRUE, selectedBy = "group") %>%
    visPhysics(solver = "barnesHut")%>%
    visIgraphLayout() %>%
    visNodes(size = 10) %>% 
    visLegend() 
  visSave(full_subnetwork, fileName, selfcontained = TRUE, background = "white")
}

##Get Output
getDiseaseBasedResult <- function(diseasesOfInterest, probability = 0.95, 
                               fileName = NULL, 
                               colorByATC = F){


  catnipPrediction <- data$catnipPrediction

  ##Check for drug
  if(length(intersect(dseasesOfInterest, data$diseaseMapping$CUID)) == 0){
    stop("This disease is either not in the dataset or under a different name.")
  }
  
  
  ##get drugs of interest
  drugsOfInterest <- subset(data$diseaseMapping, CUID %in% diseasesOfInterest)$DrugName
  ##subset network
  dataOfInterest <- subset(catnipPrediction, 
                           (drug1 %in% drugsOfInterest | drug2 %in% drugsOfInterest) &
                             Probability >= probability)
  if(nrow(dataOfInterest) ==0){
    stop("No Predictions Found. Try lowering probability cut-off.")
  }
  if(!is.null(fileName)){
    drugs <- unique(c(dataOfInterest$drug1,dataOfInterest$drug2))
    shape <- ifelse(drugs %in% drugsOfInterest, "circle","square")
    createGraph(dataOfInterest , drugs = drugs, shape = shape,
                fileName =  fileName, colorByATC = colorByATC)
  }
  return(dataOfInterest)
}

getDrugBasedResult <- function(drugsOfInterest, probability = 0.95, 
                           fileName = NULL,
                           colorByATC = F, strict = T){
  ##Format drugs 
  drugsOfInterest <- toupper(drugsOfInterest)
  ##Only include drugs with indications
  catnipPrediction <- data$catnipPrediction
  
  ##Check for drug
  if(length(intersect(drugsOfInterest, unique(c(catnipPrediction$drug1,
                                                catnipPrediction$drug2)))) == 0){
    stop("This drug is either not in the dataset or under a different name.")
  }
  
  ##subset network
  dataOfInterest <- subset(catnipPrediction, 
                           (drug1 %in% drugsOfInterest | drug2 %in% drugsOfInterest) &
                             Probability >= probability)
  if(nrow(dataOfInterest) ==0){
    stop("No Predictions Found. Try lowering probability cut-off.")
  }

  if(! is.null(fileName)){
    drugs <- unique(c(dataOfInterest$drug1,dataOfInterest$drug2))
    shape <- ifelse(drugs %in% drugsOfInterest, "circle","square")
    createGraph(dataOfInterest , 
                drugs = drugs, shape = shape, 
                fileName =  fileName, colorByATC =colorByATC)
  }
  return(dataOfInterest)
}

data=readRDS(paste0(dirname(sys.frame(1)$ofile),"/CATNIP.rds"))
