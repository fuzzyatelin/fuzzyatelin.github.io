shinyUI(fluidPage(
    
    # App title ----
    titlePanel("True HWE Calculator"),
    
    # Sidebar layout with input and output definitions ----
    sidebarLayout(
      
      # Sidebar panel for inputs ----
      sidebarPanel(
        
        # Input: Slider for the number of bins ----
        
        numericInput("hetero", 
                     "Heterozygous Genotype Count", 
                     0),
        
        numericInput("hom1", 
                     "Homozygous 1 Genotype Count", 
                     0),
        
        numericInput("hom2", 
                     "Homozygous 2 Genotype Count", 
                     0)
        
      ),
      
      # Main panel for displaying outputs ----
      mainPanel(
        
        
        textOutput("HWE")
        
      )
    )
  )