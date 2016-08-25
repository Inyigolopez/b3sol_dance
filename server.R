# List of packages for session
.packages = c("shiny", "randomcoloR", "igraph")

# Install CRAN packages (if not already installed)
.inst <- .packages %in% installed.packages()
if(length(.packages[!.inst]) > 0) install.packages(.packages[!.inst])

# Load packages into session 
lapply(.packages, require, character.only=TRUE)

shinyServer(function(input,output){

  parameters <- reactive({
    inputFile <- input$dataset
    if(is.null(inputFile)){
      return()
    }
    read.table(inputFile$datapath, nrows=1, header = FALSE, sep = " ", col.names = c("nodes", "edges"))
  })
  
  edges <- reactive({
    inputFile <- input$dataset
    if(is.null(inputFile)){
      return()
    }
    read.table(inputFile$datapath, header = TRUE, sep = " ", col.names = c("node1", "node2"))
  }) 
  
  output$edgesDF <- renderTable({
    if(is.null(edges())){
      return()
    }
    edges()
  })
  
  output$tb <- renderUI({
    if(is.null(data()))
      h5("No data")
    else
      tabsetPanel(tabPanel("Data", tableOutput("table")))
  })
  
  output$plotGraph <- renderPlot({
    g2 <- graph.data.frame(edges(), directed = FALSE)
    g <- simplify(g2)
    
    numNodes <- vcount(g)
    numEdges <- ecount(g)
    
    colorArray <- rainbow(n=numNodes)
    
    colorCodeArray <- 1:numNodes
    paletteColors <- 1:numNodes
    
    matrixAdjacency <- get.adjacency(g, names=TRUE, sparse=TRUE)
    colnames(matrixAdjacency) <- rownames(matrixAdjacency)
    auxiliarColorCodeArray <- array(0,dim=c(numNodes))
    names(auxiliarColorCodeArray) <- 0:(numNodes-1)
    
    for (i in as.numeric(colnames(matrixAdjacency))) {
      for (colorPruebaIndex in 1:length(colorCodeArray)){
        connectedColor <- FALSE
        for (j in as.numeric(colnames(matrixAdjacency))) {
          if (connectedColor == FALSE && matrixAdjacency[toString(i), toString(j)] == 1 && unname(auxiliarColorCodeArray[j+1]) == colorPruebaIndex ){
            connectedColor <- TRUE
            break
          }
        }
        if (connectedColor == FALSE) {
          auxiliarColorCodeArray[i+1] <- colorPruebaIndex
          paletteColors[i+1] <- colorArray[colorPruebaIndex]
          break
        }
      }
    }
    
    colorNodes <- unname(auxiliarColorCodeArray)
    V(g)$color <- paletteColors
    
    plot.igraph(g,layout=layout.mds)
    
  })
  
  output$colorArray <- renderTable({
    
    g2 <- graph.data.frame(edges(), directed = FALSE)
    g <- simplify(g2)
    
    numNodes <- vcount(g)
    numEdges <- ecount(g)
    
    colorArray <- rainbow(n=numNodes)
    
    colorCodeArray <- 1:numNodes
    paletteColors <- 1:numNodes
    
    matrixAdjacency <- get.adjacency(g, names=TRUE, sparse=TRUE)
    colnames(matrixAdjacency) <- rownames(matrixAdjacency)
    auxiliarColorCodeArray <- array(0,dim=c(numNodes))
    names(auxiliarColorCodeArray) <- 0:(numNodes-1)
    
    for (i in as.numeric(colnames(matrixAdjacency))) {
      for (colorPruebaIndex in 1:length(colorCodeArray)){
        connectedColor <- FALSE
        for (j in as.numeric(colnames(matrixAdjacency))) {
          if (connectedColor == FALSE && matrixAdjacency[toString(i), toString(j)] == 1 && unname(auxiliarColorCodeArray[j+1]) == colorPruebaIndex ){
            connectedColor <- TRUE
            break
          }
        }
        if (connectedColor == FALSE) {
          auxiliarColorCodeArray[i+1] <- colorPruebaIndex
          paletteColors[i+1] <- colorArray[colorPruebaIndex]
          break
        }
      }
    }
    as.data.frame(auxiliarColorCodeArray)
    
  })
    
  
})