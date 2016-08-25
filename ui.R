# List of packages for session
.packages = c("shiny", "randomcoloR", "igraph")

# Install CRAN packages (if not already installed)
.inst <- .packages %in% installed.packages()
if(length(.packages[!.inst]) > 0) install.packages(.packages[!.inst])

# Load packages into session 
lapply(.packages, require, character.only=TRUE)

library(shiny)
library(igraph)

filenames<-list.files(path = "./data/", all.files = TRUE)

shinyUI(pageWithSidebar(
  
  headerPanel(
    "Dance with somebody"
  ),
  
  sidebarPanel(
    fileInput("dataset", label = h3("Selecciona el problema: "))
    #,submitButton("Resolver problema")
  ),

  mainPanel(
    tabsetPanel(
      tabPanel("Solucion", plotOutput("plotGraph")),
      tabPanel("Solucion Númerica", tableOutput("colorArray")),
      tabPanel("Rivalidad",tableOutput("edgesDF"))
    )
  )
))
