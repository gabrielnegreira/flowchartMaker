#Flow Chart Maker V1.1
#Author: Gabriel H. Negreira
#input must be an excel file with at least 3 columns named "id", "from" and "name".

#parameter

#get the variables which are already loaded in the environment so they are not removed at the end
to_keep <- ls(envir=parent.frame())

save_chart <- TRUE #if TRUE, will save the flow chart in the current working directory. If FALSE, will display the chart in the Viewer tab instead. 
clean_environment <- FALSE #if TRUE, will remove all dataframes, variables, etc, after the code is run.
color_by <- NA #Set to a string with the name of the column to use to color nodes or set it to NA. 

#Installing libraries if needed:
packages <- c("tidyverse", "stringr", "readr", "visNetwork", "readxl")

## Now load or install&load all
package.check <- lapply(
  packages,
  FUN = function(x) {
    if (!require(x, character.only = TRUE)) {
      install.packages(x, dependencies = TRUE)
      library(x, character.only = TRUE)
    }
  }
)

#getting input
suppressWarnings(rm(input_file))
suppressWarnings(rm(nodes))
suppressWarnings(rm(edges))
print("Select the file to build the flow chart:")
input_file <- file.choose()
nodes <- read_excel(input_file)

#checking if a file was provided
if(!exists("nodes")){
  stop("A file is required to run the script.")
  #if a file was provided, make the chart
}else{
  #setting variables:
  file_name <- basename(input_file)
  file_name <- unlist(strsplit(file_name, ".xl"))[1]
  flow_name <- paste("Flow chart of", file_name)
  nodes_size <- 100
  
  #creating custom functions:
  
  #this function will create the html text for the floating boxes that appear when you pass the mouse over a node.
  make_title <- function(nodes){
    items <- colnames(nodes)
    title <-c()
    for(i in c(1:length(items))){
      item <- paste("<b>", items[i], ":</b>", sep = "") #here it will make the name of an item (ex: "Passage Number" as bold in html code)
      values <- unlist(nodes[,i]) 
      named_items <- paste(item, values) #for each item, it will bind the item name (ex. "Passage Number") to its values (ex. "<b>Passage Number:<\b> 3")
      title <- cbind(title, named_items) 
      
    }
    title <- apply(title, 1, paste, collapse = "<br>") #here it will add a breakline html code to break each item in a line
    return(title)
  }
  
  #formating lists:
  colnames(nodes) <- str_trim(colnames(nodes)) #to ensure no space is flanking the names
  
  nodes <- nodes %>%
    mutate(id = gsub(" ", "", id)) %>% #id will have spaces removed
    mutate(id = toupper(id)) #id will be all uppercase
  
  nodes <- filter(nodes, !is.na(id)) #remove rows which doesn't have an id
  nodes <- nodes[!duplicated(nodes$id),] #remove different rows with the same id
  nodes$title <- make_title(nodes)
  nodes$label <- nodes$name
  
  if(tolower(color_by) %in% tolower(colnames(nodes))){
    column <- which(tolower(colnames(nodes)) == tolower(color_by))
    nodes <- cbind(nodes, nodes[,column])
    colnames(nodes)[length(colnames(nodes))] <- "group"
    rm(column)
  }
  
  #building edge list
  edges <- data.frame(cbind(nodes$from, nodes$id))
  colnames(edges) <- c("from", "to")
  edges$arrows <- "to"
  
  #making sure ids in the edge list are formatted according to the ids in the nodes list. 
  edges <- edges %>%
    mutate(from = gsub(" ", "", from)) %>%
    mutate(from = toupper(from)) %>%
    mutate(to = gsub(" ", "", to)) %>%
    mutate(to = toupper(to))
  
  #making the chart
  if(save_chart){
    #get the path where input file was so output graph is saved in the same place
    path <- paste(dirname(input_file),"/",file_name, "_flow_chart.html", sep = "")
    visNetwork(nodes = nodes, edges = edges, width = "100%", height = "85vh", main = flow_name)%>%
      visNodes(shape = "box",physics = FALSE, color = list(background = "lightblue", border = "black", highlight = "orange", hover = list(background = "#037ca1", border = "black")), widthConstraint = list(maximum = 220), margin = 15, labelHighlightBold = TRUE, scaling = list(label = list(drawThreshold = 1)))%>%
      visEdges(physics = FALSE, smooth = FALSE, width = 4, color = "black", arrowStrikethrough = FALSE, font = list(size = 32, color = "white", strokeColor = "black", strokeWidth = 8))%>%
      visHierarchicalLayout(levelSeparation = 150, nodeSpacing = 260, treeSpacing = 300, direction = "UD", sortMethod = "directed")%>%
      visOptions(manipulation = FALSE, highlightNearest = list(enabled = TRUE, algorithm = "hierarchical" , degree = list(from = 100, to = 100), labelOnly = FALSE), nodesIdSelection = list(enabled = TRUE, main = "Select By Name"), selectedBy = "id", collapse = FALSE)%>%
      visInteraction(tooltipDelay = 500, hover = TRUE, keyboard = TRUE)%>%
      visEvents(type = "once", beforeDrawing = "function() {this.moveTo({scale:0.05})}")%>%
      visExport() %>%
      visSave(path)
    print(paste("Flow chart saved at", path))
  }else{
    visNetwork(nodes = nodes, edges = edges, main = flow_name)%>%
      visNodes(shape = "box",physics = FALSE, color = list(background = "lightblue", border = "black", highlight = "orange", hover = list(background = "#037ca1", border = "black")), widthConstraint = list(maximum = 220), margin = 15, labelHighlightBold = TRUE, scaling = list(label = list(drawThreshold = 1)))%>%
      visEdges(physics = FALSE, smooth = FALSE, width = 4, color = "black", arrowStrikethrough = FALSE, font = list(size = 32, color = "white", strokeColor = "black", strokeWidth = 8))%>%
      visHierarchicalLayout(levelSeparation = 150, nodeSpacing = 260, treeSpacing = 300, direction = "UD", sortMethod = "directed")%>%
      visOptions(manipulation = FALSE, highlightNearest = list(enabled = TRUE, algorithm = "hierarchical" , degree = list(from = 100, to = 100), labelOnly = FALSE), nodesIdSelection = list(enabled = TRUE, main = "Select By Name"), selectedBy = "id", collapse = FALSE)%>%
      visInteraction(tooltipDelay = 500, hover = TRUE, keyboard = TRUE)%>%
      visEvents(type = "once", beforeDrawing = "function() {this.moveTo({scale:0.05})}")%>%
      visExport()
  }
}
if(clean_environment){
  suppressWarnings(rm(list = ls(envir=parent.frame())[which(!ls(envir=parent.frame()) %in% to_keep)]))
}
